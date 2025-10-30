import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

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

  Future<void> upsertFCMToken(String fcmToken) async {
    String url = '/student/push/fcm-token';

    try {
      await api.put(url, data: {
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

}