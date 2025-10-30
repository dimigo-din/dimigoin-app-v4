import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/services/frigo/model.dart';
import 'package:dimigoin_app_v4/app/services/frigo/service.dart';
import 'package:dimigoin_app_v4/app/services/stay/model.dart';
import 'package:dimigoin_app_v4/app/services/stay/service.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

List<String> frigoTiming = [
  "afterschool",
  "dinner",
  "after_1st_study",
  "after_2nd_study",
];

class StayPageController extends GetxController {
  final stayService = StayService();
  final frigoService = FrigoService();

  final RxInt selectedIndex = 0.obs;

  final RxList<Stay> stayList = <Stay>[].obs;
  final RxInt selectedStayIndex = 0.obs;
  final Rx<Stay?> selectedStay = Rx<Stay?>(null);

  final RxList<StayApply> stayApplyList = <StayApply>[].obs;
  
  final RxList<Outing> currentStayOutings = <Outing>[].obs;
  final RxInt selectedStayOutingDay = 0.obs;

  final RxString selectedSeat = ''.obs;
  final RxString noSeatReason = ''.obs;

  final Rx<TimeOfDay?> outingFrom = Rxn<TimeOfDay>();
  final Rx<TimeOfDay?> outingTo = Rxn<TimeOfDay>();
  final outingReasonTEC = TextEditingController();
  final RxBool breakfastCancel = false.obs;
  final RxBool lunchCancel = false.obs;
  final RxBool dinnerCancel = false.obs;

  final Rx<Frigo?> frigoApplication = Rx<Frigo?>(null);
  final RxInt selectedFrigoTimingIndex = 0.obs;
  final RxString frigoReason = ''.obs;

  void resetOutingForm() {
    outingFrom.value = null;
    outingTo.value = null;
    outingReasonTEC.text = '';
    breakfastCancel.value = false;
    lunchCancel.value = false;
    dinnerCancel.value = false;
  }

  void initOutingForm(Outing o) {
    outingFrom.value = o.from != null ? TimeOfDay.fromDateTime(DateTime.parse(o.from!)) : null;
    outingTo.value = o.to != null ? TimeOfDay.fromDateTime(DateTime.parse(o.to!)) : null;
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

  Future<void> fetchStayList() async {
    final stays = await stayService.getStay();
    selectedStayIndex.value = 0;
    stayList.assignAll(stays);

    if(stayList.isNotEmpty) {
      selectStay(stayList[0]);
    }
  }

  void selectStay(Stay stay) async {
    selectedStayIndex.value = stayList.indexOf(stay);
    selectedStay.value = stay;
    
    selectedStayOutingDay.value = 0;

    final application = stayApplyList.firstWhereOrNull((application) => application.stay?.id == stay.id);
    if (application != null) {
      selectedSeat.value = application.staySeat;
    } else {
      selectedSeat.value = '';
      noSeatReason.value = '';
    }

    await fetchCurrentStayOutings();
  }

  Future<void> fetchStayApply() async {
    final applications = await stayService.getStayApplication();
    stayApplyList.assignAll(applications);
  }

  Future<void> addStayApplication() async {
    if(selectedSeat.value == '' && noSeatReason.value.isEmpty) {
      DFSnackBar.info("잔류 좌석을 선택해주세요.");
      return;
    }

    try {
      DFSnackBar.info("잔류 신청 중입니다...");
      await stayService.addStayApplication(
        selectedStay.value!.id,
        selectedSeat.value,
        [],
        noSeatReason: noSeatReason.value,
      );
      await fetchStayApply();
      await fetchStayList();
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
      (application) => application.stay?.id == selectedStay.value!.id
    );

    if(currentStayApply == null) {
      DFSnackBar.error("잔류 신청 정보를 찾을 수 없습니다.");
      return;
    }

    try {
      DFSnackBar.info("잔류 신청 취소 중입니다...");
      await stayService.deleteStayApplication(currentStayApply.id);
      await fetchCurrentStayOutings();
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
      (application) => application.stay?.id == selectedStay.value!.id
    );

    if(currentStayApply == null) {
      currentStayOutings.clear();
      return;
    }

    try {
      final outings = await stayService.getStayOuting(currentStayApply.id);
      currentStayOutings.assignAll(outings);
    } catch (e) {
      currentStayOutings.clear();
      print('Error fetching stay outings: $e');
    }
  }

  Future<void> addStayOuting(Outing outing) async {
    try {
      DFSnackBar.info("외출 신청 중입니다...");
      
      final currentStayApply = stayApplyList.firstWhereOrNull((element) => element.stay?.id == selectedStay.value!.id);
      
      if (currentStayApply == null) {
        DFSnackBar.error("잔류 신청 정보를 찾을 수 없습니다.");
        return;
      }

      await stayService.addStayOuting(currentStayApply.id, outing);

      await fetchCurrentStayOutings();
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

  Future<void> fetchFrigoApplication() async {
    try {
      final application = await frigoService.getFrigoApplication();
      frigoApplication.value = application;
      frigoReason.value = application.reason;
      selectedFrigoTimingIndex.value = frigoTiming.indexOf(application.timing.toString());
    } catch (e) {
      frigoApplication.value = null;
      print('Error fetching frigo application: $e');
      return;
    }
  }

  Future<void> addFrigoApplication() async {
    try {
      if (frigoReason.value.isEmpty) {
        DFSnackBar.error("금요귀가 신청 사유를 입력해주세요.");
        return;
      }

      DFSnackBar.info("금요귀가 신청 중입니다...");
      await frigoService.addFrigoApplication(
        frigoTiming[selectedFrigoTimingIndex.value],
        frigoReason.value,
      );
      await fetchFrigoApplication();
      DFSnackBar.success("금요귀가 신청이 완료되었습니다.");
    } on FrigoPeriodNotExistsForGradeException {
      DFSnackBar.error("해당 학년은 금요귀가 신청이 불가능합니다. 담임 선생님께 문의주세요.");
      return;
    } on FrigoPeriodNotInApplyPeriodException {
      DFSnackBar.error("금요귀가 신청 기간이 아닙니다.");
      return;
    } on FrigoAlreadyAppliedException {
      DFSnackBar.error("이미 금요귀가 신청을 하였습니다.");
      return;
    } catch (e) {
      DFSnackBar.error("금요귀가 신청 중 오류가 발생했습니다. 다시 시도해주세요.");
      return;
    }
  }

  Future<void> deleteFrigoApplication() async {
    try {
      DFSnackBar.info("금요귀가 신청 취소 중입니다...");
      await frigoService.deleteFrigoApplication();
      await fetchFrigoApplication();
      DFSnackBar.success("금요귀가 신청이 취소되었습니다.");
    } on FrigoPeriodNotInApplyPeriodException {
      DFSnackBar.error("금요귀가 신청 취소 기간이 아닙니다.");
      return;
    } catch (e) {
      DFSnackBar.error("금요귀가 신청 취소 중 오류가 발생했습니다. 다시 시도해주세요.");
      return;
    }
  }
}
