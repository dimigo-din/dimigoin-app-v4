import 'package:dio/dio.dart';

import '../../provider/api_interface.dart';
import '../../provider/model/response.dart';
import 'model.dart';

class FacilityRepository {
  final ApiProvider api;

  FacilityRepository({required this.api});

  Future<List<FacilityReport>> getReports() async {
    DFHttpResponse response = await api.get('/student/facility/list');

    return ((response.data['data'] ?? []) as List)
        .map((report) => FacilityReport.fromJson(report))
        .toList();
  }

  Future<FacilityReport> createRepairReport({
    required String subject,
    required String body,
    required String reportType,
    required List<MultipartFile> files,
  }) async {
    final payload = {
      'report_type': reportType,
      'subject': subject,
      'body': body,
    };

    final DFHttpResponse response;
    if (files.isEmpty) {
      response = await api.post('/student/facility/', data: payload);
    } else {
      final formData = FormData.fromMap(payload);
      formData.files.addAll(files.map((file) => MapEntry('file', file)));

      response = await api.post(
        '/student/facility/',
        data: formData,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );
    }

    return FacilityReport.fromJson(response.data['data']);
  }
}
