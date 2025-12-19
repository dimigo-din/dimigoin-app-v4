import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/services/push/model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'repository.dart';

class PushService extends GetxController {
  final PushRepository repository;

  AuthService authService = Get.find<AuthService>();

  PushService({PushRepository? repository}) : repository = repository ?? PushRepository();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  @override
  Future<void> onInit() async {
    super.onInit();
    try {
      await initialize();
    } catch (e) {
      log('Firebase initialization error: $e');
    }
  }

  Future<void> initialize() async {
    print('🚀 [Push] Initialize started');
    print('🚀 [Push] Platform: ${Platform.operatingSystem}');

    // web 미지원
    if (kIsWeb) {
      print('🚀 [Push] Web platform detected, skipping initialization');
      return;
    }

    await _initLocalNotification();
    print('🚀 [Push] Local notification initialized');

    await requestPushPermission();
    print('🚀 [Push] Push permission requested');

    // iOS에서 APNs 토큰 명시적 요청
    if (Platform.isIOS) {
      print('🍎 [Push] iOS detected - requesting APNs token');
      try {
        String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) {
          print('🍎 [Push] APNs token received: $apnsToken');
        } else {
          print('⚠️ [Push] APNs token is null - waiting for token refresh');
        }
      } catch (e) {
        print('❌ [Push] Failed to get APNs token: $e');
      }
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      print('🔄 [Push] Token refresh triggered');
      print('🔄 [Push] New FCM token: $fcmToken');
      print('🔄 [Push] Login status: ${authService.isLoginSuccess}');

      if (authService.isLoginSuccess) {
        String? deviceId = await getDeviceId();
        if (deviceId == null) {
          print('❌ [Push] Device ID is null');
          log('FCM Token refreshed but device ID is null: $fcmToken');
          return;
        }

        print('🔄 [Push] Device ID: $deviceId');
        print('🔄 [Push] Sending token to server...');
        await repository.upsertFCMToken(deviceId, fcmToken);
        print('✅ [Push] Token successfully sent to server');
        log('FCM Token updated and sent to server: $fcmToken');
      } else {
        print('⚠️ [Push] User not logged in - token not sent');
        log('FCM Token refreshed but not sent to server (not logged in): $fcmToken');
      }
    }).onError((err) {
      print('❌ [Push] Token refresh error: $err');
      log('FCM Token update failed: $err');
    });

    print('🚀 [Push] Login status: ${authService.isLoginSuccess}');
    if (authService.isLoginSuccess) {
      // iOS의 경우 토큰이 준비될 때까지 약간 대기
      if (Platform.isIOS) {
        print('🍎 [Push] Waiting 500ms for iOS token preparation');
        await Future.delayed(const Duration(milliseconds: 500));
      }
      await syncTokenToServer();
    } else {
      print('⚠️ [Push] User not logged in - skipping initial sync');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📬 [Push] Message received: ${message.notification?.title}');
      if (message.notification != null) {
        _showNotification(message);
      }
    });

    print('✅ [Push] Initialize completed');
  }

  Future<void> _initLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'dimigoin_v4_noti',
      '디미고인 알림',
      description: '디미고인 알림 수신을 위한 채널입니다.',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'dimigoin_v4_noti',
      '디미고인 알림',
      channelDescription: '디미고인 알림 수신을 위한 채널입니다.',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? '알림',
      message.notification?.body ?? '메시지가 도착했습니다.',
      notificationDetails,
    );
  }

  Future<void> requestPushPermission() async {
    print('🔔 [Push] Requesting push notification permission');
    final settings = await FirebaseMessaging.instance.requestPermission();
    print('🔔 [Push] Permission status: ${settings.authorizationStatus}');
    print('🔔 [Push] Alert: ${settings.alert}, Badge: ${settings.badge}, Sound: ${settings.sound}');
  }

  Future<bool> get hasNotificationPermission async {
    if (kIsWeb) {
      return false;
    }

    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
           settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  Future<String?> getFCMToken() async {
    print('🔑 [Push] getFCMToken() called');
    final token = await FirebaseMessaging.instance.getToken();
    print('🔑 [Push] FCM Token: ${token ?? "NULL"}');
    return token;
  }

  Future<void> deleteFCMToken() async {
    await FirebaseMessaging.instance.deleteToken();
  }

  Future<void> syncTokenToServer() async {
    print('🔄 [Push] syncTokenToServer() called');

    // web 미지원
    if (kIsWeb) {
      print('⚠️ [Push] Web platform - sync skipped');
      return;
    }

    if (!authService.isLoginSuccess) {
      print('⚠️ [Push] User not logged in - sync skipped');
      log('Cannot sync FCM token: User not logged in');
      return;
    }

    print('🔄 [Push] Attempting to get FCM token...');
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      print('🔄 [Push] FCM token result: ${fcmToken ?? "NULL"}');

      if (fcmToken != null) {
        print('🔄 [Push] Getting device ID...');
        String? deviceId = await getDeviceId();
        print('🔄 [Push] Device ID result: ${deviceId ?? "NULL"}');

        if (deviceId == null) {
          print('❌ [Push] Cannot sync - Device ID is null');
          log('Cannot sync FCM token: Device ID is null');
          return;
        }

        print('🔄 [Push] Upserting token to server...');
        await repository.upsertFCMToken(deviceId, fcmToken);
        print('✅ [Push] Token successfully synced to server');
        print('✅ [Push] Device ID: $deviceId');
        print('✅ [Push] FCM Token: $fcmToken');
        log('FCM Token synced to server: $fcmToken');
      } else {
        print('❌ [Push] Cannot sync - FCM token is null');
        log('Cannot sync FCM token: Token is null');
      }
    } catch (e) {
      print('❌ [Push] Sync failed with error: $e');
      log('Failed to sync FCM token to server: $e');
    }
  }

  Future<List<NotificationSubject>> getSubjects() async {
    try {
      final response = await repository.getSubjects();
      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<String>> getSubscribedSubjects() async {
    try {
      String? deviceId = await getDeviceId();
      if (deviceId == null) {
        throw PushDeviceIDNullException();
      }

      return await repository.getSubscribedSubjects(deviceId);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> updateSubscribedSubjects(List<String> subjects) async {
    try {
      String? deviceId = await getDeviceId();
      if (deviceId == null) {
        throw PushDeviceIDNullException();
      }

      await repository.updateSubscribedSubjects(deviceId, subjects);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<String?> getDeviceId() async {
    print('📱 [Push] getDeviceId() called');
    try {
      if (kIsWeb) {
        print('📱 [Push] Getting Web device ID');
        // Web
        final webInfo = await _deviceInfo.webBrowserInfo;
        final deviceId = '${webInfo.userAgent}_${webInfo.vendor}';
        print('📱 [Push] Web Device ID: $deviceId');
        return deviceId;
      } else if (Platform.isAndroid) {
        print('📱 [Push] Getting Android device ID');
        // Android
        final androidInfo = await _deviceInfo.androidInfo;
        print('📱 [Push] Android Device ID: ${androidInfo.id}');
        return androidInfo.id;
      } else if (Platform.isIOS) {
        print('📱 [Push] Getting iOS device ID');
        // iOS
        final iosInfo = await _deviceInfo.iosInfo;
        final deviceId = iosInfo.identifierForVendor;
        print('📱 [Push] iOS Device ID (identifierForVendor): ${deviceId ?? "NULL"}');
        return deviceId;
      }
    } catch (e) {
      print('❌ [Push] Failed to get device ID: $e');
      return null;
    }
    print('⚠️ [Push] Unknown platform - returning null');
    return null;
  }

}