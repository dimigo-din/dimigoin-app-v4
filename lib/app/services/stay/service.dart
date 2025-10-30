import 'dart:async';
import 'dart:developer';
import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:get/get.dart';

import 'model.dart';
import 'repository.dart';

class StayService extends GetxController {
  final StayRepository repository;

  AuthService authService = Get.find<AuthService>();

  StayService({StayRepository? repository}) : repository = repository ?? StayRepository();

  @override
  Future<void> onInit() async {
    super.onInit();
    initialize(); 
  }

  Future<void> initialize() async {
  }

  Future<List<Stay>> getStay() async {
    try {
      final response = await repository.getStay();

      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<StayApply>> getStayApplication() async {
    try {
      final response = await repository.getStayApplication();

      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<StayApply> addStayApplication(String stayId, String seatId, List<Outing> outings, {String? noSeatReason}) async {
    try {
      final response = await repository.addStayApplication(stayId, seatId, outings, noSeatReason: noSeatReason);

      return response;
    } on StayNotInApplyPeriodException catch (e) {
      log(e.toString());
      rethrow;
    } on StayAlreadyAppliedException catch (e) {
      log(e.toString());
      rethrow;
    } on StaySeatDuplicationException catch (e) {
      log(e.toString());
      rethrow;
    } on StaySeatNotAllowedException catch (e) {
      log(e.toString());
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> deleteStayApplication(String id) async {
    try {
      await repository.deleteStayApplication(id);
    } on ResourceNotFoundException catch (e) {
      log(e.toString());
      rethrow;
    } on PermissionDeniedResourceException catch (e) {
      log(e.toString());
      rethrow;
    } on StayNotInApplyPeriodException catch (e) {
      log(e.toString());
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<Outing>> getStayOuting(String id) async {
    try {
      final response = await repository.getStayOuting(id);

      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<Outing> addStayOuting(String stayId, Outing outing) async {
    try {
      final response = await repository.addStayOuting(stayId, outing);
      return response;
    } on StayNotInApplyPeriodException catch (e) {
      log(e.toString());
      rethrow;
    } on PermissionDeniedResourceException catch (e) {
      log(e.toString());
      rethrow;
    } on ProvidedTimeInvalidException catch (e) {
      log(e.toString());
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<Outing> updateStayOuting(String outingId, Outing outing) async {
    try {
      final response = await repository.updateStayOuting(outingId, outing);
      return response;
    } on StayNotInApplyPeriodException catch (e) {
      log(e.toString());
      rethrow;
    } on PermissionDeniedResourceException catch (e) {
      log(e.toString());
      rethrow;
    } on ProvidedTimeInvalidException catch (e) {
      log(e.toString());
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> deleteStayOuting(String outingId) async {
    try {
      await repository.deleteStayOuting(outingId);
    } on StayNotInApplyPeriodException catch (e) {
      log(e.toString());
      rethrow;
    } on PermissionDeniedResourceException catch (e) {
      log(e.toString());
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}