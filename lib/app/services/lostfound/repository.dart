import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

import '../../provider/api_interface.dart';
import '../../provider/model/response.dart';
import 'model.dart';

class LostfoundRepository {
  final ApiProvider api;

  static const int pageSize = 10;

  LostfoundRepository({ApiProvider? api})
    : api = api ?? Get.find<ApiProvider>();

  Future<List<LostfoundReport>> getReports({
    int page = 1,
    LostfoundStatus? status,
    bool? mine,
  }) async {
    String url = '/student/lostfound/list';

    DFHttpResponse response = await api.get(
      url,
      queryParameters: {
        'page': '$page',
        if (status != null) 'status': status.name,
        if (mine != null) 'mine': '$mine',
      },
    );

    return (response.data['data'] as List)
        .map((report) => LostfoundReport.fromJson(report))
        .toList();
  }

  Future<LostfoundReport> getReport(String id) async {
    String url = '/student/lostfound';

    try {
      DFHttpResponse response = await api.get(url, queryParameters: {'id': id});
      return LostfoundReport.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ResourceNotFoundException();
      } else if (e.response?.statusCode == 403) {
        throw PermissionDeniedResourceException();
      }
      rethrow;
    }
  }

  Future<LostfoundReport> createReport({
    required LostfoundStatus status,
    required String objectName,
    required String lastSeenPlace,
    required String body,
    required List<MultipartFile> files,
  }) async {
    String url = '/student/lostfound';
    // 이 API는 첨부 유무와 관계없이 multipart 요청을 받습니다.
    final formData = FormData.fromMap({
      'status': status.name,
      'object_name': objectName,
      'last_seen_place': lastSeenPlace,
      'body': body,
    });
    formData.files.addAll(files.map((file) => MapEntry('file', file)));

    try {
      DFHttpResponse response = await api.post(
        url,
        data: formData,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );
      return LostfoundReport.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        throw TooManyRequestsException();
      }
      rethrow;
    }
  }

  Future<LostfoundReport> markFound(String id) async {
    String url = '/student/lostfound/found';

    try {
      DFHttpResponse response = await api.patch(url, data: {'id': id});
      return LostfoundReport.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw PermissionDeniedResourceException();
      } else if (e.response?.statusCode == 404) {
        throw ResourceNotFoundException();
      }
      rethrow;
    }
  }

  Future<void> postComment({required String post, required String text}) async {
    String url = '/student/lostfound/comment';

    try {
      await api.post(url, data: {'post': post, 'text': text});
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw PermissionDeniedResourceException();
      } else if (e.response?.statusCode == 404) {
        throw ResourceNotFoundException();
      } else if (e.response?.statusCode == 429) {
        throw TooManyRequestsException();
      }
      rethrow;
    }
  }
}
