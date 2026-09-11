import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/pages/facility/facility_apply/page.dart';
import 'package:dimigoin_app_v4/app/pages/facility/facility_list/page.dart';
import 'package:dimigoin_app_v4/app/widgets/appBar.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSegmentControl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class FacilityPage extends GetView<FacilityPageController> {
  const FacilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return Container(
      decoration: BoxDecoration(color: colorTheme.backgroundStandardSecondary),
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: const DFAppBar(title: '수리 신청'),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DFSpacing.spacing400,
            ),
            child: Column(
              children: [
                DFSegmentControl(
                  initialIndex: controller.selectedIndex.value,
                  segments: const [
                    DFSegment(label: '신청'),
                    DFSegment(label: '목록'),
                  ],
                  onChanged: (index) {
                    controller.selectedIndex.value = index;
                  },
                ),
                Expanded(
                  child: Obx(
                    () => IndexedStack(
                      index: controller.selectedIndex.value,
                      children: const [FacilityApplyPage(), FacilityListPage()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
