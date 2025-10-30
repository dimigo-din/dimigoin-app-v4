import 'dart:async';
import 'package:dio/dio.dart';

import '../interceptors/middleware.dart';

class LogMiddleware extends ApiMiddleware {
  @override
  Future<Response> handle(RequestOptions options, Future<Response> Function(RequestOptions) next) async {
    final response = await next(options);
    
    print(
      '${options.method}[${response.statusCode}] => PATH: ${options.path}',
    );
    
    return response;
  }

  @override
  Future<Response?> onError(DioException e, RequestOptions options) async {
    if (e.response != null) {
      print(
        '${options.method}[${e.response!.statusCode}] => PATH: ${options.path}',
      );
    }
    return null;
  }

  @override
  LogMiddleware copy() {
    return LogMiddleware();
  }
}