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
    required String location,
    required String body,
    required List<MultipartFile> files,
  }) async {
    final formData = FormData.fromMap({
      'report_type': 'broken',
      'subject': subject,
      'body': '위치: $location\n\n$body',
      if (files.isNotEmpty) 'file': files,
    });

    DFHttpResponse response = await api.post(
      '/student/facility',
      data: formData,
      options: Options(contentType: Headers.multipartFormDataContentType),
    );

    return FacilityReport.fromJson(response.data['data']);
  }
}
