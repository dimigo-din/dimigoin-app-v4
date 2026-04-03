import 'package:dimigoin_app_v4/app/services/user/state.dart';
import 'package:dimigoin_app_v4/app/widgets/animated_cross_fade.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFHeader.dart';
import 'package:dimigoin_app_v4/app/widgets/shimmer_loading_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/static.dart';
import 'controller.dart';

import '../../widgets/personal_status.dart';
import './widgets/page_button.dart';

class DormPage extends GetView<DormPageController> {
  const DormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: DFSpacing.spacing400),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Obx(
                () => DFAnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  firstChild: (_) => const DFShimmerLoadingBox(
                    height: 104,
                    borderRadius: DFRadius.radius800,
                  ),
                  secondChild: (_) => PersonalStatusWidget(
                    userApply:
                        (controller.userService.userApplyState
                                as UserApplySuccess)
                            .userApply,
                  ),
                  crossFadeState:
                      controller.userService.userApplyState is! UserApplySuccess
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),
              ),
              const SizedBox(height: DFSpacing.spacing700),
              const DFHeader(title: "신청하기"),
              const SizedBox(height: DFSpacing.spacing300),
              Row(
                children: [
                  Expanded(
                    child: PageButtonWidget(
                      icon: Icons.school_outlined,
                      title: "잔류",
                      onTap: () => controller.openStayPage(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PageButtonWidget(
                      icon: Icons.home_work_outlined,
                      title: "금귀",
                      onTap: () => controller.openFrigoPage(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: PageButtonWidget(
                      icon: Icons.local_laundry_service_outlined,
                      title: "세탁",
                      onTap: () => controller.openLaundryPage(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PageButtonWidget(
                      icon: Icons.music_note_outlined,
                      title: "기상곡",
                      onTap: () => controller.openWakeupPage(),
                    ),
                  ),
                ],
              ),
              // TimeTableWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
