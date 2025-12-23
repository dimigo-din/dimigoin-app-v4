import 'dart:async';
import 'dart:developer';
import 'dart:io';
//import 'package:dimigoin_app_v4/app/routes/routes.dart';
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
        String deviceId = await authService.getDeviceId();

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

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Notification tapped (app in background): ${message.messageId}');
      _handleNotificationTap(message);
    });

    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      log('Notification tapped (app terminated): ${initialMessage.messageId}');
      _handleNotificationTap(initialMessage);
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    log('Notification data: ${message.data}');

    // Navigation logic based on notification type
    // Uncomment and customize the code below when you want to enable deep linking
    /*
    final data = message.data;
    final type = data['type'] as String?;

    if (type == null) return;

    switch (type) {
      case 'stay':
        // Navigate to stay application page
        Get.toNamed(Routes.STAY);
        break;

      case 'wakeup':
        // Navigate to wakeup song page
        Get.toNamed(Routes.WAKEUP);
        break;

      case 'washer':
        // Navigate to washer page
        Get.toNamed(Routes.WASHER);
        break;

      case 'notice':
        // Navigate to specific notice if ID is provided
        // final noticeId = data['noticeId'] as String?;
        // if (noticeId != null) {
        //   Get.toNamed(Routes.MAIN, arguments: {'noticeId': noticeId});
        // } else {
        //   Get.toNamed(Routes.MAIN);
        // }
        Get.toNamed(Routes.MAIN);
        break;

      default:
        // Default: navigate to main page
        Get.toNamed(Routes.MAIN);
        break;
    }
    */
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
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (Platform.isIOS) {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
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
        String deviceId = await authService.getDeviceId();

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
      String deviceId = await authService.getDeviceId();

      return await repository.getSubscribedSubjects(deviceId);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> updateSubscribedSubjects(List<String> subjects) async {
    try {
      String deviceId = await authService.getDeviceId();

      await repository.updateSubscribedSubjects(deviceId, subjects);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}