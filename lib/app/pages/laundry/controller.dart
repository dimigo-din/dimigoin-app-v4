import 'dart:developer';

import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/pages/home/controller.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/services/laundry/model.dart';
import 'package:dimigoin_app_v4/app/services/laundry/service.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackBar.dart';
import 'package:get/get.dart';

class LaundryPageController extends GetxController {
  final laundryService = LaundryService();
  final AuthService authService = Get.find<AuthService>();

  final RxInt selectedIndex = 0.obs;
  final RxInt selectedWasherIndex = 0.obs;
  final RxInt selectedDryerIndex = 0.obs;

  final Rx<LaundryTimeline?> laundryTimeline = Rx<LaundryTimeline?>(null);
  final RxList<LaundryApply> laundryApplications = RxList<LaundryApply>([]);
  final RxList<LaundryMachine> laundryMachines = RxList<LaundryMachine>([]);

  @override
  void onInit() async {
    super.onInit();
    await fetchLaundryTimeline();
  }

  void selectLaundryMachine(LaundryMachineType type, LaundryMachine machine) {
    if (type == LaundryMachineType.washer) {
      selectedWasherIndex.value = laundryMachines
          .where((m) => m.type == LaundryMachineType.washer)
          .toList()
          .indexOf(machine);
    } else {
      selectedDryerIndex.value = laundryMachines
          .where((m) => m.type == LaundryMachineType.dryer)
          .toList()
          .indexOf(machine);
    }
  }

  Future<void> fetchLaundryTimeline() async {
    try {
      final timeline = await laundryService.getLaundryTimeline();

      laundryTimeline.value = timeline;

      await filterLaundryMachines();
      await fetchLaundryApplications();
    } catch (e) {
      log('Error fetching laundry timeline: $e');
    }
  }

  Future<void> filterLaundryMachines() async {
    final user = authService.user!;
    final userGrade = user.userGrade;
    final userGender = _normalizeGender(user.gender);

    final times = laundryTimeline.value!.times;

    final map = <String, LaundryMachine>{};

    for (final time in times) {
      if (time.grade.contains(userGrade)) {
        for (final machine in time.assigns) {
          final machineGender = _normalizeGender(machine.gender);
          if (!map.containsKey(machine.id) && machineGender == userGender) {
            map[machine.id] = machine;
          }
        }
      }
    }

    laundryMachines.value = map.values.toList();
  }

  String _normalizeGender(String gender) {
    final normalized = gender.trim().toLowerCase();

    switch (normalized) {
      case 'm':
      case 'male':
      case 'man':
      case '남':
      case '남자':
        return 'male';
      case 'f':
      case 'female':
      case 'woman':
      case '여':
      case '여자':
        return 'female';
      default:
        return normalized;
    }
  }

  Future<void> fetchLaundryApplications() async {
    try {
      final applications = await laundryService.getLaundryApplications();
      laundryApplications.value = applications;
    } catch (e) {
      log('Error fetching laundry applications: $e');
    }
  }

  Future<void> addLaundryApplication(String timeId, String machineId) async {
    try {
      DFSnackBar.info("세탁 신청 중입니다...");
      await laundryService.applyLaundry(timeId, machineId);
      await fetchLaundryApplications();
      Get.find<HomePageController>().getUserApply();
      DFSnackBar.success("세탁 신청이 완료되었습니다.");
    } on LaundryApplyIsAfterEightAMException {
      DFSnackBar.error("세탁 신청은 오전 8시 이후에만 가능합니다.");
      rethrow;
    } on LaundryApplyAlreadyExistsException {
      DFSnackBar.error("이미 세탁을 신청하셨습니다.");
      rethrow;
    } on PermissionDeniedResourceGradeException {
      DFSnackBar.error("리소스 접근 권한이 없습니다.");
      rethrow;
    } on LaundryMachineAlreadyTakenException {
      DFSnackBar.error("선택한 세탁기가 이미 사용 중입니다.");
      rethrow;
    } catch (e) {
      DFSnackBar.error("세탁 신청 중 오류가 발생했습니다.");
      log('Error adding laundry application: $e');
      rethrow;
    }
  }

  Future<void> removeLaundryApplication(String applyId) async {
    try {
      DFSnackBar.info("세탁 신청 취소 중입니다...");
      await laundryService.deleteLaundryApplication(applyId);
      await fetchLaundryApplications();
      Get.find<HomePageController>().getUserApply();
      DFSnackBar.success("세탁 신청이 취소되었습니다.");
    } catch (e) {
      DFSnackBar.error("세탁 신청 취소 중 오류가 발생했습니다.");
      log('Error removing laundry application: $e');
      rethrow;
    }
  }
}
