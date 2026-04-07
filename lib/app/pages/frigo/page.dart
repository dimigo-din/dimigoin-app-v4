import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/services/frigo/state.dart';
import 'package:dimigoin_app_v4/app/widgets/animated_cross_fade.dart';
import 'package:dimigoin_app_v4/app/widgets/appBar.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFInputField.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFOptionPicker.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFButton.dart';
import 'package:dimigoin_app_v4/app/widgets/shimmer_loading_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class FrigoPage extends GetView<FrigoController> {
  const FrigoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Container(
      decoration: BoxDecoration(color: colorTheme.backgroundStandardSecondary),
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: DFAppBar(title: '금요귀가'),
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DFSpacing.spacing400,
              vertical: DFSpacing.spacing500,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      DFInputField(
                        title: "금요귀가 신청 사유",
                        inputs: [
                          Obx(() => DFAnimatedCrossFade(
                            duration: const Duration(milliseconds: 300),
                            firstChild: (_) => const DFShimmerLoadingBox(
                              height: 50,
                            ),
                            secondChild: (_) => DFInput(
                              controller: controller.frigoReasonTEC,
                              placeholder: "금요귀가 신청 사유를 입력하세요",
                              type: DFInputType.normal,
                            ),
                            crossFadeState: controller.frigoService.frigoState is! FrigoSuccess
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                          ))
                        ],
                      ),
                      const SizedBox(height: DFSpacing.spacing600),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: DFSpacing.spacing200,
                          left: DFSpacing.spacing100,
                          right: DFSpacing.spacing100,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "귀가 시간 선택",
                            style: textTheme.callout.copyWith(
                              color: colorTheme.contentStandardSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => DFAnimatedCrossFade(
                          duration: const Duration(milliseconds: 300),
                          firstChild: (_) => const DFShimmerLoadingBox(
                            height: 120,
                          ),
                          secondChild: (_) => Obx(
                            () => DFOptionPicker(
                              type: DFOptionPickerType.quadruple,
                              currentIndex:
                                  controller.selectedFrigoTimingIndex.value,
                              options: const [
                                DFOptionData(label: "종례 후"),
                                DFOptionData(label: "저녁시간"),
                                DFOptionData(label: "야자 1타임 후"),
                                DFOptionData(label: "야자 2타임 후"),
                              ],
                              onChanged: (index) {
                                if (controller.isApplied.value) return;

                                controller.selectedFrigoTimingIndex.value = index;
                              },
                            ),
                          ),
                          crossFadeState: controller.frigoService.frigoState is! FrigoSuccess
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                        )
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => DFAnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      firstChild: (_) => const DFShimmerLoadingBox(
                        height: 56,
                      ),
                      secondChild: (_) => SizedBox(
                        width: double.infinity,
                        child: Obx(
                          () => DFButton(
                            label: controller.isApplied.value
                                ? "금요귀가 신청 취소"
                                : "금요귀가 신청",
                            size: DFButtonSize.large,
                            theme: DFButtonTheme.accent,
                            style: controller.isApplied.value
                                ? DFButtonStyle.secondary
                                : DFButtonStyle.primary,
                            onPressed: () {
                              if (controller.isApplied.value) {
                                controller.deleteFrigoApplication();
                              } else {
                                controller.addFrigoApplication();
                              }
                            },
                          ),
                        ),
                      ),
                      crossFadeState: controller.frigoService.frigoState is! FrigoSuccess
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
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
