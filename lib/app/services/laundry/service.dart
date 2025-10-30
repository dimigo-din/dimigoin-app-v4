import 'dart:async';
import 'dart:developer';
import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:get/get.dart';

import 'model.dart';
import 'repository.dart';

class LaundryService extends GetxController {
  final LaundryRepository repository;

  AuthService authService = Get.find<AuthService>();

  LaundryService({LaundryRepository? repository}) : repository = repository ?? LaundryRepository();

  @override
  Future<void> onInit() async {
    super.onInit();
    initialize(); 
  }

  Future<void> initialize() async {
  }

  Future<LaundryTimeline> getLaundryTimeline() async {
    try {
      final response = await repository.getLaundryTimeline();

      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<LaundryApply>> getLaundryApplications() async {
    try {
      final response = await repository.getLaundryApplications();

      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> applyLaundry(String timeId, String machineId) async {
    try {
      await repository.applyLaundry(timeId, machineId);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> deleteLaundryApplication(String applyId) async {
    try {
      await repository.deleteLaundryApplication(applyId);
    } on LaundryApplyIsAfterEightAMException catch (e) {
      log(e.toString());
      throw LaundryApplyIsAfterEightAMException();
    } on LaundryApplyAlreadyExistsException catch (e) {
      log(e.toString());
      throw LaundryApplyAlreadyExistsException();
    } on PermissionDeniedResourceGradeException catch (e) {
      log(e.toString());
      throw PermissionDeniedResourceGradeException();
    } on LaundryMachineAlreadyTakenException catch (e) {
      log(e.toString());
      throw LaundryMachineAlreadyTakenException();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}