import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../provider/api_interface.dart';
import '../../provider/model/response.dart';

import 'model.dart';

class FrigoRepository {
  final ApiProvider api;
  AuthService authService = Get.find<AuthService>();

  FrigoRepository({ApiProvider? api}) : api = api ?? Get.find<ApiProvider>();

  Future<Frigo> getFrigoApplication() async {
    String url = '/student/frigo';

    try {
      DFHttpResponse response = await api.get(url);

      return Frigo.fromJson(response.data['data']);
    } on DioException {
      rethrow;
    }
  }

  Future<void> addFrigoApplication(String timing, String reason) async {
    String url = '/student/frigo';

    try {
      await api.post(url, data: {
        'timing': timing,
        'reason': reason,
        'grade': authService.user?.userGrade,
      });
    } on DioException catch (e) {

      if(e.response?.data['code'] == 'FrigoPeriod_NotExistsForGrade') {
        throw FrigoPeriodNotExistsForGradeException();
      } else if (e.response?.data['code'] == 'FrigoPeriod_NotInApplyPeriod') {
        throw FrigoPeriodNotInApplyPeriodException();
      } else if (e.response?.data['code'] == 'Frigo_AlreadyApplied') {
        throw FrigoAlreadyAppliedException();
      }

      rethrow;
    }
  }

  Future<void> deleteFrigoApplication() async {
    String url = '/student/frigo';

    try {
      await api.delete(url);
    } on FrigoPeriodNotInApplyPeriodException {
      rethrow;
    } on DioException {
      rethrow;
    }
  }
}