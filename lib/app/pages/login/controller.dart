import 'dart:io';

import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackBar.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../routes/routes.dart';

class LoginPageController extends GetxController {
  AuthService authService = Get.find<AuthService>();

  void openLoginHelpPage() {
    final Uri url = Uri.parse('https://dimigo-din.notion.site/29e98f8027c68088ae85d049398c92bf');
    launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> loginWithGoogle() async {
    try {
      bool success = await authService.loginWithGoogle();

      if (success && authService.isLoginSuccess && authService.isPersonalInfoRegistered) {
        Get.offAllNamed(Routes.MAIN);
      }
    } on PersonalInformationNotRegisteredException {
      DFSnackBar.open('개인정보가 등록되지 않은 계정입니다. 디미인증에서 먼저 등록해주세요.');
      sleep(const Duration(seconds: 2));
      authService.openDimiAuthPage();
    } on GoogleOauthCodeInvalidException {
      DFSnackBar.open('구글 로그인 정보가 유효하지 않습니다. 다시 시도해주세요.');
    } catch (e) {
      print(e);
      DFSnackBar.open('알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

}
