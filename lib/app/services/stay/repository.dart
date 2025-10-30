import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../provider/api_interface.dart';
import '../../provider/model/response.dart';

import 'model.dart';

class StayRepository {
  final ApiProvider api;
  AuthService authService = Get.find<AuthService>();

  StayRepository({ApiProvider? api}) : api = api ?? Get.find<ApiProvider>();

  Future<List<Stay>> getStay() async {
    String url = '/student/stay';

    try {
      DFHttpResponse response = await api.get(url, queryParameters: {
        'grade': authService.user?.userGrade,
      });

      return (response.data['data'] as List)
          .map((e) => Stay.fromJson(e))
          .toList();
    } on DioException {
      rethrow;
    }
  }

  Future<List<StayApply>> getStayApplication() async {
    String url = '/student/stay/apply';

    try {
      DFHttpResponse response = await api.get(url);

      return (response.data['data'] as List)
          .map((e) => StayApply.fromJson(e))
          .toList();
    } on DioException {
      rethrow;
    }
  }
  
  Future<StayApply> addStayApplication(String stayId, String seatId, List<Outing> outings, {String? noSeatReason}) async {
    String url = '/student/stay/apply';

    try {
      DFHttpResponse response = await api.post(url, data: {
        'stay': stayId,
        'stay_seat': seatId == '' || seatId.isEmpty ? noSeatReason : seatId,
        'grade': authService.user?.userGrade,
        'gender': authService.user?.gender,
        'outing': outings.map((outing) => outing.toJson()).toList(),
      });

      return StayApply.fromJson(response.data['data']);
    } on DioException catch (e) {
      if(e.response?.data['code'] == 'Stay_NotInApplyPeriod') {
        throw StayNotInApplyPeriodException();
      } else if(e.response?.data['code'] == 'Stay_AlreadyApplied') {
        throw StayAlreadyAppliedException();
      } else if(e.response?.data['code'] == 'StaySeat_Duplication') {
        throw StaySeatDuplicationException();
      } else if(e.response?.data['code'] == 'StaySeat_NotAllowed') {
        throw StaySeatNotAllowedException();
      }

      rethrow;
    }
  }

  Future<void> deleteStayApplication(String id) async {
    String url = '/student/stay/apply';

    try {
      await api.delete(url, queryParameters: {
        'id': id,
        'grade': authService.user?.userGrade,
      });

    } on DioException catch (e) {
      if (e.response?.data['code'] == 'Resource_NotFound') {
        throw ResourceNotFoundException();
      } else if (e.response?.data['code'] == 'PermissionDenied_Resource') {
        throw PermissionDeniedResourceException();
      } else if (e.response?.data['code'] == 'Stay_NotInApplyPeriod') {
        throw StayNotInApplyPeriodException();
      }

      rethrow;
    } 
  }

  Future<List<Outing>> getStayOuting(String id) async {
    String url = '/student/stay/outing';

    try {
      DFHttpResponse response = await api.get(url, queryParameters: {
        'id': id,
        'grade': authService.user?.userGrade,
      });

      return (response.data['data'] as List)
          .map((e) => Outing.fromJson(e))
          .toList();
    } on DioException {
      rethrow;
    }
  }

  Future<Outing> addStayOuting(String stayId, Outing outing) async {
    String url = '/student/stay/outing';

    try {
      DFHttpResponse response = await api.post(url, data: {
        'apply_id': stayId,
        'outing': outing.toJson(),
        'grade': authService.user?.userGrade,
      });

      return Outing.fromJson(response.data['data']);
    } on DioException catch (e) {

      if(e.response?.data['code'] == 'Stay_NotInApplyPeriod') {
        throw StayNotInApplyPeriodException();
      } else if(e.response?.data['code'] == 'PermissionDenied_Resource') {
        throw PermissionDeniedResourceException();
      } else if(e.response?.data['code'] == 'ProvidedTime_Invalid') {
        throw ProvidedTimeInvalidException();
      }

      rethrow;
    }
  }

  Future<Outing> updateStayOuting(String outingId, Outing outing) async {
    String url = '/student/stay/outing';

    try {
      DFHttpResponse response = await api.patch(url, data: {
        'outing_id': outingId,
        'outing': outing.toJson(),
        'grade': authService.user?.userGrade,
      });

      return Outing.fromJson(response.data['data']);
    } on DioException catch (e) {

      if(e.response?.data['code'] == 'Stay_NotInApplyPeriod') {
        throw StayNotInApplyPeriodException();
      } else if(e.response?.data['code'] == 'PermissionDenied_Resource') {
        throw PermissionDeniedResourceException();
      } else if(e.response?.data['code'] == 'ProvidedTime_Invalid') {
        throw ProvidedTimeInvalidException();
      }

      rethrow;
    }
  }

  Future<void> deleteStayOuting(String outingId) async {
    String url = '/student/stay/outing';

    try {
      await api.delete(url, queryParameters: {
        'id': outingId,
        'grade': authService.user?.userGrade,
      });
    } on DioException catch (e) {

      if(e.response?.data['code'] == 'Stay_NotInApplyPeriod') {
        throw StayNotInApplyPeriodException();
      } else if(e.response?.data['code'] == 'PermissionDenied_Resource') {
        throw PermissionDeniedResourceException();
      }

      rethrow;
    }
  }
}