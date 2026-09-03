import 'package:dimigoin_app_v4/app/pages/facility/widgets/facility_detail_bottom_sheet.dart';
import 'package:dimigoin_app_v4/app/services/facility/service.dart';
import 'package:dimigoin_app_v4/app/services/facility/state.dart';
import 'package:dio/dio.dart';
import 'package:dimigoin_app_v4/app/services/facility/model.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:image_picker/image_picker.dart';

class FacilityPageController extends GetxController {
  final facilityService = FacilityService();

  final titleTEC = TextEditingController();
  final bodyTEC = TextEditingController();
  final imagePicker = ImagePicker();

  final RxList<ReportFacility> reports = <ReportFacility>[].obs;
  final RxInt selectedIndex = 0.obs;

  final RxList<XFile> images = <XFile>[].obs;
  final Rx<FacilityReportType> selectedReportType = Rx<FacilityReportType>(
    FacilityReportType.suggest,
  );
  final RxBool isSubmitting = false.obs;

  static const _allowedImageExtensions = {'jpg', 'jpeg', 'png'};

  @override
  void onInit() {
    super.onInit();
    fetchReports();
  }

  @override
  void onClose() {
    titleTEC.dispose();
    bodyTEC.dispose();
    super.onClose();
  }

  Future<bool> fetchReports({bool showError = true}) async {
    try {
      await facilityService.fetchReportList();

      final state = facilityService.facilityState as FacilityListSuccess;
      reports.assignAll(state.facility);
      return true;
    } catch (_) {
      reports.clear();
      if (showError) {
        DFSnackBar.error('수리 신청 내역을 불러오는데 실패했습니다.');
      }
      return false;
    }
  }

  Future<void> pickImages() async {
    final picked = await imagePicker.pickMultiImage();
    if (picked.isEmpty) return;

    final validImages = picked
        .where(
          (image) =>
              _allowedImageExtensions.contains(_imageExtension(image.name)),
        )
        .take(5)
        .toList();

    if (validImages.length != picked.length) {
      DFSnackBar.error('jpg, jpeg, png 이미지만 첨부할 수 있습니다.');
    }

    if (validImages.isEmpty) return;

    images.value = validImages;
  }

  void clearImages() {
    images.value = [];
  }

  Future<void> addReport() async {
    if (isSubmitting.value) return;

    final title = titleTEC.text.trim();
    final body = bodyTEC.text.trim();

    if (title.isEmpty || body.isEmpty) {
      DFSnackBar.error('제목과 문의 내용을 모두 입력해주세요.');
      return;
    }

    isSubmitting.value = true;

    try {
      final files = <MultipartFile>[];
      for (final image in images) {
        final extension = _imageExtension(image.name);
        files.add(
          MultipartFile.fromBytes(
            await image.readAsBytes(),
            filename: _normalizedImageName(image.name, extension),
          ),
        );
      }

      await facilityService.createRepairReport(
        subject: title,
        body: body,
        reportType: selectedReportType.value.name,
        files: files,
      );

      titleTEC.clear();
      bodyTEC.clear();
      images.clear();
      selectedReportType.value = FacilityReportType.suggest;
      await fetchReports(showError: false);
      DFSnackBar.success('수리 신청이 접수되었습니다.');
    } catch (_) {
      DFSnackBar.error('수리 신청에 실패했습니다.');
    } finally {
      isSubmitting.value = false;
    }
  }

  void openReportDetail(ReportFacility report) {
    FacilityDetailBottomSheet.show(context: Get.context!, report: report);
  }

  String _imageExtension(String filename) {
    final dotIndex = filename.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == filename.length - 1) {
      return '';
    }
    return filename.substring(dotIndex + 1).toLowerCase();
  }

  String _normalizedImageName(String filename, String extension) {
    if (filename.contains('.') && extension.isNotEmpty) {
      return filename;
    }
    return 'facility_${DateTime.now().millisecondsSinceEpoch}.$extension';
  }
}
