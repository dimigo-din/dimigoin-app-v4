import 'package:dimigoin_app_v4/app/provider/model/response.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import './model.dart';

import '../../provider/api_interface.dart';

class PushRepository {
  final ApiProvider api;
  AuthService authService = Get.find<AuthService>();

  String hiveBoxName = 'push_service';
  Box? pushBox;

  PushRepository({ApiProvider? api}) : api = api ?? Get.find<ApiProvider>();

  Future<void> init() async {
    if (pushBox != null) return;
    if (Hive.isBoxOpen(hiveBoxName)) {
      pushBox = Hive.box(hiveBoxName);
    } else {
      pushBox = await Hive.openBox(hiveBoxName);
    }
  }

  Future<void> upsertFCMToken(String deviceId, String fcmToken) async {
    String url = '/student/push/subscribe';

    try {
      await api.put(url, data: {
        'deviceId': deviceId,
        'token': fcmToken,
      });
    } on DioException {
      rethrow;
    }
  }

  Future<DateTime?> getTokenLastUpdatedAt() async {
    await init();
    return pushBox?.get('token_last_updated_at');
  }

  Future<void> setTokenLastUpdatedAt(DateTime dateTime) async {
    await init();
    await pushBox?.put('token_last_updated_at', dateTime);
  }

  Future<void> deleteTokenLastUpdatedAt() async {
    await init();
    await pushBox?.delete('token_last_updated_at');
  }

  Future<List<NotificationSubject>> getSubjects() async {
    String url = '/student/push/subjects';

    try {
      DFHttpResponse response = await api.get(url);

      return (response.data['data'] as Map<String, dynamic>)
          .entries
          .map((entry) => NotificationSubject(
                id: entry.key,
                description: entry.value,
              ))
          .toList();
    } on DioException {
      rethrow;
    }
  }

  Future<List<String>> getSubscribedSubjects(String deviceId) async {
    String url = '/student/push/subjects/subscribed';

    try {
      DFHttpResponse response = await api.get(url, queryParameters: {
        'deviceId': deviceId,
      });

      return (response.data['data'] as List)
          .map((e) => SubscribedNotificationSubject.fromJson(e).identifier)
          .toList();
    } on DioException catch (e) {
      if(e.response?.data['code'] == 'Resource_NotFound'){
        return [];
      }else {
        rethrow;
      }
    }
  }

  Future<void> updateSubscribedSubjects(String deviceId, List<String> subjects) async {
    String url = '/student/push/subjects/subscribed';

    try {
      await api.patch(url, data: {
        'deviceId': deviceId,
        'subjects': subjects,
      });
    } on DioException {
      rethrow;
    }
  }
}