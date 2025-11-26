import 'package:universal_html/html.dart' as html;
import 'package:get/get.dart';

import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackBar.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as developer;

import '../../routes/routes.dart';

class LoginPageController extends GetxController {
  AuthService authService = Get.find<AuthService>();

  RxBool isLoginProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();

    if(kIsWeb) {
      // 위젯이 빌드된 후 실행되도록 지연
      Future.delayed(Duration.zero, () {
        loginWithGoogleCallback();
      });
    }
  }

  void openLoginHelpPage() {
    final Uri url = Uri.parse('https://dimigo-din.notion.site/29e98f8027c68088ae85d049398c92bf');
    launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> loginWithGoogle() async {
    if(isLoginProcessing.value) {
      return;
    }

    try {
      isLoginProcessing.value = true;

      bool success = await authService.loginWithGoogle();

      if (success && authService.isLoginSuccess && authService.isPersonalInfoRegistered) {
        Get.offAllNamed(Routes.MAIN);
      }
    } on PersonalInformationNotRegisteredException {
      DFSnackBar.open('개인정보가 등록되지 않은 계정입니다. 디미인증에서 먼저 등록해주세요.');
      await Future.delayed(const Duration(seconds: 2));
      authService.openDimiAuthPage();
    } on GoogleOauthCodeInvalidException {
      DFSnackBar.open('구글 로그인 정보가 유효하지 않습니다. 다시 시도해주세요.');
    } catch (e) {
      developer.log('Error in loginWithGoogle: $e');
      DFSnackBar.open('알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    } finally {
      isLoginProcessing.value = false;
    }
  }

  Future<void> loginWithGoogleCallback() async {
    if(isLoginProcessing.value) {
      return;
    }

    try {
      final uri = Uri.parse(html.window.location.href);
      final code = uri.queryParameters['code'];

      if (code == null) {
        return;
      }

      isLoginProcessing.value = true;

      DFSnackBar.open('로그인 중입니다...');

      await authService.loginWithGoogleCallback(code);

      if (authService.isLoginSuccess && authService.isPersonalInfoRegistered) {
        Get.offAllNamed(Routes.MAIN);
      }
    } on PersonalInformationNotRegisteredException {
      DFSnackBar.open('개인정보가 등록되지 않은 계정입니다. 디미인증에서 먼저 등록해주세요.');
      await Future.delayed(const Duration(seconds: 2));
      authService.openDimiAuthPage();
    } on GoogleOauthCodeInvalidException {
      DFSnackBar.open('구글 로그인 정보가 유효하지 않습니다. 다시 시도해주세요.');
    } catch (e) {
      developer.log('Error in loginWithGoogleCallback: $e');
      DFSnackBar.open('알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    } finally {
      isLoginProcessing.value = false;
    }
  }
}
