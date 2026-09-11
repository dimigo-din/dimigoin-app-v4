import 'dart:developer';

import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/services/lostfound/service.dart';
import 'package:dimigoin_app_v4/app/services/lostfound/model.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class LostfoundReportPageController extends GetxController {
  final LostfoundService lostfoundService;

  LostfoundReportPageController({LostfoundService? lostfoundService})
    : lostfoundService = lostfoundService ?? LostfoundService();

  final objectNameTEC = TextEditingController();
  final lastSeenPlaceTEC = TextEditingController();
  final bodyTEC = TextEditingController();
  final imagePicker = ImagePicker();
  final RxList<XFile> images = <XFile>[].obs;
  final RxBool isSubmitting = false.obs;
  LostfoundStatus get status =>
      Get.arguments is Map && Get.arguments['status'] is LostfoundStatus
      ? Get.arguments['status'] as LostfoundStatus
      : LostfoundStatus.lost;

  static const _allowedImageExtensions = {'jpg', 'jpeg', 'png'};
  static const _maxImages = 5;

  @override
  void onClose() {
    lostfoundService.onDelete();
    objectNameTEC.dispose();
    lastSeenPlaceTEC.dispose();
    bodyTEC.dispose();
    super.onClose();
  }

  Future<void> pickImages() async {
    if (isSubmitting.value || isClosed) return;
    try {
      final picked = await imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (picked.isEmpty || isClosed || isSubmitting.value) return;

      final validImages = picked.where((image) {
        final extension = image.name.split('.').last.toLowerCase();
        return image.name.contains('.') &&
            _allowedImageExtensions.contains(extension);
      }).toList();

      if (validImages.length != picked.length) {
        DFSnackBar.error('jpg, jpeg, png 이미지만 첨부할 수 있습니다.');
      } else if (validImages.length > _maxImages) {
        DFSnackBar.error('사진은 최대 5장까지 첨부할 수 있습니다.');
      }
      if (validImages.isNotEmpty) {
        images.assignAll(validImages.take(_maxImages));
      }
    } catch (e, stackTrace) {
      log('Error selecting lostfound images: $e', stackTrace: stackTrace);
      if (isClosed) return;
      DFSnackBar.error('사진을 불러오지 못했습니다.');
    }
  }

  void clearImages() {
    if (isSubmitting.value) return;
    images.clear();
  }

  Future<void> submit() async {
    if (isSubmitting.value || isClosed) return;
    final objectName = objectNameTEC.text.trim();
    final lastSeenPlace = lastSeenPlaceTEC.text.trim();
    final body = bodyTEC.text.trim();
    if (objectName.isEmpty || lastSeenPlace.isEmpty || body.isEmpty) {
      DFSnackBar.error('물건, 장소, 상세 내용을 모두 입력해주세요.');
      return;
    }

    final route = Get.currentRoute;
    isSubmitting.value = true;
    try {
      await lostfoundService.createReport(
        status: status,
        objectName: objectName,
        lastSeenPlace: lastSeenPlace,
        body: body,
        images: images.toList(),
      );
      if (isClosed || Get.currentRoute != route) return;
      // 이미 열린 스낵바 대신 등록 화면을 닫고 목록에 완료 결과를 전달합니다.
      Get.back(result: true, closeOverlays: true);
      DFSnackBar.success('분실물 제보가 등록되었습니다.');
    } on TooManyRequestsException {
      if (isClosed) return;
      DFSnackBar.error('제보를 너무 자주 등록했습니다. 잠시 후 다시 시도해주세요.');
    } on DioException catch (e) {
      log(
        'Lostfound create failed: ${e.response?.statusCode} ${e.response?.data}',
      );
      if (isClosed) return;
      final status = e.response?.statusCode;
      DFSnackBar.error(
        status == null ? '제보 등록에 실패했습니다.' : '제보 등록에 실패했습니다. ($status)',
      );
    } catch (e) {
      if (isClosed) return;
      DFSnackBar.error('제보 등록에 실패했습니다.');
    } finally {
      isSubmitting.value = false;
    }
  }
}
