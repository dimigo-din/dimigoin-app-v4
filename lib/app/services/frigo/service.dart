import 'dart:async';
import 'dart:developer';
import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:get/get.dart';

import 'model.dart';
import 'repository.dart';

class FrigoService extends GetxController {
  final FrigoRepository repository;

  AuthService authService = Get.find<AuthService>();

  FrigoService({FrigoRepository? repository}) : repository = repository ?? FrigoRepository();

  @override
  Future<void> onInit() async {
    super.onInit();
    initialize(); 
  }

  Future<void> initialize() async {
  }

  Future<Frigo> getFrigoApplication() async {
    try {
      final response = await repository.getFrigoApplication();

      return response;
    } catch (e) {
      log(e.toString());
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