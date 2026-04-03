import 'dart:developer';

import 'package:get/get.dart';

import 'package:dimigoin_app_v4/app/services/user/service.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';

class HomePageController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final UserService userService = Get.find<UserService>();

  @override
  void onInit() {
    super.onInit();
    getUserTimetable();
    getUserApply();
  }

  Future<void> getUserTimetable() async {
    try {
      int userGrade = authService.user!.userGrade!;
      int userClass = authService.user!.userClass!;

      await userService.getTimeline(userGrade, userClass);
    } catch (e) {
      log('Error retrieving timetable: $e');
    }
  }

  Future<void> getUserApply() async {
    try {
      await userService.getUserApply();
    } catch (e) {
      log('Error retrieving user apply: $e');
    }
  }
}
