import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'model/response.dart';
import 'interceptors/middleware.dart';

class PerformRequestMiddleware extends ApiMiddleware {
  final Dio dio;
  final String method;

  PerformRequestMiddleware(this.dio, this.method);

  @override
  Future<Response> handle(RequestOptions options, Future<Response> Function(RequestOptions) next) {
    options.method = method;
    if (options.baseUrl.isEmpty) {
      options.baseUrl = dio.options.baseUrl;
    }
    return dio.fetch(options);
  }

  @override
  PerformRequestMiddleware copy() {
    return PerformRequestMiddleware(dio, method);
  }
}

abstract class ApiProvider {
  late Dio dio;
  final List<ApiMiddleware> middlewares = [];

  ApiProvider() {
    dio = Dio(BaseOptions(
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));
  }

  @nonVirtual
  @protected
  ApiMiddleware _buildMiddlewareChain(String method, List<ApiMiddleware> requestMiddlewares) {
    ApiMiddleware middleware = PerformRequestMiddleware(dio, method);

    List<ApiMiddleware> globalMiddlewares = middlewares.map((e) => e.copy()).toList();
    List<ApiMiddleware> allMiddlewares = globalMiddlewares + requestMiddlewares;

    for (var i = allMiddlewares.length - 1; i >= 0; i--) {
      middleware = allMiddlewares[i].setNextMiddleware(middleware);
    }

    return middleware;
  }

  @nonVirtual
  Future<DFHttpResponse> get(String path,
      {Map<String, dynamic>? queryParameters, 
       Options? options,
       List<ApiMiddleware> middlewares = const []}) async {
    
    ApiMiddleware middleware = _buildMiddlewareChain('GET', middlewares);
    
    final requestOptions = RequestOptions(
      path: path,
      queryParameters: queryParameters,
      headers: options?.headers,
    );

    Response dioResponse = await middleware.execute(requestOptions);
    return DFHttpResponse.fromDioResponse(dioResponse);
  }

  @nonVirtual
  Future<DFHttpResponse> post(String path,
      {dynamic data,
       Map<String, dynamic>? queryParameters,
       Options? options,
       List<ApiMiddleware> middlewares = const []}) async {
    
    ApiMiddleware middleware = _buildMiddlewareChain('POST', middlewares);
    
    final requestOptions = RequestOptions(
      path: path,
      data: data,
      queryParameters: queryParameters,
      headers: options?.headers,
    );

    Response dioResponse = await middleware.execute(requestOptions);
    return DFHttpResponse.fromDioResponse(dioResponse);
  }

  @nonVirtual
  Future<DFHttpResponse> delete(String path,
      {dynamic data, 
       Map<String, dynamic>? queryParameters,
       Options? options,
       List<ApiMiddleware> middlewares = const []}) async {
    
    ApiMiddleware middleware = _buildMiddlewareChain('DELETE', middlewares);
    
    final requestOptions = RequestOptions(
      path: path,
      data: data,
      queryParameters: queryParameters,
      headers: options?.headers,
    );

    Response dioResponse = await middleware.execute(requestOptions);
    return DFHttpResponse.fromDioResponse(dioResponse);
  }

  @nonVirtual
  Future<DFHttpResponse> patch(String path,
      {dynamic data, 
       Options? options,
       List<ApiMiddleware> middlewares = const []}) async {
    
    ApiMiddleware middleware = _buildMiddlewareChain('PATCH', middlewares);
    
    final requestOptions = RequestOptions(
      path: path,
      data: data,
      headers: options?.headers,
    );

    Response dioResponse = await middleware.execute(requestOptions);
    return DFHttpResponse.fromDioResponse(dioResponse);
  }

  @nonVirtual
  Future<DFHttpResponse> put(String path,
      {dynamic data, 
       Options? options,
       List<ApiMiddleware> middlewares = const []}) async {
    
    ApiMiddleware middleware = _buildMiddlewareChain('PUT', middlewares);
    
    final requestOptions = RequestOptions(
      path: path,
      data: data,
      headers: options?.headers,
    );

    Response dioResponse = await middleware.execute(requestOptions);
    return DFHttpResponse.fromDioResponse(dioResponse);
  }

  Future<Stream<Map<String, dynamic>>> getStream(String path) async {
    Response<ResponseBody> dioResponse = await dio.get(
      path,
      options: Options(
        headers: {"Accept": "text/event-stream"},
        responseType: ResponseType.stream,
      ),
    );
    return dioResponse.data!.stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (rawdata, sink) {
          String strData = String.fromCharCodes(rawdata);
          String formatedData =
              strData.substring(strData.indexOf('{'), strData.indexOf('}') + 1);
          Map<String, dynamic> data = json.decode(formatedData);
          sink.add(data);
        },
      ),
    );
  }
}