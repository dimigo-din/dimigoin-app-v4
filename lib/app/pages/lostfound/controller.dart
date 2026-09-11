import 'package:dimigoin_app_v4/app/provider/api_interface.dart';
import 'package:dimigoin_app_v4/app/routes/routes.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/services/lostfound/model.dart';
import 'package:dimigoin_app_v4/app/services/lostfound/repository.dart';
import 'package:get/get.dart';

/// 목록 탭. 순서는 화면의 세그먼트 순서와 같습니다.
enum LostfoundTab {
  /// 다른 사람이 아직 찾고 있는 물건
  all(status: LostfoundStatus.lost, mine: false),

  /// 내가 올린 제보 전부 (분실 + 회수)
  myReports(status: null, mine: true),

  /// 회수된 물건
  found(status: LostfoundStatus.found, mine: null);

  final LostfoundStatus? status;
  final bool? mine;

  const LostfoundTab({required this.status, required this.mine});
}

class LostfoundPageController extends GetxController {
  late final LostfoundRepository repository;

  List<LostfoundReport> reports = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMore = true;
  String? loadError;
  LostfoundTab tab = LostfoundTab.all;

  /// 코드에서 탭을 바꿀 때만 올립니다. 세그먼트는 처음 index 만 읽으므로 key 로 다시 만듭니다.
  int segmentVersion = 0;

  int _page = 1;

  /// 탭을 빠르게 바꾸면 이전 탭의 응답이 늦게 도착할 수 있어, 최신 요청의 응답만 반영합니다.
  int _requestId = 0;

  @override
  void onInit() {
    super.onInit();
    repository = LostfoundRepository(api: Get.find<ApiProvider>());
    loadReports();
  }

  Future<void> loadReports() async {
    isLoading = true;
    loadError = null;
    update();

    final requestId = ++_requestId;
    // 새로 불러오는 동안 진행 중이던 추가 로딩은 무시되므로 표시도 끕니다.
    isLoadingMore = false;

    try {
      final loaded = await repository.getReports(
        page: 1,
        status: tab.status,
        mine: tab.mine,
      );
      if (requestId != _requestId) return;

      _page = 1;
      reports = loaded;
      hasMore = loaded.length >= LostfoundRepository.pageSize;
    } catch (_) {
      if (requestId != _requestId) return;
      loadError = '분실물 목록을 불러오지 못했습니다.';
    } finally {
      if (requestId == _requestId) {
        isLoading = false;
        update();
      }
    }
  }

  Future<void> loadMore() async {
    if (isLoading || isLoadingMore || !hasMore) return;

    isLoadingMore = true;
    update();

    final requestId = _requestId;
    try {
      final loaded = await repository.getReports(
        page: _page + 1,
        status: tab.status,
        mine: tab.mine,
      );
      // 그 사이 탭이 바뀌었거나 새로고침됐다면 다른 목록에 섞이지 않도록 버립니다.
      if (requestId != _requestId) return;

      if (loaded.isNotEmpty) {
        _page += 1;
        reports = [...reports, ...loaded];
      }
      hasMore = loaded.length >= LostfoundRepository.pageSize;
    } catch (_) {
      // 추가 로딩 실패는 목록 전체를 오류로 만들지 않고 다음 스크롤에서 재시도합니다.
    } finally {
      if (requestId == _requestId) {
        isLoadingMore = false;
        update();
      }
    }
  }

  void changeTabByIndex(int index) {
    final next = LostfoundTab.values[index];
    if (next == tab) return;

    tab = next;
    update();
    loadReports();
  }

  Future<void> openReport(String id) async {
    await Get.toNamed(Routes.LOSTFOUND_DETAIL, arguments: {'id': id});

    // 상세에서 바뀔 수 있는 건 내 분실 제보의 회수 처리뿐이라, 그 경우만 확인합니다.
    final index = reports.indexWhere((r) => r.id == id);
    if (index == -1) return;
    final before = reports[index];
    final myId = Get.find<AuthService>().user?.id;
    if (before.userId != myId || before.status != LostfoundStatus.lost) return;

    try {
      final after = await repository.getReport(id);
      // 회수로 바뀌면 정렬 위치(분실 먼저)도 바뀌므로, 제자리 교체 대신 서버 순서로 다시 받습니다.
      if (after.status != before.status) await loadReports();
    } catch (_) {
      // 목록 갱신 실패는 조용히 넘기고, 당겨서 새로고침으로 복구할 수 있습니다.
    }
  }

  Future<void> openReportForm() async {
    final created = await Get.toNamed(Routes.LOSTFOUND_REPORT);
    if (created != true) return;

    // 전체 탭은 내 제보를 보여주지 않으므로, 방금 올린 제보가 보이도록 내 분실물로 옮깁니다.
    if (tab != LostfoundTab.myReports) {
      tab = LostfoundTab.myReports;
      segmentVersion++;
    }
    await loadReports();
  }
}
