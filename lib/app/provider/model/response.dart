import 'package:dio/dio.dart';

class DFHttpResponse {
  dynamic data;

  DFHttpResponse({
    this.data,
  });

  factory DFHttpResponse.fromDioResponse(Response dioResponse) =>
      DFHttpResponse(
        data: dioResponse.data,
      );
}