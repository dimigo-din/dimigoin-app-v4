import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/routes/routes.dart';
import 'package:dimigoin_app_v4/app/services/push/service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../auth/model.dart';
import 'repository.dart';
import 'storage.dart';

class AuthService extends GetxController {
  final AuthRepository repository;

  final Rx<Pong?> _pong = Rx(null);
  Pong? get pong => _pong.value;

  final Rx<LoginToken> _jwtToken = Rx(LoginToken());
  LoginToken get jwtToken => _jwtToken.value;

  final Rx<PersonalInformation?> _user = Rx(null);
  PersonalInformation? get user => _user.value;

  bool get isLoginSuccess => jwtToken.accessToken != null;
  bool get isPersonalInfoRegistered => user != null;

  final Completer<void> _initCompleter = Completer<void>();
  Future<void> get initComplete => _initCompleter.future;

  AuthService({AuthRepository? repository}) : repository = repository ?? AuthRepository();

  @override
  Future<void> onInit() async {
    super.onInit();

    try {
      final accessToken = await AuthStorage.getAccessToken();
      final refreshToken = await AuthStorage.getRefreshToken();

      _jwtToken.value = LoginToken(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      _user.value = await AuthStorage.getPersonalInformation();

      await initialize();
    } catch (e) {
      rethrow;
    } finally {
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }
    }
  }

  Future<void> initialize() async {
    if (!kIsWeb) {
      final GoogleSignIn signIn = GoogleSignIn.instance;
      await signIn.initialize(
        clientId: dotenv.env['GOOGLE_CLIENT_ID'],
        serverClientId: dotenv.env['GOOGLE_SERVER_CLIENT_ID'],
      );
    }
  }

  Future<Pong?> ping() async {
    try {
      Pong data = await repository.getPong();
      _pong.value = data;
      return _pong.value;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  void openDimiAuthPage() {
    final Uri url = Uri.parse('https://dimiauth.findflag.kr');
    launchUrl(url, mode: LaunchMode.externalApplication);
  }
  
  Future<String?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await GoogleSignIn.instance.authenticate();
      
      if (account == null) {
        return null;
      }
      
      final GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;
      
      if (idToken == null) {
        throw Exception('idToken을 가져올 수 없습니다');
      }

      return idToken;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
    return null;
  }

  Future<void> _clearGoogleSignInInfo() async {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    try {
      if (Platform.isAndroid) {
        await googleSignIn.signOut();
      } else {
        await googleSignIn.disconnect();
      }
    } on Exception {
      await googleSignIn.disconnect();
    }
  }

  Future<bool> loginWithGoogle() async {
    if (kIsWeb) {
      return await loginWithGoogleWeb();
    } else {
      return await loginWithGoogleApp();
    }
  }

  Future<bool> loginWithGoogleWeb() async {
    try {
      final redirectUri = await repository.getGoogleOAuthUrl();
      final Uri oauthUri = Uri.parse(redirectUri);

      return await launchUrl(oauthUri, mode: LaunchMode.inAppBrowserView);
    } on Exception catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<bool> loginWithGoogleApp() async {
    try {
      final idToken = await _signInWithGoogle();
      if (idToken == null) return false;

      final token = await repository.loginWithGoogleApp(idToken);

      await _handleLoginSuccess(token);
    } on PinVerificationCancelledException {
      return false;
    } on PersonalInformationNotRegisteredException {
      logout();
      throw PersonalInformationNotRegisteredException();
    } on GoogleOauthCodeInvalidException {
      logout();
      throw GoogleOauthCodeInvalidException();
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return false;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }

    _clearGoogleSignInInfo();
    return true;
  }

  Future<void> loginWithGoogleCallback(String code) async {
    try {
      final token = await repository.loginWithGoogleWeb(code);

      await _handleLoginSuccess(token);
    } on PersonalInformationNotRegisteredException {
      throw PersonalInformationNotRegisteredException();
    } on GoogleOauthCodeInvalidException {
      throw GoogleOauthCodeInvalidException();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> _handleLoginSuccess(LoginToken token) async {
    _jwtToken.value = token;

    dynamic result = await Get.toNamed(Routes.PIN);

    if (result == true) {
      await AuthStorage.saveTokens(token.accessToken!, token.refreshToken!);

      final decode = JwtDecoder.decode(token.accessToken!) as dynamic;

      await AuthStorage.saveUserImageURL(decode['picture'].toString());
      await AuthStorage.saveUserId(decode['id'].toString());

      _user.value?.profileUrl = decode['picture'].toString();
      _user.value?.id = decode['id'].toString();

      try {
        final pushService = Get.find<PushService>();
        await pushService.syncTokenToServer();
      } catch (e) {
        log('Failed to sync FCM token after login: $e');
      }
    } else {
      _jwtToken.value = LoginToken();
      throw PinVerificationCancelledException();
    }
  }

  Future<bool> loginWithPassword(String email, String password) async {
    try {
      final token = await repository.loginWithPassword(email, password);

      await _handleLoginSuccess(token);
    } on PinVerificationCancelledException {
      return false;
    } on PersonalInformationNotRegisteredException {
      logout();
      throw PersonalInformationNotRegisteredException();
    } on GoogleOauthCodeInvalidException {
      logout();
      throw GoogleOauthCodeInvalidException();
    } on PasswordInvalidException {
      throw PasswordInvalidException();
    } catch (e) {
      rethrow;
    }

    return true;
  }

  Future<void> logout() async {
    await AuthStorage.clear();
    _jwtToken.value = LoginToken();
    _user.value = null;

    if (!kIsWeb) {
      await _clearGoogleSignInInfo();
    }
  }

  Future<void> refreshToken() async {
    try {
      if (jwtToken.refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final token = await repository.refreshToken(jwtToken.refreshToken!);
      _jwtToken.value = token;
      await AuthStorage.saveTokens(token.accessToken!, token.refreshToken!);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> getPersonalInformation(String passcode) async {
    try {
      final info = await repository.getPersonalInformation(passcode);

      AuthStorage.savePersonalInformation(info);

      _user.value = info;
    } on WrongPasscodeException {
      throw WrongPasscodeException();
    } on PersonalInformationNotRegisteredException {
      throw PersonalInformationNotRegisteredException();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
