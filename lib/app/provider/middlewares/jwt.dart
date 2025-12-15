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
      print('[JWTMiddleware] 401 error detected for ${options.path}');
      print('[JWTMiddleware] Error code: $errorCode, Status: $responseCode');

      try {
        print('[JWTMiddleware] Attempting token refresh...');
        await _performRefreshWithLock();

        final newToken = _authService.jwtToken.accessToken;
        if (newToken != null) {
          print('[JWTMiddleware] Token refreshed successfully, retrying request');
          options.headers['Authorization'] = 'Bearer $newToken';
        } else {
          print('[JWTMiddleware] ERROR: New token is null after refresh');
        }

        final dio = Dio(BaseOptions(baseUrl: dotenv.env['API_BASE_URL']!));
        try {
          final retryResponse = await dio.request(
            options.path,
            data: options.data,
            queryParameters: options.queryParameters,
            options: Options(
              method: options.method,
              headers: options.headers,
            ),
          );

          print('[JWTMiddleware] Retry request successful');
          return retryResponse;
        } on DioException catch (retryErr) {
          if (retryErr.response?.statusCode != 401) {
            // 401이 아닌 에러(404, 500 등)는 토큰 문제가 아니므로 그냥 전달
            print('[JWTMiddleware] Retry failed with ${retryErr.response?.statusCode}, passing through (non-auth error)');
            return null;
          }
          // 재시도해도 401이면 토큰 리프레시 실패로 간주
          print('[JWTMiddleware] Retry still returned 401, token refresh failed');
          throw retryErr;
        }
      } catch (e) {
        // 토큰 리프레시 자체가 실패한 경우에만 로그아웃
        print('[JWTMiddleware] ERROR: Token refresh failed: $e');
        print('[JWTMiddleware] Logging out and redirecting to login');
        await _authService.logout();
        Get.offAllNamed(Routes.LOGIN);
        return null;
      }
    }

    return null;
  }

  Future<void> _performRefreshWithLock() async {
    if (_refreshFuture != null) {
      print('[JWTMiddleware] Refresh already in progress, waiting...');
      await _refreshFuture;
      print('[JWTMiddleware] Refresh completed by another request');
      return;
    }

    print('[JWTMiddleware] Starting new refresh operation');
    final completer = Completer<void>();
    _refreshFuture = completer.future;

    try {
      await _authService.refreshToken();
      completer.complete();
      print('[JWTMiddleware] Refresh operation completed successfully');
    } catch (e) {
      print('[JWTMiddleware] Refresh operation failed: $e');
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