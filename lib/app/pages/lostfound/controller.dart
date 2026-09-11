import 'dart:developer';

import 'package:dimigoin_app_v4/app/routes/routes.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/services/lostfound/model.dart';
import 'package:dimigoin_app_v4/app/services/lostfound/service.dart';
import 'package:dimigoin_app_v4/app/services/lostfound/state.dart';
import 'package:get/get.dart';

enum LostfoundTab {
  lost(status: LostfoundStatus.lost),
  pickup(status: LostfoundStatus.pickup);

  final LostfoundStatus? status;

  const LostfoundTab({required this.status});
}

class LostfoundPageController extends GetxController {
  final LostfoundService lostfoundService;

  LostfoundPageController({LostfoundService? lostfoundService})
    : lostfoundService = lostfoundService ?? LostfoundService();

  final Rx<LostfoundTab> tab = LostfoundTab.lost.obs;
  final RxInt segmentVersion = 0.obs;

  final RxBool showMine = false.obs;
  final RxBool showConcluded = false.obs;

  List<LostfoundReport> get reports {
    final state = lostfoundService.lostfoundState;
    return state is LostfoundSuccess ? state.reports : const [];
  }

  bool get isLoading {
    final state = lostfoundService.lostfoundState;
    return state is LostfoundInitial || state is LostfoundLoading;
  }

  bool get isLoadingMore {
    final state = lostfoundService.lostfoundState;
    return state is LostfoundSuccess && state.isLoadingMore;
  }

  bool get hasMore {
    final state = lostfoundService.lostfoundState;
    return state is LostfoundSuccess && state.hasMore;
  }

  bool get hasLoadMoreError {
    final state = lostfoundService.lostfoundState;
    return state is LostfoundSuccess && state.loadMoreException != null;
  }

  String? get loadError => lostfoundService.lostfoundState is LostfoundFailure
      ? '분실물 목록을 불러오지 못했습니다.'
      : null;

  @override
  void onInit() {
    super.onInit();
    loadReports();
  }

  @override
  void onClose() {
    lostfoundService.onDelete();
    super.onClose();
  }

  Future<void> loadReports() async {
    try {
      await lostfoundService.getReports(
        status: tab.value.status,
        mine: showMine.value ? true : null,
      );
    } catch (e) {
      log('Error loading lostfound reports: $e');
    }
  }

  Future<void> toggleMine() async {
    showMine.value = !showMine.value;
    await loadReports();
  }

  Future<void> toggleConcluded() async {
    showConcluded.value = !showConcluded.value;
  }

  Future<void> loadMore() async {
    try {
      await lostfoundService.getMoreReports();
    } catch (e) {
      log('Error loading more lostfound reports: $e');
    }
  }

  Future<void> changeTabByIndex(int index) async {
    if (index < 0 || index >= LostfoundTab.values.length) return;
    final next = LostfoundTab.values[index];
    if (next == tab.value) return;
    tab.value = next;
    await loadReports();
  }

  Future<void> openReport(String id) async {
    await Get.toNamed(Routes.LOSTFOUND_DETAIL, arguments: {'id': id});
    if (isClosed) return;
    try {
      await lostfoundService.refreshReport(
        id,
        Get.find<AuthService>().user?.id,
      );
    } catch (e) {
      log('Error refreshing lostfound reports after detail: $e');
    }
  }

  Future<void> openReportForm() async {
    await Get.toNamed(
      Routes.LOSTFOUND_REPORT,
      arguments: {
        'status': tab.value == LostfoundTab.lost
            ? LostfoundStatus.lost
            : LostfoundStatus.pickup,
        'title': switch (tab.value) {
          LostfoundTab.lost => '분실물 등록',
          LostfoundTab.pickup => '습득물 등록',
        },
      },
    );
    if (isClosed) return;
    await loadReports();
  }
}
