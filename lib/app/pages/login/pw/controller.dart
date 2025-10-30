import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:get/get.dart';

import 'package:dimigoin_app_v4/app/services/auth/service.dart';

class PWLoginPageController extends GetxController {
  AuthService authService = Get.find<AuthService>();

  final RxString email = ''.obs;
  final RxString password = ''.obs;

  Future<void> loginWithPassword() async {
    try {
      await authService.loginWithPassword(email.value, password.value);
    } on PersonalInformationNotRegisteredException {
      Get.snackbar('로그인 실패', '개인정보가 등록되지 않은 계정입니다. 디미인증에서 먼저 등록해주세요.',
          snackPosition: SnackPosition.BOTTOM);
    } on GoogleOauthCodeInvalidException {
      Get.snackbar('로그인 실패', '구글 로그인 정보가 유효하지 않습니다. 다시 시도해주세요.',
          snackPosition: SnackPosition.BOTTOM);
    } on PasswordInvalidException {
      Get.snackbar('로그인 실패', '비밀번호가 올바르지 않습니다. 다시 시도해주세요.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('로그인 실패', '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

}
