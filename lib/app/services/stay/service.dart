import 'dart:async';
import 'dart:developer';
import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:get/get.dart';

import 'model.dart';
import 'repository.dart';
import 'state.dart';

class StayService extends GetxController {
  final StayRepository repository;

  AuthService authService = Get.find<AuthService>();

  final Rx<StayState> _stayState = Rx<StayState>(
    const StayInitial(),
  );
  StayState get stayState => _stayState.value;

  final Rx<StayApplyState> _stayApplyState = Rx<StayApplyState>(
    const StayApplyInitial(),
  );
  StayApplyState get stayApplyState => _stayApplyState.value;

  final Rx<StayOutingState> _stayOutingState = Rx<StayOutingState>(
    const StayOutingInitial(),
  );
  StayOutingState get stayOutingState => _stayOutingState.value;

  StayService({StayRepository? repository})
    : repository = repository ?? StayRepository();

  @override
  Future<void> onInit() async {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {}

  Future<void> getStay() async {
    _stayState.value = const StayLoading();
    try {
      final response = await repository.getStay();

      _stayState.value = StaySuccess(response);
    } catch (e) {
      _stayState.value = StayFailure(e.toString());
      rethrow;
    }
  }

  Future<void> getStayApplication() async {
    _stayApplyState.value = const StayApplyLoading();
    try {
      final response = await repository.getStayApplication();

      _stayApplyState.value = StayApplySuccess(response);
    } catch (e) {
      _stayApplyState.value = StayApplyFailure(e.toString());
      log(e.toString());
      rethrow;
    }
  }

  Future<StayApply> addStayApplication(
    String stayId,
    String seatId,
    List<Outing> outings, {
    String? noSeatReason,
  }) async {
    try {
      final response = await repository.addStayApplication(
        stayId,
        seatId,
        outings,
        noSeatReason: noSeatReason,
      );

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

  Future<void> getStayOuting(String id) async {
    _stayOutingState.value = const StayOutingLoading();
    try {
      final response = await repository.getStayOuting(id);

      _stayOutingState.value = StayOutingSuccess(response);
    } catch (e) {
      _stayOutingState.value = StayOutingFailure(e.toString());
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
