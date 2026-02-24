import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../provider/api_interface.dart';
import '../../provider/model/response.dart';

import 'model.dart';

class AuthRepository {
  final ApiProvider api;

  AuthRepository({ApiProvider? api}) : api = api ?? Get.find<ApiProvider>();

  Future<Pong> getPong() async {
    String url = '/auth/ping';

    DFHttpResponse response = await api.get(url);

    Pong pong = Pong.fromJson(response.data['data']);

    return pong;
  }

  Future<LoginToken> loginWithPassword(String email, String password) async {
    String url = '/auth/login/password';

    try {
      DFHttpResponse response = await api.post(url, data: {
        'email': email,
        'password': password,
      });

      LoginToken loginToken = LoginToken.fromJson(response.data['data']);

      return loginToken;
    } on DioException catch (e) {
      if (e.response?.data['code'] == 'PersonalInformation_NotRegistered') {
        throw PersonalInformationNotRegisteredException();
      } else if (e.response?.data['code'] == 'UserIdentifier_NotMatched') {
        throw PasswordInvalidException();
      } else {
        rethrow;
      }
    }
  }

  Future<String> getGoogleOAuthUrl() async {
    String url = '/auth/login/google';

    try {
      final redirectUri = '${Uri.base.scheme}://${Uri.base.host}${Uri.base.hasPort ? ':${Uri.base.port}' : ''}/login';
      DFHttpResponse response = await api.get(url, queryParameters: {
        'redirect_uri': redirectUri,
      });

      String oauthUrl = response.data['data'];

      return oauthUrl;
    } on DioException {
      rethrow;
    }
  }

  Future<LoginToken> loginWithGoogleWeb(String code) async {
    String url = '/auth/login/google/callback';

    try {
      final redirectUri = '${Uri.base.scheme}://${Uri.base.host}${Uri.base.hasPort ? ':${Uri.base.port}' : ''}/login';
      DFHttpResponse response = await api.post(url, data: {
        'code': code,
        'redirect_uri': redirectUri,
      });

      LoginToken loginToken = LoginToken.fromJson(response.data['data']);

      return loginToken;
    } on DioException catch (e) {
      if (e.response?.data['code'] == 'PersonalInformation_NotRegistered') {
        throw PersonalInformationNotRegisteredException();
      } else if (e.response?.data['code'] == 'GoogleOauthCode_Invalid') {
        throw GoogleOauthCodeInvalidException();
      } else {
        rethrow;
      }
    }
  }

  Future<LoginToken> loginWithGoogleApp(String idToken) async {
    String url = '/auth/login/google/callback/app';

    try {
      DFHttpResponse response = await api.post(url, data: {
        'idToken': idToken,
      });

      LoginToken loginToken = LoginToken.fromJson(response.data['data']);

      return loginToken;
    } on DioException catch (e) {
      if (e.response?.data['code'] == 'PersonalInformation_NotRegistered') {
        throw PersonalInformationNotRegisteredException();
      } else if (e.response?.data['code'] == 'GoogleOauthCode_Invalid') {
        throw GoogleOauthCodeInvalidException();
      } else {
        rethrow;
      }
    }
  }

  Future<LoginToken> refreshToken(String refreshToken) async {
    String url = '/auth/refresh';

    try {
      DFHttpResponse response = await api.post(url, data: {
        'refreshToken': refreshToken,
      });

      LoginToken loginToken = LoginToken.fromJson(response.data['data']);

      return loginToken;
    } on DioException {
      rethrow;
    }
  }

  Future<LoginToken> signUpPersonalInformation(int grade, int classNum, String gender) async {
    String url = '/auth/signup';

    try {
      DFHttpResponse response = await api.post(url, data: {
        'grade': grade,
        'class': classNum,
        'gender': gender,
      });

      LoginToken loginToken = LoginToken.fromJson(response.data['data']);

      return loginToken;
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw PersonalInformationAlreadyRegisteredException();
      } else {
        rethrow;
      }
    }
  }
}