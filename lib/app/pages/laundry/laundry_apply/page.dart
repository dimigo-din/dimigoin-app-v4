import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/services/laundry/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller.dart';
import 'widgets/laundry_machine_selector.dart';
import 'widgets/laundry_time_slot_card.dart';
import 'widgets/laundry_cancel_dialog.dart';
import 'widgets/machine_selection_bottom_sheet.dart';

class LaundryApplyPage extends GetView<LaundryPageController> {
  final LaundryMachineType laundryType;

  const LaundryApplyPage({super.key, required this.laundryType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: DFSpacing.spacing500),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LaundryMachineSelector(
              laundryType: laundryType,
              onTap: () => MachineSelectionBottomSheet.show(
                context: context,
                laundryType: laundryType,
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                child: Obx(() => Column(
                  children: _buildTimeSlotList(),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTimeSlotList() {
    final machines = controller.laundryMachines
        .where((m) => m.type == laundryType)
        .toList();

    if (machines.isEmpty) {
      return [const Center(child: Text("시간 정보 없음"))];
    }

    final selectedIndex = laundryType == LaundryMachineType.washer
        ? controller.selectedWasherIndex.value
        : controller.selectedDryerIndex.value;

    final selectedMachine = machines[selectedIndex];

    final matchedTimes = controller.laundryTimeline.value!.times
        .where((t) => (t.assigns).any((m) => m.id == selectedMachine.id))
        .toList()
      ..sort((a, b) => (a.time).compareTo(b.time));

    final currentUserId = controller.authService.user?.id;
    final applications = controller.laundryApplications;

    return matchedTimes.map((time) {
      final apply = applications.firstWhereOrNull(
        (app) =>
            app.laundryTime.time == time.time &&
            app.laundryMachine.id == selectedMachine.id,
      );

      final isMine = apply?.user?.id == currentUserId;

      return LaundryTimeSlotCard(
        time: time,
        application: apply,
        isMine: isMine,
        onTap: () => _handleTimeSlotTap(apply, isMine, time, selectedMachine),
      );
    }).toList();
  }

  Future<void> _handleTimeSlotTap(
    LaundryApply? apply,
    bool isMine,
    LaundryTime time,
    LaundryMachine selectedMachine,
  ) async {
    if (isMine) {
      final shouldCancel = await LaundryCancelDialog.show(Get.context!);
      if (shouldCancel == false || shouldCancel == null) {
        return;
      }
      controller.removeLaundryApplication(apply!.id);
      return;
    } else if (apply?.user != null) {
      return;
    }

    controller.addLaundryApplication(time.id, selectedMachine.id);
  }
}
