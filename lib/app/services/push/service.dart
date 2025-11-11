import 'dart:async';
import 'dart:developer';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
      print('Firebase initialization error: $e');
    }
  }

  Future<void> initialize() async {
    await requestPushPermission();

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      if (authService.isLoginSuccess) {
        await repository.upsertFCMToken(fcmToken);
        log('FCM Token updated and sent to server: $fcmToken');
      } else {
        log('FCM Token refreshed but not sent to server (not logged in): $fcmToken');
      }
    }).onError((err) {
      log('FCM Token update failed: $err');
    });

    await repository.init();
    await _initLocalNotification();

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

  Future<String?> getFCMToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  Future<void> deleteFCMToken() async {
    await FirebaseMessaging.instance.deleteToken();
  }

  Future<void> syncTokenToServer() async {
    if (!authService.isLoginSuccess) {
      log('Cannot sync FCM token: User not logged in');
      return;
    }

    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await repository.upsertFCMToken(fcmToken);
        log('FCM Token synced to server: $fcmToken');
      } else {
        log('Cannot sync FCM token: Token is null');
      }
    } catch (e) {
      log('Failed to sync FCM token to server: $e');
    }
  }
}