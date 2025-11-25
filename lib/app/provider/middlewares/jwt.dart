import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' hide Response;
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/routes/routes.dart';
import '../interceptors/middleware.dart';

class JWTMiddleware extends ApiMiddleware {
  AuthService get _authService => Get.find<AuthService>();
  
  static Future<void>? _refreshFuture;

  @override
  Future<Response> handle(RequestOptions options, Future<Response> Function(RequestOptions) next) async {
    // AuthService 초기화 완료를 기다림
    await _authService.initComplete;

    final token = _authService.jwtToken.accessToken;
    if (token != null && options.headers['Authorization'] == null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return next(options);
  }

  @override
  Future<Response?> onError(DioException err, RequestOptions options) async {
    final responseCode = err.response?.statusCode;
    final errorCode = err.response?.data?['code'];

    if (options.path == '/auth/refresh' || options.path == dotenv.env['PERSONAL_INFO_API_URL']) {
      return null;
    }

    if (responseCode == 401 || errorCode == 'ERR_TOKEN_EXPIRED') {
      try {
        await _performRefreshWithLock();

        final newToken = _authService.jwtToken.accessToken;
        if (newToken != null) {
          options.headers['Authorization'] = 'Bearer $newToken';
        }
        
        final dio = Dio(BaseOptions(baseUrl: dotenv.env['API_BASE_URL']!));
        final retryResponse = await dio.request(
          options.path,
          data: options.data,
          queryParameters: options.queryParameters,
          options: Options(
            method: options.method,
            headers: options.headers,
          ),
        );
        
        return retryResponse;
      } catch (_) {
        await _authService.logout();
        Get.offAllNamed(Routes.LOGIN);
        return null;
      }
    }

    return null;
  }

  Future<void> _performRefreshWithLock() async {
    if (_refreshFuture != null) {
      await _refreshFuture;
      return;
    }

    final completer = Completer<void>();
    _refreshFuture = completer.future;

    try {
      await _authService.refreshToken();
      completer.complete();
    } catch (e) {
      completer.completeError(e);
      rethrow;
    } finally {
      _refreshFuture = null;
    }
  }

  @override
  JWTMiddleware copy() {
    return JWTMiddleware();
  }
}