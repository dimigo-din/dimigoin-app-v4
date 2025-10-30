import 'dart:async';
import 'dart:developer';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:get/get.dart';

import 'model.dart';
import 'repository.dart';

class UserService extends GetxController {
  final UserRepository repository;

  AuthService authService = Get.find<AuthService>();

  UserService({UserRepository? repository}) : repository = repository ?? UserRepository();

  @override
  Future<void> onInit() async {
    super.onInit();
    initialize(); 
  }

  Future<void> initialize() async {
  }

  Future<Timetable> getTimeline(int userGrade, int userClass) async {
    try {
      final response = await repository.getTimeline(userGrade, userClass);

      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<UserApply> getUserApply() async {
    try {
      final response = await repository.getUserApply();

      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
