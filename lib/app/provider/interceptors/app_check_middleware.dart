import 'package:dio/dio.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'middleware.dart';

class AppCheckMiddleware extends ApiMiddleware {
  @override
  Future<Response> handle(
    RequestOptions options,
    Future<Response> Function(RequestOptions) next,
  ) async {
    try {
      final token = await FirebaseAppCheck.instance.getToken();
      if (token != null) {
        options.headers['X-Firebase-AppCheck'] = token;
      }
    } catch (e) {
      print('App Check token error: $e');
    }

    return next(options);
  }

  @override
  AppCheckMiddleware copy() => AppCheckMiddleware();
}