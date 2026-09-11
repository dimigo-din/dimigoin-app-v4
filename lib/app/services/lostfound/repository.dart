import 'package:dio/dio.dart';

import '../../provider/api_interface.dart';
import '../../provider/model/response.dart';
import 'model.dart';

class LostfoundRepository {
  final ApiProvider api;

  /// 서버가 한 페이지에 고정으로 내려주는 개수
  /// 이 값보다 적게 오면 마지막 페이지로 판단
  static const int pageSize = 10;

  LostfoundRepository({required this.api});

  Future<List<LostfoundReport>> getReports({
    int page = 1,
    LostfoundStatus? status,

    /// true 면 내 제보만, false 면 내 제보를 뺀 나머지, null 이면 전체
    bool? mine,
  }) async {
    DFHttpResponse response = await api.get(
      '/student/lostfound/list',
      queryParameters: {
        'page': '$page',
        if (status != null) 'status': status.value,
        if (mine != null) 'mine': '$mine',
      },
    );

    return ((response.data['data'] ?? []) as List)
        .map((report) => LostfoundReport.fromJson(report))
        .toList();
  }

  Future<LostfoundReport> getReport(String id) async {
    DFHttpResponse response = await api.get(
      '/student/lostfound',
      queryParameters: {'id': id},
    );

    return LostfoundReport.fromJson(response.data['data']);
  }

  Future<LostfoundReport> createReport({
    required String objectName,
    required String lastSeenPlace,
    required String body,
    required List<MultipartFile> files,
  }) async {
    // 첨부가 없어도 FormData로 보낸다.
    final formData = FormData.fromMap({
      'object_name': objectName,
      'last_seen_place': lastSeenPlace,
      'body': body,
    });
    formData.files.addAll(files.map((file) => MapEntry('file', file)));

    DFHttpResponse response = await api.post(
      '/student/lostfound',
      data: formData,
      options: Options(contentType: Headers.multipartFormDataContentType),
    );

    return LostfoundReport.fromJson(response.data['data']);
  }

  /// 작성자 본인만 호출할 수 있습니다. (다른 사람이면 403)
  Future<LostfoundReport> markFound(String id) async {
    DFHttpResponse response = await api.patch(
      '/student/lostfound/found',
      data: {'id': id},
    );

    return LostfoundReport.fromJson(response.data['data']);
  }

  Future<void> postComment({required String post, required String text}) async {
    await api.post(
      '/student/lostfound/comment',
      data: {'post': post, 'text': text},
    );
  }
}
