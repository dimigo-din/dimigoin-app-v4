import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;

import '../../provider/api_interface.dart';
import '../../provider/model/response.dart';
import 'model.dart';

class FacilityRepository {
  final ApiProvider api;

  FacilityRepository({ApiProvider? api}) : api = api ?? Get.find<ApiProvider>();

  Future<List<ReportFacility>> getReportList() async {
    String url = '/student/facility/list';

    try {
      DFHttpResponse response = await api.get(url);

      return (response.data['data'] as List)
          .map((report) => ReportFacility.fromJson(report))
          .toList();
    } on DioException {
      rethrow;
    }
  }

  Future<ReportFacility> getReport(String reportId) async {
    String url = '/student/facility';

    try {
      DFHttpResponse response = await api.get(
        url,
        queryParameters: {'id': reportId},
      );

      return ReportFacility.fromJson(response.data['data']);
    } on DioException {
      rethrow;
    }
  }

  Future<void> createRepairReport({
    required String subject,
    required String body,
    required String reportType,
    required List<MultipartFile> files,
  }) async {
    String url = '/student/facility';

    final payload = {
      'report_type': reportType,
      'subject': subject,
      'body': body,
    };

    try {
      if (files.isEmpty) {
        await api.post(url, data: payload);
      } else {
        final formData = FormData.fromMap(payload);
        formData.files.addAll(files.map((file) => MapEntry('file', file)));

        await api.post(
          url,
          data: formData,
          options: Options(contentType: Headers.multipartFormDataContentType),
        );
      }
    } on DioException {
      rethrow;
    }
  }

  Future<void> createComment({
    required String postId,
    String? parentCommentId,
    required String text,
  }) async {
    String url = '/student/facility/comment';

    final payload = {
      'post': postId,
      'parent_comment': parentCommentId,
      'text': text,
    };

    try {
      await api.post(url, data: payload);
    } on DioException {
      rethrow;
    }
  }
}
