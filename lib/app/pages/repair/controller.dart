import 'package:dio/dio.dart';
import 'package:dimigoin_app_v4/app/provider/api_interface.dart';
import 'package:dimigoin_app_v4/app/services/facility/model.dart';
import 'package:dimigoin_app_v4/app/services/facility/repository.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:image_picker/image_picker.dart';

class RepairPageController extends GetxController {
  late final FacilityRepository repository;
  final titleTEC = TextEditingController();
  final bodyTEC = TextEditingController();
  final imagePicker = ImagePicker();

  List<XFile> images = [];
  List<FacilityReport> reports = [];
  bool isLoadingReports = true;
  bool isSubmitting = false;
  String selectedReportType = 'broken';
  String? reportLoadError;
  int selectedTab = 0;

  static const _allowedImageExtensions = {'jpg', 'jpeg', 'png'};

  @override
  void onInit() {
    super.onInit();
    repository = FacilityRepository(api: Get.find<ApiProvider>());
    loadReports();
  }

  @override
  void onClose() {
    titleTEC.dispose();
    bodyTEC.dispose();
    super.onClose();
  }

  Future<void> loadReports() async {
    isLoadingReports = true;
    reportLoadError = null;
    update();

    try {
      reports = await repository.getReports();
    } catch (_) {
      reportLoadError = '신청 목록을 불러오지 못했습니다.';
    } finally {
      isLoadingReports = false;
      update();
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

    images = validImages;
    update();
  }

  void clearImages() {
    images = [];
    update();
  }

  void changeReportType(String value) {
    selectedReportType = value;
    update();
  }

  void changeTab(int index) {
    selectedTab = index;
    update();
  }

  Future<void> submit() async {
    final title = titleTEC.text.trim();
    final body = bodyTEC.text.trim();

    if (title.isEmpty || body.isEmpty) {
      DFSnackBar.error('제목과 문의 내용을 모두 입력해주세요.');
      return;
    }

    isSubmitting = true;
    update();

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

      await repository.createRepairReport(
        subject: title,
        body: body,
        reportType: selectedReportType,
        files: files,
      );

      titleTEC.clear();
      bodyTEC.clear();
      images = [];
      selectedReportType = 'broken';
      selectedTab = 1;
      update();

      await loadReports();
      DFSnackBar.success('수리 신청이 접수되었습니다.');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final errorCode = e.response?.data is Map
          ? e.response?.data['code']?.toString()
          : null;
      final suffix = errorCode ?? statusCode?.toString();

      DFSnackBar.error(
        suffix == null ? '수리 신청에 실패했습니다.' : '수리 신청에 실패했습니다. ($suffix)',
      );
    } catch (_) {
      DFSnackBar.error('수리 신청에 실패했습니다.');
    } finally {
      isSubmitting = false;
      update();
    }
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
    return 'repair_${DateTime.now().millisecondsSinceEpoch}.$extension';
  }
}
