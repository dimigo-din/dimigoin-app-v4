import 'package:dimigoin_app_v4/app/pages/wakeup/wakeup_apply/page.dart';
import 'package:dimigoin_app_v4/app/pages/wakeup/wakeup_vote/page.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSegmentControl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/static.dart';
import 'controller.dart';

class WakeupPage extends GetView<WakeupPageController> {
  const WakeupPage({super.key});

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
                DFSegment(label: '투표'),
                DFSegment(label: '신청'),
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
                  WakeupVotePage(),
                  WakeupApplyPage(),
                ],
              ))
            )
          ],
        ),
      ),
    );
  }
}