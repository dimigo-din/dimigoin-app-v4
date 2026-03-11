import 'dart:developer';

import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/services/frigo/model.dart';
import 'package:dimigoin_app_v4/app/services/frigo/service.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

List<String> frigoTiming = [
  "afterschool",
  "dinner",
  "after_1st_study",
  "after_2nd_study",
];

String _getFrigoTimingValue(FrigoTiming timing) {
  switch (timing) {
    case FrigoTiming.afterschool:
      return "afterschool";
    case FrigoTiming.dinner:
      return "dinner";
    case FrigoTiming.afterFirstStudy:
      return "after_1st_study";
    case FrigoTiming.afterSecondStudy:
      return "after_2nd_study";
  }
}

class FrigoController extends GetxController {
  final frigoService = FrigoService();

  final Rx<Frigo?> frigoApplication = Rx<Frigo?>(null);
  final RxInt selectedFrigoTimingIndex = (-1).obs;
  final TextEditingController frigoReasonTEC = TextEditingController();

  final RxBool isApplied = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchFrigoApplication();
  }

  Future<void> fetchFrigoApplication() async {
    try {
      final application = await frigoService.getFrigoApplication();

      frigoApplication.value = application;
      frigoReasonTEC.text = application.reason;
      selectedFrigoTimingIndex.value = frigoTiming.indexOf(
        _getFrigoTimingValue(application.timing),
      );

      isApplied.value = true;
    } catch (e) {
      frigoApplication.value = null;
      isApplied.value = false;
      log('Error fetching frigo application: $e');
      return;
    }
  }

  Future<void> addFrigoApplication() async {
    try {
      final reason = frigoReasonTEC.text.trim();
      if (reason.isEmpty) {
        DFSnackBar.error("금요귀가 신청 사유를 입력해주세요.");
        return;
      }

      if (selectedFrigoTimingIndex.value == -1) {
        DFSnackBar.error("귀가 시간을 선택해주세요.");
        return;
      }

      DFSnackBar.info("금요귀가 신청 중입니다...");
      await frigoService.addFrigoApplication(
        frigoTiming[selectedFrigoTimingIndex.value],
        reason,
      );
      await fetchFrigoApplication();
      DFSnackBar.success("금요귀가 신청이 완료되었습니다.");
    } on FrigoPeriodNotExistsForGradeException {
      DFSnackBar.error("해당 학년은 금요귀가 신청이 불가능합니다. 담임 선생님께 문의주세요.");
      return;
    } on FrigoPeriodNotInApplyPeriodException {
      DFSnackBar.error("금요귀가 신청 기간이 아닙니다.");
      return;
    } on FrigoAlreadyAppliedException {
      DFSnackBar.error("이미 금요귀가 신청을 하였습니다.");
      return;
    } catch (e) {
      DFSnackBar.error("금요귀가 신청 중 오류가 발생했습니다. 다시 시도해주세요.");
      return;
    }
  }

  Future<void> deleteFrigoApplication() async {
    try {
      DFSnackBar.info("금요귀가 신청 취소 중입니다...");
      await frigoService.deleteFrigoApplication();
      await fetchFrigoApplication();
      DFSnackBar.success("금요귀가 신청이 취소되었습니다.");
    } on FrigoPeriodNotInApplyPeriodException {
      DFSnackBar.error("금요귀가 신청 취소 기간이 아닙니다.");
      return;
    } catch (e) {
      DFSnackBar.error("금요귀가 신청 취소 중 오류가 발생했습니다. 다시 시도해주세요.");
      return;
    }
  }

  @override
  void onClose() {
    frigoReasonTEC.dispose();
    super.onClose();
  }
}
