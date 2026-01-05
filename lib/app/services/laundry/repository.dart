import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../provider/api_interface.dart';
import '../../provider/model/response.dart';

import 'model.dart';

class LaundryRepository {
  final ApiProvider api;
  AuthService authService = Get.find<AuthService>();

  LaundryRepository({ApiProvider? api}) : api = api ?? Get.find<ApiProvider>();

  Future<LaundryTimeline> getLaundryTimeline() async {
    String url = '/student/laundry/timeline';

    try {
      DFHttpResponse response = await api.get(url);
      print(response.data);
      return LaundryTimeline.fromJson(response.data['data']);
    } on DioException {
      rethrow;
    }
  }

  Future<List<LaundryApply>> getLaundryApplications() async {
    String url = '/student/laundry';

    try {
      DFHttpResponse response = await api.get(url);

      return (response.data['data'] as List)
          .map((e) => LaundryApply.fromJson(e))
          .toList();
    } on DioException {
      rethrow;
    }
  }

  Future<LaundryApply> applyLaundry(String timeId, String machineId) async {
    String url = '/student/laundry';

    try {
      DFHttpResponse response = await api.post(
        url,
        data: {
          'grade': authService.user?.userGrade,
          'time': timeId,
          'machine': machineId,
        },
      );

      return LaundryApply.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.response?.data['code'] == 'LaundryApplyIsAfterEightAM') {
        throw LaundryApplyIsAfterEightAMException();
      } else if (e.response?.data['code'] == 'LaundryApply_AlreadyExists') {
        throw LaundryApplyAlreadyExistsException();
      } else if (e.response?.data['code'] ==
          'PermissionDenied_Resource_Grade') {
        throw PermissionDeniedResourceGradeException();
      } else if (e.response?.data['code'] == 'LaundryMachine_AlreadyTaken') {
        throw LaundryMachineAlreadyTakenException();
      }
      rethrow;
    }
  }

  Future<void> deleteLaundryApplication(String applyId) async {
    String url = '/student/laundry';

    try {
      await api.delete(url, queryParameters: {'id': applyId});
    } on DioException {
      rethrow;
    }
  }
}
