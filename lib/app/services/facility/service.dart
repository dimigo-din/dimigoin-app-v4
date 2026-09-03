import 'dart:async';
import 'dart:developer';
import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/services/facility/model.dart';
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

  Future<void> fetchReportList({int page = 1}) async {
    _facilityState.value = const FacilityListLoading();

    try {
      final reportList = await fetchReportListPage(page: page);
      _facilityState.value = FacilityListSuccess(reportList);
    } catch (e) {
      log('Error fetching report list: $e');
      _facilityState.value = FacilityListFailure(e.toString());
      rethrow;
    }
  }

  Future<List<ReportFacility>> fetchReportListPage({required int page}) {
    return repository.getReportList(page: page);
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
    } on FacilityRateLimitExceededException {
      rethrow;
    } catch (e) {
      log('Error creating repair report: $e');
      rethrow;
    }
  }

  Future<List<String>> fetchReportImg(String reportId) async {
    try {
      return await repository.getReportImg(reportId);
    } catch (e) {
      log('Error fetching report images: $e');
      rethrow;
    }
  }
}
