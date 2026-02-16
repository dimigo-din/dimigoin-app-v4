import 'dart:developer';

import 'package:dimigoin_app_v4/app/services/laundry/model.dart';
import 'package:dimigoin_app_v4/app/services/stay/model.dart';
import 'package:get/get.dart';

import 'package:dimigoin_app_v4/app/services/user/service.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';

class DormPageController extends GetxController {
  final UserService _userService;

  final AuthService authService = Get.find<AuthService>();

  final Rx<StayApply?> stayApply = Rx<StayApply?>(null);
  final Rx<LaundryApply?> laundryApply = Rx<LaundryApply?>(null);

  DormPageController({UserService? userService})
    : _userService = userService ?? UserService();

  @override
  void onInit() {
    super.onInit();
    getUserApply();
  }

  Future<void> getUserApply() async {
    try {
      final userApply = await _userService.getUserApply();

      stayApply.value = userApply.stayApply;
      laundryApply.value = userApply.laundryApply;

      log(
        'User apply retrieved: Stay - ${stayApply.value?.toJson()}, Laundry - ${laundryApply.value?.toJson()}',
      );
    } catch (e) {
      log('Error retrieving user apply: $e');
    }
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
}
