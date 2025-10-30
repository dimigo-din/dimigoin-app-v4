import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackBar.dart';
import 'package:get/get.dart';

class PinInputController extends GetxController {
  final pin = ''.obs;
  final int pinLength = 4;

  final isCheckingPin = false.obs;

  final AuthService authService = Get.find<AuthService>();

  void onNumberPressed(String number) {
    if (isCheckingPin.value) return;

    if (pin.value.length < pinLength) {
      pin.value += number;

      if (pin.value.length == pinLength) {
        onPinComplete();
      }
    }
  }

  void onDeletePressed() {
    if (isCheckingPin.value) return;

    if (pin.value.isNotEmpty) {
      pin.value = pin.value.substring(0, pin.value.length - 1);
    }
  }

  Future<void> onPinComplete() async {
    isCheckingPin.value = true;

    try {
      await authService.getPersonalInformation(pin.value);

      if (!authService.isPersonalInfoRegistered) {
        DFSnackBar.open('PIN 번호가 올바르지 않습니다. 다시 시도해주세요.');
        clearPin();
      } else {
        Get.back(result: true);
      }
    } on WrongPasscodeException {
      DFSnackBar.open('PIN 번호가 올바르지 않습니다. 다시 시도해주세요.');
      clearPin();
    } catch (e) {
      DFSnackBar.open('서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
      Get.back(result: false);
    } finally {
      isCheckingPin.value = false;
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
