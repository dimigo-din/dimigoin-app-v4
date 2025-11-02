import 'dart:io';

import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackBar.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

enum PinStatus {
  normal,
  wrong,
  checking,
}

class PinInputController extends GetxController {
  final AuthService authService = Get.find<AuthService>();

  final pin = ''.obs;
  final int pinLength = 4;

  final pinStatus = PinStatus.normal.obs;

  void onNumberPressed(String number) {
    if (pinStatus.value == PinStatus.checking) return;

    HapticFeedback.lightImpact();

    if (pin.value.length < pinLength) {
      pin.value += number;

      if (pin.value.length == pinLength) {
        onPinComplete();
      }
    }
  }

  void onDeletePressed() {
    if (pinStatus.value == PinStatus.checking) return;

    HapticFeedback.lightImpact();

    if (pin.value.isNotEmpty) {
      pin.value = pin.value.substring(0, pin.value.length - 1);
    }
  }

  Future<void> onPinComplete() async {
    pinStatus.value = PinStatus.checking;

    try {
      await authService.getPersonalInformation(pin.value);

      if (!authService.isPersonalInfoRegistered) {
        pinStatus.value = PinStatus.wrong;
        clearPin();
      } else {
        Get.back(result: true);
      }
    } on WrongPasscodeException {
      pinStatus.value = PinStatus.wrong;
      clearPin();
    } on PersonalInformationNotRegisteredException {
      pinStatus.value = PinStatus.normal;
      clearPin();
      DFSnackBar.open('개인정보가 등록되지 않은 계정입니다. 디미인증에서 먼저 등록해주세요.');
      sleep(const Duration(seconds: 2));
      authService.openDimiAuthPage();
    } catch (e) {
      pinStatus.value = PinStatus.normal;
      clearPin();
      DFSnackBar.open('알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  void clearPin() {
    pin.value = '';
  }

  @override
  void onClose() {
    clearPin();
    super.onClose();
  }
}
