import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'package:dimigoin_app_v4/app/services/user/service.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';

class DormPageController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final UserService userService = Get.find<UserService>();

  @override
  void onInit() {
    super.onInit();
    getUserApply();
  }

  Future<void> getUserApply() async {
    try {
      await userService.getUserApply();
    } catch (e) {
      log('Error retrieving user apply: $e');
    }
  }

  bool get schoolViolenceReportEnabled {
    return dotenv.env['ENABLE_SCHOOL_VIOLENCE_REPORT'] == 'true';
  }

  void openStayPage() {
    Get.toNamed('/stay');
  }

  void openLaundryPage() {
    Get.toNamed('/laundry');
  }

  void openFrigoPage() {
    Get.toNamed('/frigo');
  }

  void openWakeupPage() {
    Get.toNamed('/wakeup');
  }

  void openRepairPage() {
    Get.toNamed('/repair');
  }

  void openSchoolViolenceReportPage() {
    Get.toNamed('/school-violence-report');
  }
}
