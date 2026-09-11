import 'package:dimigoin_app_v4/app/provider/api_interface.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/services/lostfound/model.dart';
import 'package:dimigoin_app_v4/app/services/lostfound/repository.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackBar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LostfoundDetailPageController extends GetxController {
  late final LostfoundRepository repository;
  final commentTEC = TextEditingController();

  late final String reportId;

  LostfoundReport? report;
  bool isLoading = true;
  bool isSubmittingComment = false;
  bool isMarkingFound = false;
  String? loadError;

  /// 작성자 본인인지. 회수 처리 버튼은 작성자에게만 보여줍니다.
  bool get isMine {
    final myId = Get.find<AuthService>().user?.id;
    return myId != null && report?.userId == myId;
  }

  bool get canMarkFound => isMine && report?.status == LostfoundStatus.lost;

  @override
  void onInit() {
    super.onInit();
    repository = LostfoundRepository(api: Get.find<ApiProvider>());

    final arguments = Get.arguments;
    reportId = arguments is Map ? (arguments['id'] as String? ?? '') : '';

    loadReport();
  }

  @override
  void onClose() {
    commentTEC.dispose();
    super.onClose();
  }

  Future<void> loadReport() async {
    if (reportId.isEmpty) {
      isLoading = false;
      loadError = '제보를 찾을 수 없습니다.';
      update();
      return;
    }

    isLoading = true;
    loadError = null;
    update();

    try {
      report = await repository.getReport(reportId);
    } catch (_) {
      loadError = '제보를 불러오지 못했습니다.';
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> markFound() async {
    if (isMarkingFound) return;

    isMarkingFound = true;
    update();

    try {
      final updated = await repository.markFound(reportId);
      // 응답에는 댓글이 없으므로 기존 댓글은 유지합니다.
      report = LostfoundReport(
        id: updated.id,
        status: updated.status,
        objectName: updated.objectName,
        lastSeenPlace: updated.lastSeenPlace,
        body: updated.body,
        createdAt: updated.createdAt,
        img: updated.img,
        comment: report?.comment ?? updated.comment,
        userId: updated.userId,
        userName: updated.userName,
      );
      DFSnackBar.success('회수로 표시했습니다.');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      DFSnackBar.error(switch (statusCode) {
        403 => '본인이 작성한 제보만 회수로 표시할 수 있습니다.',
        404 => '제보를 찾을 수 없습니다.',
        null => '회수 처리에 실패했습니다.',
        _ => '회수 처리에 실패했습니다. ($statusCode)',
      });
    } catch (_) {
      DFSnackBar.error('회수 처리에 실패했습니다.');
    } finally {
      isMarkingFound = false;
      update();
    }
  }

  Future<void> submitComment() async {
    final text = commentTEC.text.trim();
    if (text.isEmpty) {
      DFSnackBar.error('댓글 내용을 입력해주세요.');
      return;
    }

    isSubmittingComment = true;
    update();

    try {
      await repository.postComment(post: reportId, text: text);
      commentTEC.clear();
      await loadReport();
      DFSnackBar.success('댓글을 남겼습니다.');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      DFSnackBar.error(
        statusCode == null ? '댓글 작성에 실패했습니다.' : '댓글 작성에 실패했습니다. ($statusCode)',
      );
    } catch (_) {
      DFSnackBar.error('댓글 작성에 실패했습니다.');
    } finally {
      isSubmittingComment = false;
      update();
    }
  }
}
