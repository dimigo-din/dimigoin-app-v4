import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/services/laundry/model.dart';
import 'package:dimigoin_app_v4/app/services/laundry/service.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackbar.dart';
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
      selectedWasherIndex.value = laundryMachines.where((m) => m.type == LaundryMachineType.washer).toList().indexOf(machine);
    } else {
      selectedDryerIndex.value = laundryMachines.where((m) => m.type == LaundryMachineType.dryer).toList().indexOf(machine);
    }
  }

  Future<void> fetchLaundryTimeline() async {
    try {
      final timeline = await laundryService.getLaundryTimeline();

      laundryTimeline.value = timeline;

      await filterLaundryMachines();
      await fetchLaundryApplications();
    } catch (e) {
      print('Error fetching laundry timeline: $e');
    }
  }

  Future<void> filterLaundryMachines() async {
    final user = authService.user!;
    final userGrade = user.userGrade;
    final userGender = user.gender;

    final times = laundryTimeline.value!.times;

    final map = <String, LaundryMachine>{};

    for (final time in times) {
      if (time.grade.contains(userGrade)) {
        for (final machine in time.assigns) {
          if (!map.containsKey(machine.id) && machine.gender == userGender) {
            map[machine.id] = machine;
          }
        }
      }
    }

    laundryMachines.value = map.values.toList();
  }

  Future<void> fetchLaundryApplications() async {
    try {
      final applications = await laundryService.getLaundryApplications();
      laundryApplications.value = applications;
    } catch (e) {
      print('Error fetching laundry applications: $e');
    }
  }

  Future<void> addLaundryApplication(String timeId, String machineId) async {
    try {
      DFSnackBar.info("세탁 신청 중입니다...");
      await laundryService.applyLaundry(timeId, machineId);
      await fetchLaundryApplications();
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
      print('Error adding laundry application: $e');
      rethrow;
    }
  }

  Future<void> removeLaundryApplication(String applyId) async {
    try {
      DFSnackBar.info("세탁 신청 취소 중입니다...");
      await laundryService.deleteLaundryApplication(applyId);
      await fetchLaundryApplications();
      DFSnackBar.success("세탁 신청이 취소되었습니다.");
    } catch (e) {
      DFSnackBar.error("세탁 신청 취소 중 오류가 발생했습니다.");
      print('Error removing laundry application: $e');
      rethrow;
    }
  }

}
