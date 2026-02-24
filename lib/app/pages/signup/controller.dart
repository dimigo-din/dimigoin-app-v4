import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackBar.dart';
import 'package:get/get.dart';

class SignupPageController extends GetxController {
  final authService = AuthService();

  final RxInt selectedGrade = (-1).obs;
  final RxInt selectedClass = (-1).obs;
  final RxInt selectedGender = (-1).obs;

  final RxBool canSubmit = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  void checkCanSubmit() {
    if (selectedGrade.value == -1 || selectedClass.value == -1 || selectedGender.value == -1) {
      canSubmit.value = false;
    } else {
      canSubmit.value = true;
    }
  }

  Future<void> submitPersonalInfo() async {
    try { 
      if (!canSubmit.value) return;

      await authService.signUpPersonalInformation(
        selectedGrade.value + 1,
        selectedClass.value + 1,
        selectedGender.value == 0 ? "male" : "female",
      );
    } on PersonalInformationAlreadyRegisteredException {
      DFSnackBar.error("개인정보가 이미 등록되어 있습니다.\n다시 로그인해주세요.");
      authService.logout();
      Get.offAllNamed('/login');
    } catch (e) {
      DFSnackBar.error("개인정보 등록 중 오류가 발생했습니다.");
    }
  }
}