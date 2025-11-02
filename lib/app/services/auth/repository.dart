import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../provider/api_interface.dart';
import '../../provider/model/response.dart';

import 'model.dart';

class AuthRepository {
  final ApiProvider api;

  AuthRepository({ApiProvider? api}) : api = api ?? Get.find<ApiProvider>();

  Future<Pong> getPong() async {
    String url = '/auth/ping';

    DFHttpResponse response = await api.get(url);

    Pong pong = Pong.fromJson(response.data);

    return pong;
  }

  Future<LoginToken> loginWithPassword(String email, String password) async {
    String url = '/auth/login/password';

    try {
      DFHttpResponse response = await api.post(url, data: {
        'email': email,
        'password': password,
      });

      LoginToken loginToken = LoginToken.fromJson(response.data);

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

  Future<LoginToken> loginWithGoogle(String idToken) async {
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

  Future<String> getPersonalInformationVerifyToken() async {
    String url = '/auth/personalInformationVerifyToken';

    try {
      DFHttpResponse response = await api.get(url);

      return response.data['data'];
    } on DioException {
      rethrow;
    }
  }

  Future<PersonalInformation> getPersonalInformation(String passcode) async {
    String url = dotenv.env['PERSONAL_INFO_API_URL'] ?? '';
    if (url.isEmpty) {
      throw Exception('PERSONAL_INFO_API_URL is not defined in .env file');
    }

    try {
      final token = await getPersonalInformationVerifyToken();
      DFHttpResponse response = await api.get(url, options: Options(
        headers: {
          'Authorization': 'Bearer ${base64Encode(utf8.encode('${token}\$${passcode}'))}',
        },
      ));

      return PersonalInformation.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw WrongPasscodeException();
      } else if (e.response?.statusCode == 404) {
        throw PersonalInformationNotRegisteredException();
      } else {
        rethrow;
      }
    }
  }
}