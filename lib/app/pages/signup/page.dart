import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFButton.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFHeader.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFInputField.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFOptionPicker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class SignupPage extends GetView<SignupPageController> {
  SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: colorTheme.backgroundStandardSecondary,
      ),
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DFSpacing.spacing550,
                vertical: DFSpacing.spacing400,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/dimigoin_icon.png', height: 35),
                ],
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: DFSpacing.spacing400, vertical: DFSpacing.spacing500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      DFHeader(
                        title: "본인의 학년, 반을 입력해주세요",
                        content: "해당 정보는 변경이 불가합니다. 정확히 입력해주세요.",
                      ),
                      const SizedBox(height: DFSpacing.spacing600),
                      DFInputField(
                        title: "학년 선택",
                        inputs: [
                          DFOptionPicker(
                            type: DFOptionPickerType.sextuple,
                            currentIndex: controller.selectedGrade.value,
                            options: [
                              DFOptionData(label: "1학년"),
                              DFOptionData(label: "2학년"),
                              DFOptionData(label: "3학년"),
                            ],
                            onChanged: (index) {
                              controller.selectedGrade.value = index;
                              controller.checkCanSubmit();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: DFSpacing.spacing600),
                      DFInputField(
                        title: "반 선택",
                        inputs: [
                          DFOptionPicker(
                            type: DFOptionPickerType.sextuple,
                            currentIndex: controller.selectedClass.value,
                            options: [
                              DFOptionData(label: "1반"),
                              DFOptionData(label: "2반"),
                              DFOptionData(label: "3반"),
                              DFOptionData(label: "4반"),
                              DFOptionData(label: "5반"),
                              DFOptionData(label: "6반"),
                            ],
                            onChanged: (index) {
                              controller.selectedClass.value = index;
                              controller.checkCanSubmit();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: DFSpacing.spacing600),
                      DFInputField(
                        title: "성별 선택",
                        inputs: [
                          DFOptionPicker(
                            type: DFOptionPickerType.doubleHorizontal,
                            currentIndex: controller.selectedGender.value,
                            options: [
                              DFOptionData(label: "남"),
                              DFOptionData(label: "여"),
                            ],
                            onChanged: (index) {
                              controller.selectedGender.value = index;
                              controller.checkCanSubmit();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Obx(() => SizedBox(
                  width: double.infinity,
                  child: DFButton(
                    label: "입력 완료",
                    size: DFButtonSize.large,
                    theme: DFButtonTheme.accent,
                    style: DFButtonStyle.primary,
                    disabled: !controller.canSubmit.value,
                    onPressed: () => controller.submitPersonalInfo(),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
