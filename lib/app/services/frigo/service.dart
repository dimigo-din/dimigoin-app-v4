import 'dart:async';
import 'dart:developer';
import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:get/get.dart';

import 'repository.dart';
import 'state.dart';

class FrigoService extends GetxController {
  final FrigoRepository repository;

  AuthService authService = Get.find<AuthService>();

  final Rx<FrigoState> _frigoState = Rx<FrigoState>(
    const FrigoInitial(),
  );
  FrigoState get frigoState => _frigoState.value; 

  FrigoService({FrigoRepository? repository})
    : repository = repository ?? FrigoRepository();

  @override
  Future<void> onInit() async {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {}

  Future<void> getFrigoApplication() async {
    _frigoState.value = const FrigoLoading();
    try {
      final response = await repository.getFrigoApplication();

      if (response == null) {
        _frigoState.value = const FrigoSuccess(null);
        return;
      }

      _frigoState.value = FrigoSuccess(response);
    } catch (e) {
      log(e.toString());
      _frigoState.value = FrigoFailure(e.toString());
      rethrow;
    }
  }

  Future<void> addFrigoApplication(String timing, String reason) async {
    try {
      await repository.addFrigoApplication(timing, reason);
    } on FrigoPeriodNotExistsForGradeException catch (e) {
      log(e.toString());
      rethrow;
    } on FrigoPeriodNotInApplyPeriodException catch (e) {
      log(e.toString());
      rethrow;
    } on FrigoAlreadyAppliedException catch (e) {
      log(e.toString());
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> deleteFrigoApplication() async {
    try {
      await repository.deleteFrigoApplication();
    } on FrigoPeriodNotInApplyPeriodException catch (e) {
      log(e.toString());
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
