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
    // web 미지원
    if (kIsWeb) {
      return;
    }

    await _initLocalNotification();

    await requestPushPermission();

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      if (authService.isLoginSuccess) {
        String? deviceId = await getDeviceId();
        if (deviceId == null) {
          log('FCM Token refreshed but device ID is null: $fcmToken');
          return;
        }

        await repository.upsertFCMToken(deviceId, fcmToken);
        log('FCM Token updated and sent to server: $fcmToken');
      } else {
        log('FCM Token refreshed but not sent to server (not logged in): $fcmToken');
      }
    }).onError((err) {
      log('FCM Token update failed: $err');
    });

    if (authService.isLoginSuccess) {
      await syncTokenToServer();
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showNotification(message);
      }
    });
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
    await FirebaseMessaging.instance.requestPermission();
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
    return await FirebaseMessaging.instance.getToken();
  }

  Future<void> deleteFCMToken() async {
    await FirebaseMessaging.instance.deleteToken();
  }

  Future<void> syncTokenToServer() async {
    // web 미지원
    if (kIsWeb) {
      return;
    }

    if (!authService.isLoginSuccess) {
      log('Cannot sync FCM token: User not logged in');
      return;
    }

    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        String? deviceId = await getDeviceId();
        if (deviceId == null) {
          log('Cannot sync FCM token: Device ID is null');
          return;
        }

        await repository.upsertFCMToken(deviceId, fcmToken);
        log('FCM Token synced to server: $fcmToken');
      } else {
        log('Cannot sync FCM token: Token is null');
      }
    } catch (e) {
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
    try {
      if (kIsWeb) {
        // Web
        final webInfo = await _deviceInfo.webBrowserInfo;
        return '${webInfo.userAgent}_${webInfo.vendor}';
      } else if (Platform.isAndroid) {
        // Android
        final androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        // iOS
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.identifierForVendor;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

}