import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/static.dart';
import 'controller.dart';

import '../../widgets/animated_cross_fade.dart';
import '../../widgets/personal_status.dart';
import '../../widgets/shimmer_loading_box.dart';
import '../../widgets/timetable.dart';

import 'package:dimigoin_app_v4/app/services/user/state.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

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
              const SizedBox(height: 10),
              Obx(
                () => DFAnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  firstChild: (_) => const DFShimmerLoadingBox(
                    height: 394,
                    borderRadius: DFRadius.radius800,
                  ),
                  secondChild: (_) => TimeTableWidget(
                    timetable:
                        (controller.userService.timelineState
                                as UserTimelineSuccess)
                            .timetable,
                  ),
                  crossFadeState:
                      controller.userService.timelineState
                          is! UserTimelineSuccess
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
