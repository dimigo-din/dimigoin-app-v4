import 'dart:developer';

import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:image_picker/image_picker.dart';

import 'model.dart';
import 'repository.dart';
import 'state.dart';

class LostfoundService extends GetxController {
  final LostfoundRepository repository;

  final Rx<LostfoundState> _lostfoundState = Rx<LostfoundState>(
    const LostfoundInitial(),
  );
  LostfoundState get lostfoundState => _lostfoundState.value;

  final Rx<LostfoundDetailState> _lostfoundDetailState =
      Rx<LostfoundDetailState>(const LostfoundDetailInitial());
  LostfoundDetailState get lostfoundDetailState => _lostfoundDetailState.value;

  LostfoundStatus? _status;
  bool? _mine;
  int _requestId = 0;
  int _detailRequestId = 0;

  LostfoundService({LostfoundRepository? repository})
    : repository = repository ?? LostfoundRepository();

  @override
  void onClose() {
    _requestId++;
    _detailRequestId++;
    super.onClose();
  }

  Future<void> getReports({LostfoundStatus? status, bool? mine}) async {
    final requestId = ++_requestId;
    _status = status;
    _mine = mine;
    _lostfoundState.value = const LostfoundLoading();

    try {
      final reports = await repository.getReports(status: status, mine: mine);
      // 새로고침이나 탭 전환 이전에 시작한 요청은 현재 목록에 반영하지 않습니다.
      if (requestId != _requestId || isClosed) return;
      _lostfoundState.value = LostfoundSuccess(
        reports,
        page: 1,
        hasMore: reports.length >= LostfoundRepository.pageSize,
      );
    } catch (e, stackTrace) {
      log('Error fetching lostfound reports: $e', stackTrace: stackTrace);
      if (requestId != _requestId || isClosed) return;
      _lostfoundState.value = LostfoundFailure(
        e is Exception ? e : Exception(e.toString()),
      );
      rethrow;
    }
  }

  Future<void> getMoreReports() async {
    final state = lostfoundState;
    if (state is! LostfoundSuccess || state.isLoadingMore || !state.hasMore) {
      return;
    }

    final requestId = _requestId;
    _lostfoundState.value = LostfoundSuccess(
      state.reports,
      page: state.page,
      hasMore: state.hasMore,
      isLoadingMore: true,
    );

    try {
      final reports = await repository.getReports(
        page: state.page + 1,
        status: _status,
        mine: _mine,
      );
      if (requestId != _requestId || isClosed) return;
      _lostfoundState.value = LostfoundSuccess(
        [...state.reports, ...reports],
        page: state.page + 1,
        hasMore: reports.length >= LostfoundRepository.pageSize,
      );
    } catch (e, stackTrace) {
      log('Error fetching more lostfound reports: $e', stackTrace: stackTrace);
      if (requestId != _requestId || isClosed) return;
      // 추가 조회 실패 시 기존 목록과 페이지를 유지해 같은 페이지를 재시도합니다.
      _lostfoundState.value = LostfoundSuccess(
        state.reports,
        page: state.page,
        hasMore: state.hasMore,
        loadMoreException: e is Exception ? e : Exception(e.toString()),
      );
      rethrow;
    }
  }

  Future<void> refreshReport(String id, String? userId) async {
    final state = lostfoundState;
    if (state is! LostfoundSuccess) return;
    final index = state.reports.indexWhere((report) => report.id == id);
    if (index == -1) return;
    final before = state.reports[index];
    if (before.userId != userId || before.isConcluded) {
      return;
    }

    final requestId = _requestId;
    try {
      final after = await repository.getReport(id);
      if (requestId != _requestId || isClosed) return;
      if (after.status != before.status ||
          after.isConcluded != before.isConcluded) {
        // 회수 처리로 목록의 정렬 순서가 바뀌므로 첫 페이지부터 다시 받습니다.
        await getReports(status: _status, mine: _mine);
      }
    } catch (e, stackTrace) {
      log('Error refreshing lostfound report: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> getReport(String id) async {
    final requestId = ++_detailRequestId;
    _lostfoundDetailState.value = const LostfoundDetailLoading();

    try {
      if (id.isEmpty) throw ResourceNotFoundException();
      final report = await repository.getReport(id);
      if (requestId != _detailRequestId || isClosed) return;
      _lostfoundDetailState.value = LostfoundDetailSuccess(report);
    } catch (e, stackTrace) {
      log('Error fetching lostfound report: $e', stackTrace: stackTrace);
      if (requestId != _detailRequestId || isClosed) return;
      _lostfoundDetailState.value = LostfoundDetailFailure(
        e is Exception ? e : Exception(e.toString()),
      );
      rethrow;
    }
  }

  Future<void> markFound(String id) async {
    final state = lostfoundDetailState;
    final requestId = ++_detailRequestId;
    try {
      final updated = await repository.markFound(id);
      if (requestId != _detailRequestId || isClosed) return;
      // 회수 응답에는 댓글이 없으므로 상세 조회에서 받은 댓글을 유지합니다.
      final comments = state is LostfoundDetailSuccess && state.report.id == id
          ? state.report.comment
          : updated.comment;
      _lostfoundDetailState.value = LostfoundDetailSuccess(
        updated.copyWith(comment: comments),
      );
    } catch (e, stackTrace) {
      log(
        'Error marking lostfound report as found: $e',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> createReport({
    required LostfoundStatus status,
    required String objectName,
    required String lastSeenPlace,
    required String body,
    required List<XFile> images,
  }) async {
    try {
      final files = <MultipartFile>[];
      for (final image in images) {
        files.add(
          MultipartFile.fromBytes(
            await image.readAsBytes(),
            filename: image.name,
          ),
        );
      }
      await repository.createReport(
        status: status,
        objectName: objectName,
        lastSeenPlace: lastSeenPlace,
        body: body,
        files: files,
      );
    } catch (e, stackTrace) {
      log('Error creating lostfound report: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> postComment({required String post, required String text}) async {
    try {
      await repository.postComment(post: post, text: text);
    } catch (e, stackTrace) {
      log('Error posting lostfound comment: $e', stackTrace: stackTrace);
      rethrow;
    }
  }
}
