import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/services/laundry/model.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFHeader.dart';
import 'package:dimigoin_app_v4/app/widgets/gestureDetector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller.dart';

class LaundryMachineSelector extends StatelessWidget {
  final LaundryMachineType laundryType;
  final VoidCallback onTap;

  const LaundryMachineSelector({
    super.key,
    required this.laundryType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LaundryPageController>();

    return Padding(
      padding: const EdgeInsets.only(left: DFSpacing.spacing100),
      child: Obx(() {
        final machines = controller.laundryMachines
            .where((machine) => machine.type == laundryType)
            .toList();

        final hasMachine = machines.isNotEmpty;
        final selectedIndex = laundryType == LaundryMachineType.washer
            ? controller.selectedWasherIndex.value
            : controller.selectedDryerIndex.value;

        final selectedMachineName = hasMachine && selectedIndex < machines.length
            ? machines[selectedIndex].name
            : "사용 가능 기기 없음";

        return DFGestureDetectorWithOpacityInteraction(
          onTap: hasMachine ? onTap : null,
          child: DFSectionHeader(
            size: DFSectionHeaderSize.large,
            title: selectedMachineName,
            rightIcon: Icons.keyboard_arrow_down_outlined,
            trailingText: "${laundryType == LaundryMachineType.washer ? '세탁기' : '건조기'} 선택",
          ),
        );
      }),
    );
  }
}
