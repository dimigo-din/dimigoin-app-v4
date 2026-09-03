import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:get/get.dart';

import 'repository.dart';
import 'state.dart';

class FacilityService extends GetxController {
  final FacilityRepository repository;

  AuthService authService = Get.find<AuthService>();

  final Rx<FacilityListState> _facilityState = Rx<FacilityListState>(
    const FacilityListInitial(),
  );
  FacilityListState get facilityState => _facilityState.value;

  FacilityService({FacilityRepository? repository})
    : repository = repository ?? FacilityRepository();

  @override
  Future<void> onInit() async {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {}

  Future<void> fetchReportList() async {
    _facilityState.value = const FacilityListLoading();

    try {
      final reportList = await repository.getReportList();
      _facilityState.value = FacilityListSuccess(reportList);
    } catch (e) {
      log('Error fetching report list: $e');
      _facilityState.value = FacilityListFailure(e.toString());
      rethrow;
    }
  }

  Future<void> fetchReport(String reportId) async {
    _facilityState.value = const FacilityListLoading();

    try {
      final report = await repository.getReport(reportId);
      _facilityState.value = FacilityListSuccess([report]);
    } catch (e) {
      log('Error fetching report: $e');
      _facilityState.value = FacilityListFailure(e.toString());
      rethrow;
    }
  }

  Future<void> createRepairReport({
    required String subject,
    required String body,
    required String reportType,
    required List<dio.MultipartFile> files,
  }) async {
    try {
      await repository.createRepairReport(
        subject: subject,
        body: body,
        reportType: reportType,
        files: files,
      );
    } catch (e) {
      log('Error creating repair report: $e');
      rethrow;
    }
  }
}
