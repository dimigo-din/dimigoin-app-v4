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
    // 알림 권한 요청
    await requestPushPermission();

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      await repository.upsertFCMToken(fcmToken);

      DateTime now = DateTime.now();
      await repository.setTokenLastUpdatedAt(now);
      log('FCM Token updated and sent to server at $now: $fcmToken');
    }).onError((err) {
      log('FCM Token update failed: $err');
    });

    await repository.init();
    await _initLocalNotification();

    checkTokenUpToDate().then((isUpToDate) async {
      if (!isUpToDate) {
        await deleteFCMToken();
        await generateFCMToken();
      } else {
        log('FCM Token is up to date; no need to resend.');
      }
    });

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
      0,
      message.notification?.title ?? '알림',
      message.notification?.body ?? '메시지가 도착했습니다.',
      notificationDetails,
    );
  }

  Future<bool> checkTokenUpToDate() async {
    try {
      DateTime? lastUpdatedAt = await repository.getTokenLastUpdatedAt();
      if (lastUpdatedAt == null) {
        return false;
      }

      final now = DateTime.now();
      final difference = now.difference(lastUpdatedAt);

      if (difference.inDays >= 5) {
        return false;
      }

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<void> requestPushPermission() async {
    await FirebaseMessaging.instance.requestPermission();
  }

  Future<void> generateFCMToken() async {
    await FirebaseMessaging.instance.getToken();
  }

  Future<void> deleteFCMToken() async {
    await FirebaseMessaging.instance.deleteToken();
    await repository.deleteTokenLastUpdatedAt();
  }
}