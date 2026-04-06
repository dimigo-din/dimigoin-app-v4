import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/services/laundry/model.dart';
import 'package:dimigoin_app_v4/app/services/laundry/state.dart';
import 'package:dimigoin_app_v4/app/widgets/animated_cross_fade.dart';
import 'package:dimigoin_app_v4/app/widgets/shimmer_loading_box.dart';
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
            Obx(() => DFAnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              firstChild: (_) => const DFShimmerLoadingBox(height: 32),
              secondChild: (_) => LaundryMachineSelector(
                laundryType: laundryType,
                onTap: () => MachineSelectionBottomSheet.show(
                  context: context,
                  laundryType: laundryType,
                ),
              ),
              crossFadeState: controller.laundryService.laundryTimelineState is! LaundryTimelineSuccess
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            )),
            const SizedBox(height: 16),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchLaundryApplications();
                },
                child: Obx(() {
                  final selectedIndex = laundryType == LaundryMachineType.washer
                      ? controller.selectedWasherIndex.value
                      : controller.selectedDryerIndex.value;

                  return DFAnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    firstChild: (_) => Column(
                      children: List.generate(
                        3,
                        (index) => const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: DFShimmerLoadingBox(height: 58),
                        ),
                      ),
                    ),
                    secondChild: (_) => ListView(
                      key: ValueKey('laundry-time-slots-${laundryType.name}-$selectedIndex'),
                      children: _buildTimeSlotList(
                        (controller.laundryService.laundryTimelineState as LaundryTimelineSuccess).timeline,
                        (controller.laundryService.laundryApplyState as LaundryApplySuccess).applications,
                      ),
                    ),
                    crossFadeState:
                        controller.laundryService.laundryTimelineState is! LaundryTimelineSuccess ||
                        controller.laundryService.laundryApplyState is! LaundryApplySuccess
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTimeSlotList(
    LaundryTimeline timeline,
    List<LaundryApply> applications,
  ) {
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

    final matchedTimes =
        timeline.times
            .where((t) => (t.assigns).any((m) => m.id == selectedMachine.id))
            .toList()
          ..sort((a, b) => (a.time).compareTo(b.time));

    final currentUserId = controller.authService.user?.id;

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
