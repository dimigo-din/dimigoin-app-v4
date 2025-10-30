import 'package:dimigoin_app_v4/app/services/laundry/model.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFAnimatedBottomSheet.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFList.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller.dart';

class MachineSelectionBottomSheet {
  static void show({
    required BuildContext context,
    required LaundryMachineType laundryType,
  }) {
    final controller = Get.find<LaundryPageController>();

    DFAnimatedBottomSheet.show(
      context: context,
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 24,
      ),
      children: [
        ...controller.laundryMachines
            .where((machine) => machine.type == laundryType)
            .map((machine) {
          final machines = controller.laundryMachines
              .where((m) => m.type == laundryType)
              .toList();

          final selectedIndex = laundryType == LaundryMachineType.washer
              ? controller.selectedWasherIndex.value
              : controller.selectedDryerIndex.value;

          final isSelected = machines.isNotEmpty &&
              selectedIndex < machines.length &&
              machine == machines[selectedIndex];

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () {
                controller.selectLaundryMachine(laundryType, machine);
                Navigator.pop(context);
              },
              child: DFValueList(
                type: DFValueListType.horizontal,
                theme: isSelected
                    ? DFValueListTheme.active
                    : DFValueListTheme.outlined,
                title: machine.name,
                content: machine.type == LaundryMachineType.washer
                    ? "세탁기"
                    : "건조기",
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
