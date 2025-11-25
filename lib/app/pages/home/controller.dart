import 'dart:developer';

import 'package:dimigoin_app_v4/app/services/laundry/model.dart';
import 'package:dimigoin_app_v4/app/services/stay/model.dart';
import 'package:get/get.dart';

import 'package:dimigoin_app_v4/app/services/user/model.dart';
import 'package:dimigoin_app_v4/app/services/user/service.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';

class HomePageController extends GetxController {
  final UserService _userService;

  final AuthService authService = Get.find<AuthService>();

  final Rx<Timetable?> timetable = Rx<Timetable?>(null);
  final Rx<StayApply?> stayApply = Rx<StayApply?>(null);
  final Rx<LaundryApply?> laundryApply = Rx<LaundryApply?>(null);

  HomePageController({UserService? userService})
      : _userService = userService ?? UserService();

  @override
  void onInit() {
    super.onInit();
    getUserTimetable();
    getUserApply();
  }

  Future<void> getUserTimetable() async {
    try { 
      int userGrade = authService.user!.userGrade;
      int userClass = authService.user!.userClass;

      final fetchedTimetable =
          await _userService.getTimeline(userGrade, userClass);

      timetable.value = fetchedTimetable;
    } catch (e) {
      log('Error retrieving timetable: $e');
    }
  }

  Future<void> getUserApply() async {
    try {
      final userApply = await _userService.getUserApply();

      stayApply.value = userApply.stayApply;
      laundryApply.value = userApply.laundryApply;

      log('User apply retrieved: Stay - ${stayApply.value?.toJson()}, Laundry - ${laundryApply.value?.toJson()}');
    } catch (e) {
      log('Error retrieving user apply: $e');
    }
  }
  
}
