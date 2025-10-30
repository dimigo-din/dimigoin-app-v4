import 'package:dimigoin_app_v4/app/pages/stay/stay_apply/page.dart';
import 'package:dimigoin_app_v4/app/pages/stay/stay_frigo/page.dart';
import 'package:dimigoin_app_v4/app/pages/stay/stay_outing/page.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSegmentControl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/static.dart';
import 'controller.dart';

class StayPage extends GetView<StayPageController> {
  const StayPage({super.key});

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
                DFSegment(label: '잔류'),
                DFSegment(label: '외출'),
                DFSegment(label: '금귀'),
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
                  StayApplyPage(),
                  StayOutingPage(),
                  StayFrigoPage(),
                ],
              ))
            )
          ],
        ),
      ),
    );
  }
}