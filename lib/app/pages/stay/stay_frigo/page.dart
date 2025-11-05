import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFInputField.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFOptionPicker.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller.dart';

class StayFrigoPage extends GetView<StayPageController> {
  const StayFrigoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: DFSpacing.spacing500),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Obx(() => DFInputField(
                    title: "금요귀가 신청 사유",
                    inputs: [
                      DFInput(
                        placeholder: "금요귀가 신청 사유를 입력하세요",
                        content: controller.frigoReason.value,
                        type: DFInputType.normal,
                        onChanged: (value) {
                          controller.frigoReason.value = value;
                        },
                      )
                    ]
                  )),
                  const SizedBox(height: DFSpacing.spacing600),
                  Padding(
                    padding: const EdgeInsets.only(bottom: DFSpacing.spacing200, left: DFSpacing.spacing100, right: DFSpacing.spacing100),
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
                  Obx(() => DFOptionPicker(
                    type: DFOptionPickerType.quadruple,
                    initialIndex: controller.selectedFrigoTimingIndex.value,
                    options: const [
                      DFOption(label: "종례 후"),
                      DFOption(label: "저녁시간"),
                      DFOption(label: "야자 1타임 후"),
                      DFOption(label: "야자 2타임 후"),
                    ],
                  )),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: DFButton(
                label: controller.frigoApplication.value != null ? "금요귀가 신청 취소" : "금요귀가 신청",
                size: DFButtonSize.large,
                theme: DFButtonTheme.accent,
                style: controller.frigoApplication.value != null ? DFButtonStyle.secondary : DFButtonStyle.primary,
                onPressed: () {
                  if (controller.frigoApplication.value != null) {
                    controller.deleteFrigoApplication();
                  } else {
                    controller.addFrigoApplication();
                  }
                },
              ),
            ),
          ],
        )
      )
    );
  }
}