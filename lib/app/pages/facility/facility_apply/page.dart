import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/pages/facility/controller.dart';
import 'package:dimigoin_app_v4/app/services/facility/model.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFButton.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFInputField.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFOptionPicker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/facility_image_picker_field.dart';
import 'widgets/facility_multiline_input.dart';

class FacilityApplyPage extends GetView<FacilityPageController> {
  const FacilityApplyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: DFSpacing.spacing500),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: [
                    DFInputField(
                      title: '제목',
                      inputs: [
                        DFInput(
                          controller: controller.titleTEC,
                          placeholder: '예: 변기(학봉관 2층 2번째 칸)',
                        ),
                      ],
                    ),
                    const SizedBox(height: DFSpacing.spacing500),
                    Obx(
                      () => FacilityImagePickerField(
                        images: controller.images.toList(growable: false),
                        onPick: controller.pickImages,
                        onClear: controller.clearImages,
                      ),
                    ),
                    const SizedBox(height: DFSpacing.spacing500),
                    DFInputField(
                      title: '문의 내용',
                      inputs: [
                        FacilityMultilineInput(
                          controller: controller.bodyTEC,
                          placeholder: '수리 요청 내용을 입력하세요.',
                        ),
                      ],
                    ),
                    const SizedBox(height: DFSpacing.spacing500),
                    DFInputField(
                      title: '처리 방안',
                      inputs: [
                        Obx(
                          () => DFOptionPicker(
                            type: DFOptionPickerType.sextuple,
                            currentIndex:
                                controller.selectedReportType.value.index,
                            options: const [
                              DFOptionData(label: '제안'),
                              DFOptionData(label: '파손'),
                              DFOptionData(label: '위험'),
                            ],
                            onChanged: (index) {
                              controller.selectedReportType.value =
                                  FacilityReportType.values[index];
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: DFSpacing.spacing300),
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => DFButton(
                  label: controller.isSubmitting.value ? '신청 중...' : '신청하기',
                  size: DFButtonSize.large,
                  theme: DFButtonTheme.accent,
                  style: DFButtonStyle.primary,
                  disabled: controller.isSubmitting.value,
                  onPressed: controller.addReport,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
