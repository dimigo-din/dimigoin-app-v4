import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class ApiMiddleware {
  @protected
  FutureOr<Response> handle(RequestOptions options, Future<Response> Function(RequestOptions) next);
  
  @protected
  FutureOr<Response?> onError(DioException e, RequestOptions options) {
    return null;
  }

  late final ApiMiddleware _nextMiddleware;

  ApiMiddleware copy();

  ApiMiddleware setNextMiddleware(ApiMiddleware middleware) {
    _nextMiddleware = middleware;
    return this;
  }

  Future<Response> execute(RequestOptions options) async {
    try {
      return await handle(options, (opts) => _nextMiddleware.execute(opts));
    } on DioException catch (e) {
      Response? response = await onError(e, options);
      if (response != null) {
        return response;
      }
      rethrow;
    }
  }
}