import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackbar.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';

class LoginPageController extends GetxController {
  AuthService authService = Get.find<AuthService>();

  Future<void> loginWithGoogle() async {
    try {
      await authService.loginWithGoogle();

      if (!authService.isLoginSuccess && !authService.isPersonalInfoRegistered) {
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.offAllNamed(Routes.MAIN);
      }
    } on PersonalInformationNotRegisteredException {
      DFSnackBar.open('개인정보가 등록되지 않은 계정입니다. 디미인증에서 먼저 등록해주세요.');
    } on GoogleOauthCodeInvalidException {
      DFSnackBar.open('구글 로그인 정보가 유효하지 않습니다. 다시 시도해주세요.');
    } catch (e) {
      print(e);
      DFSnackBar.open('알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

}
