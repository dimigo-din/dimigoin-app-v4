import 'dart:developer';

import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/pages/home/controller.dart';
import 'package:dimigoin_app_v4/app/pages/stay/stay_outing/utils/outing_date_utils.dart';
import 'package:dimigoin_app_v4/app/services/stay/model.dart';
import 'package:dimigoin_app_v4/app/services/stay/service.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StayPageController extends GetxController {
  final stayService = StayService();

  final RxInt selectedIndex = 0.obs;

  final RxList<Stay> stayList = <Stay>[].obs;
  final RxInt selectedStayIndex = 0.obs;
  final Rx<Stay?> selectedStay = Rx<Stay?>(null);

  final RxList<StayApply> stayApplyList = <StayApply>[].obs;

  final RxList<Outing> currentStayOutings = <Outing>[].obs;
  final RxInt selectedStayOutingDay = 0.obs;

  final RxString selectedSeat = ''.obs;
  final noSeatReason = TextEditingController();

  final Rx<TimeOfDay?> outingFrom = Rxn<TimeOfDay>();
  final Rx<TimeOfDay?> outingTo = Rxn<TimeOfDay>();
  final outingReasonTEC = TextEditingController();
  final RxBool breakfastCancel = false.obs;
  final RxBool lunchCancel = false.obs;
  final RxBool dinnerCancel = false.obs;

  final RxBool isApplied = false.obs;

  void updateIsApplied() {
    final currentStayId = selectedStay.value?.id;
    if (currentStayId == null) {
      isApplied.value = false;
      return;
    }

    isApplied.value =
        stayApplyList.firstWhereOrNull(
          (application) => application.stay?.id == currentStayId,
        ) !=
        null;
  }

  void resetOutingForm() {
    outingFrom.value = null;
    outingTo.value = null;
    outingReasonTEC.text = '';
    breakfastCancel.value = false;
    lunchCancel.value = false;
    dinnerCancel.value = false;
  }

  void initOutingForm(Outing o) {
    outingFrom.value = o.from != null
        ? TimeOfDay.fromDateTime(OutingDateUtils.parseServerDateTime(o.from!))
        : null;
    outingTo.value = o.to != null
        ? TimeOfDay.fromDateTime(OutingDateUtils.parseServerDateTime(o.to!))
        : null;
    outingReasonTEC.text = o.reason ?? '';
    breakfastCancel.value = o.breakfastCancel ?? false;
    lunchCancel.value = o.lunchCancel ?? false;
    dinnerCancel.value = o.dinnerCancel ?? false;
  }

  void applyOutingPreset() {
    outingFrom.value = const TimeOfDay(hour: 10, minute: 20);
    outingTo.value = const TimeOfDay(hour: 14, minute: 0);
    outingReasonTEC.text = "자기계발외출";
    breakfastCancel.value = false;
    lunchCancel.value = true;
    dinnerCancel.value = false;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchStayApply();
    await fetchStayList();
  }

  DateTime _normalizeKstDate(DateTime dateTime) {
    final kstDate = dateTime.toUtc().add(const Duration(hours: 9));
    return DateTime(kstDate.year, kstDate.month, kstDate.day);
  }

  DateTime _weekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday - DateTime.monday));
  }

  bool _isSameDay(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }

  DateTime _parseStayDate(String rawDate) {
    final datePrefix = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(rawDate);
    if (datePrefix != null) {
      return DateTime(
        int.parse(datePrefix.group(1)!),
        int.parse(datePrefix.group(2)!),
        int.parse(datePrefix.group(3)!),
      );
    }

    final parsed = DateTime.parse(rawDate);
    return _normalizeKstDate(parsed);
  }

  DateTime _effectiveStayBaseDate() {
    final todayKst = _normalizeKstDate(DateTime.now());
    if (todayKst.weekday == DateTime.sunday) {
      return todayKst.add(const Duration(days: 1));
    }
    return todayKst;
  }

  Future<void> fetchStayList([String? preferredStayId]) async {
    final stays = await stayService.getStay();
    final sortedStays = [...stays]
      ..sort(
        (a, b) =>
            _parseStayDate(b.stayFrom).compareTo(_parseStayDate(a.stayFrom)),
      );

    final targetWeekStart = _weekStart(_effectiveStayBaseDate());
    final sameWeekStays = sortedStays.where((stay) {
      final stayWeekStart = _weekStart(_parseStayDate(stay.stayFrom));
      return _isSameDay(stayWeekStart, targetWeekStart);
    }).toList();

    final visibleStays = sameWeekStays.isNotEmpty ? sameWeekStays : sortedStays;
    stayList.assignAll(visibleStays);

    if (stayList.isEmpty) {
      selectedStayIndex.value = 0;
      selectedStay.value = null;
      selectedSeat.value = '';
      noSeatReason.text = '';
      isApplied.value = false;
      currentStayOutings.clear();
      return;
    }

    final selected = preferredStayId == null
        ? null
        : stayList.firstWhereOrNull((stay) => stay.id == preferredStayId);

    await selectStay(selected ?? stayList[0]);
  }

  Future<void> selectStay(Stay stay) async {
    selectedStayIndex.value = stayList.indexOf(stay);
    selectedStay.value = stay;

    selectedStayOutingDay.value = 0;

    final application = stayApplyList.firstWhereOrNull(
      (application) => application.stay?.id == stay.id,
    );
    if (application != null) {
      selectedSeat.value = application.staySeat;
    } else {
      selectedSeat.value = '';
      noSeatReason.text = '';
    }

    updateIsApplied();

    await fetchCurrentStayOutings();
  }

  Future<void> fetchStayApply() async {
    final applications = await stayService.getStayApplication();
    stayApplyList.assignAll(applications);
  }

  Future<void> addStayApplication() async {
    if (selectedSeat.value == '' && noSeatReason.text.isEmpty) {
      DFSnackBar.info("잔류 좌석을 선택해주세요.");
      return;
    }

    try {
      DFSnackBar.info("잔류 신청 중입니다...");
      await stayService.addStayApplication(
        selectedStay.value!.id,
        selectedSeat.value,
        [],
        noSeatReason: noSeatReason.text,
      );
      await fetchStayApply();
      await fetchStayList(selectedStay.value?.id);
      Get.find<HomePageController>().getUserApply();
      DFSnackBar.success("잔류 신청이 완료되었습니다.");
    } on StayNotInApplyPeriodException {
      DFSnackBar.error("해당 잔류 신청 기간이 아닙니다.");
      return;
    } on StayAlreadyAppliedException {
      DFSnackBar.error("이미 잔류 신청을 하였습니다.");
      return;
    } on StaySeatDuplicationException {
      DFSnackBar.error("이미 선택된 좌석입니다.");
      return;
    } on StaySeatNotAllowedException {
      DFSnackBar.error("선택한 좌석은 잔류 신청이 불가능한 좌석입니다. 다른 좌석을 선택해주세요.");
      return;
    } catch (e) {
      DFSnackBar.error("잔류 신청 중 오류가 발생했습니다. 다시 시도해주세요.");
      return;
    } finally {
      await fetchStayApply();
    }
  }

  Future<void> deleteStayApplication() async {
    final currentStayApply = stayApplyList.firstWhereOrNull(
      (application) => application.stay?.id == selectedStay.value!.id,
    );

    if (currentStayApply == null) {
      DFSnackBar.error("잔류 신청 정보를 찾을 수 없습니다.");
      return;
    }

    try {
      DFSnackBar.info("잔류 신청 취소 중입니다...");
      await stayService.deleteStayApplication(currentStayApply.id);
      await fetchStayApply();
      await fetchStayList(selectedStay.value?.id);
      await fetchCurrentStayOutings();
      Get.find<HomePageController>().getUserApply();
      DFSnackBar.success("잔류 신청이 취소되었습니다.");
    } on ResourceNotFoundException {
      DFSnackBar.error("잔류 신청 정보를 찾을 수 없습니다.");
      return;
    } on PermissionDeniedResourceException {
      DFSnackBar.error("잔류 신청 취소 권한이 없습니다.");
      return;
    } on StayNotInApplyPeriodException {
      DFSnackBar.error("해당 잔류 신청 기간이 아닙니다.");
      return;
    } catch (e) {
      DFSnackBar.error("잔류 신청 취소 중 오류가 발생했습니다. 다시 시도해주세요.");
      return;
    } finally {
      await fetchStayApply();
    }
  }

  Future<void> fetchCurrentStayOutings() async {
    final currentStayApply = stayApplyList.firstWhereOrNull(
      (application) => application.stay?.id == selectedStay.value!.id,
    );

    if (currentStayApply == null) {
      currentStayOutings.clear();
      return;
    }

    try {
      final outings = await stayService.getStayOuting(currentStayApply.id);
      currentStayOutings.assignAll(outings);
    } catch (e) {
      currentStayOutings.clear();
      log('Error fetching stay outings: $e');
    }
  }

  Future<void> addStayOuting(Outing outing) async {
    try {
      DFSnackBar.info("외출 신청 중입니다...");

      final currentStayApply = stayApplyList.firstWhereOrNull(
        (element) => element.stay?.id == selectedStay.value!.id,
      );

      if (currentStayApply == null) {
        DFSnackBar.error("잔류 신청 정보를 찾을 수 없습니다.");
        return;
      }

      await stayService.addStayOuting(currentStayApply.id, outing);

      await fetchCurrentStayOutings();
      Get.find<HomePageController>().getUserApply();
      DFSnackBar.success("외출 신청이 완료되었습니다.");
    } on StayNotInApplyPeriodException {
      DFSnackBar.error("해당 잔류 신청 기간이 아닙니다.");
      rethrow;
    } on PermissionDeniedResourceException {
      DFSnackBar.error("외출 신청 권한이 없습니다.");
      rethrow;
    } on ProvidedTimeInvalidException {
      DFSnackBar.error("제공된 외출 시간이 유효하지 않습니다.");
      rethrow;
    } catch (e) {
      DFSnackBar.error("외출 신청 중 오류가 발생했습니다. 다시 시도해주세요.");
      rethrow;
    }
  }

  Future<void> updateStayOuting(Outing outing) async {
    try {
      DFSnackBar.info("외출 수정 중입니다...");

      await stayService.updateStayOuting(outing.id!, outing);

      await fetchCurrentStayOutings();
      Get.find<HomePageController>().getUserApply();
      DFSnackBar.success("외출 수정이 완료되었습니다.");
    } on StayNotInApplyPeriodException {
      DFSnackBar.error("해당 잔류 신청 기간이 아닙니다.");
      rethrow;
    } on PermissionDeniedResourceException {
      DFSnackBar.error("외출 수정 권한이 없습니다.");
      rethrow;
    } on ProvidedTimeInvalidException {
      DFSnackBar.error("제공된 외출 시간이 유효하지 않습니다.");
      rethrow;
    } catch (e) {
      DFSnackBar.error("외출 수정 중 오류가 발생했습니다. 다시 시도해주세요.");
      rethrow;
    }
  }

  Future<void> deleteStayOuting(String outingId) async {
    try {
      DFSnackBar.info("외출 삭제 중입니다...");
      await stayService.deleteStayOuting(outingId);
      await fetchCurrentStayOutings();
      Get.find<HomePageController>().getUserApply();
      DFSnackBar.success("외출 삭제가 완료되었습니다.");
    } on PermissionDeniedResourceException {
      DFSnackBar.error("외출 삭제 권한이 없습니다.");
      rethrow;
    } on StayNotInApplyPeriodException {
      DFSnackBar.error("해당 잔류 신청 기간이 아닙니다.");
      rethrow;
    } catch (e) {
      DFSnackBar.error("외출 삭제 중 오류가 발생했습니다. 다시 시도해주세요.");
      rethrow;
    }
  }
}
