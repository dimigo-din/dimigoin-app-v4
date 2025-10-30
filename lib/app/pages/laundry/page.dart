import 'package:dimigoin_app_v4/app/pages/laundry/laundry_apply/page.dart';
import 'package:dimigoin_app_v4/app/services/laundry/model.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSegmentControl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/static.dart';
import 'controller.dart';

class LaundryPage extends GetView<LaundryPageController> {
  const LaundryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: DFSpacing.spacing400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DFSegmentControl(
              segments: const [
                DFSegment(label: '세탁기'),
                DFSegment(label: '건조기'),
              ],
              initialIndex: controller.selectedIndex.value,
              onChanged: (index) {
                controller.selectedIndex.value = index;
              },
            ),
            Expanded(
              child: Obx(() => IndexedStack(
                index: controller.selectedIndex.value,
                children: [
                  LaundryApplyPage(laundryType: LaundryMachineType.washer,),
                  LaundryApplyPage(laundryType: LaundryMachineType.dryer,),
                ],
              ))
            )
          ],
        ),
      ),
    );
  }
}