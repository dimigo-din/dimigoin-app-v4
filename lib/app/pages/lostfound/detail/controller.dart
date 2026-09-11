import 'dart:developer';

import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/services/lostfound/model.dart';
import 'package:dimigoin_app_v4/app/services/lostfound/service.dart';
import 'package:dimigoin_app_v4/app/services/lostfound/state.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LostfoundDetailPageController extends GetxController {
  final LostfoundService lostfoundService;

  LostfoundDetailPageController({LostfoundService? lostfoundService})
    : lostfoundService = lostfoundService ?? LostfoundService();

  final commentTEC = TextEditingController();
  final RxBool isSubmittingComment = false.obs;
  final RxBool isMarkingFound = false.obs;
  late final String reportId;

  LostfoundReport? get report {
    final state = lostfoundService.lostfoundDetailState;
    return state is LostfoundDetailSuccess ? state.report : null;
  }

  bool get isLoading {
    final state = lostfoundService.lostfoundDetailState;
    return state is LostfoundDetailInitial || state is LostfoundDetailLoading;
  }

  String? get loadError {
    final state = lostfoundService.lostfoundDetailState;
    if (state is! LostfoundDetailFailure) return null;
    if (state.exception is ResourceNotFoundException) {
      return '제보를 찾을 수 없습니다.';
    }
    return '제보를 불러오지 못했습니다.';
  }

  bool get isMine {
    final myId = Get.find<AuthService>().user?.id;
    return myId != null && report?.userId == myId;
  }

  bool get canMarkFound => isMine && report?.isConcluded == false;
  bool get isBusy => isSubmittingComment.value || isMarkingFound.value;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    reportId = arguments is Map && arguments['id'] is String
        ? arguments['id'] as String
        : '';
    loadReport();
  }

  @override
  void onClose() {
    lostfoundService.onDelete();
    commentTEC.dispose();
    super.onClose();
  }

  Future<void> loadReport() async {
    try {
      await lostfoundService.getReport(reportId);
    } catch (e) {
      log('Error loading lostfound detail: $e');
    }
  }

  Future<void> markFound() async {
    if (isBusy || !canMarkFound || isClosed) return;
    isMarkingFound.value = true;
    try {
      await lostfoundService.markFound(reportId);
      if (isClosed) return;
      DFSnackBar.success('회수로 표시했습니다.');
    } on PermissionDeniedResourceException {
      if (isClosed) return;
      DFSnackBar.error('본인이 작성한 제보만 회수로 표시할 수 있습니다.');
    } on ResourceNotFoundException {
      if (isClosed) return;
      DFSnackBar.error('제보를 찾을 수 없습니다.');
    } catch (e) {
      if (isClosed) return;
      DFSnackBar.error('회수 처리에 실패했습니다.');
    } finally {
      isMarkingFound.value = false;
    }
  }

  Future<void> submitComment() async {
    if (isBusy || isLoading || isClosed) return;
    final text = commentTEC.text.trim();
    if (text.isEmpty) {
      DFSnackBar.error('댓글 내용을 입력해주세요.');
      return;
    }

    isSubmittingComment.value = true;
    try {
      await lostfoundService.postComment(post: reportId, text: text);
      if (isClosed) return;
      // 요청 중 새로 입력한 내용은 삭제하지 않습니다.
      if (commentTEC.text.trim() == text) commentTEC.clear();
      await loadReport();
      if (isClosed) return;
      DFSnackBar.success('댓글을 남겼습니다.');
    } on ResourceNotFoundException {
      if (isClosed) return;
      DFSnackBar.error('제보를 찾을 수 없습니다.');
    } on PermissionDeniedResourceException {
      if (isClosed) return;
      DFSnackBar.error('댓글을 작성할 권한이 없습니다.');
    } on TooManyRequestsException {
      if (isClosed) return;
      DFSnackBar.error('댓글을 너무 자주 등록했습니다. 잠시 후 다시 시도해주세요.');
    } catch (e) {
      if (isClosed) return;
      DFSnackBar.error('댓글 작성에 실패했습니다.');
    } finally {
      isSubmittingComment.value = false;
    }
  }
}
