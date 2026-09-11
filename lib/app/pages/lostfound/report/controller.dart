import 'package:dimigoin_app_v4/app/provider/api_interface.dart';
import 'package:dimigoin_app_v4/app/services/lostfound/repository.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackBar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:image_picker/image_picker.dart';

class LostfoundReportPageController extends GetxController {
  late final LostfoundRepository repository;

  final objectNameTEC = TextEditingController();
  final lastSeenPlaceTEC = TextEditingController();
  final bodyTEC = TextEditingController();
  final imagePicker = ImagePicker();

  List<XFile> images = [];
  bool isSubmitting = false;

  static const _allowedImageExtensions = {'jpg', 'jpeg', 'png'};
  static const _maxImages = 5;

  @override
  void onInit() {
    super.onInit();
    repository = LostfoundRepository(api: Get.find<ApiProvider>());
  }

  @override
  void onClose() {
    objectNameTEC.dispose();
    lastSeenPlaceTEC.dispose();
    bodyTEC.dispose();
    super.onClose();
  }

  Future<void> pickImages() async {
    // 원본 사진은 장당 수 MB 라 업로드가 느립니다. 물건 확인에는 이 정도면 충분합니다.
    final picked = await imagePicker.pickMultiImage(
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (picked.isEmpty) return;

    final validImages = picked
        .where(
          (image) =>
              _allowedImageExtensions.contains(_imageExtension(image.name)),
        )
        .take(_maxImages)
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

  Future<void> submit() async {
    final objectName = objectNameTEC.text.trim();
    final lastSeenPlace = lastSeenPlaceTEC.text.trim();
    final body = bodyTEC.text.trim();

    if (objectName.isEmpty || lastSeenPlace.isEmpty || body.isEmpty) {
      DFSnackBar.error('물건, 장소, 상세 내용을 모두 입력해주세요.');
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

      await repository.createReport(
        objectName: objectName,
        lastSeenPlace: lastSeenPlace,
        body: body,
        files: files,
      );

      DFSnackBar.success('분실물 제보가 등록되었습니다.');
      Get.back(result: true);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      if (statusCode == 429) {
        // 서버에서 제보 생성에 레이트 리밋을 겁니다.
        DFSnackBar.error('제보를 너무 자주 등록했습니다. 잠시 후 다시 시도해주세요.');
      } else {
        DFSnackBar.error(
          statusCode == null ? '제보 등록에 실패했습니다.' : '제보 등록에 실패했습니다. ($statusCode)',
        );
      }
    } catch (_) {
      DFSnackBar.error('제보 등록에 실패했습니다.');
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
    return 'lostfound_${DateTime.now().millisecondsSinceEpoch}.$extension';
  }
}
