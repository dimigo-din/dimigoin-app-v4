import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/pages/lostfound/widgets/report_image_picker.dart';
import 'package:dimigoin_app_v4/app/pages/lostfound/widgets/report_multiline_input.dart';
import 'package:dimigoin_app_v4/app/widgets/appBar.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFButton.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFInputField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class LostfoundReportPage extends GetView<LostfoundReportPageController> {
  LostfoundReportPage({super.key});

  final String title = Get.arguments?['title'] ?? '분실물 등록';

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return Container(
      decoration: BoxDecoration(color: colorTheme.backgroundStandardSecondary),
      child: SafeArea(
        top: false,
        child: Obx(() {
          return Scaffold(
            appBar: DFAppBar(title: title),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(
                DFSpacing.spacing400,
                DFSpacing.spacing300,
                DFSpacing.spacing400,
                DFSpacing.spacing500,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        children: [
                          DFInputField(
                            title: '물건',
                            inputs: [
                              DFInput(
                                controller: controller.objectNameTEC,
                                placeholder: '예: 검정 무선 이어폰',
                              ),
                            ],
                          ),
                          const SizedBox(height: DFSpacing.spacing500),
                          DFInputField(
                            title: '마지막으로 본 장소',
                            inputs: [
                              DFInput(
                                controller: controller.lastSeenPlaceTEC,
                                placeholder: '예: 우정학사 2층 세탁실',
                              ),
                            ],
                          ),
                          const SizedBox(height: DFSpacing.spacing500),
                          Obx(
                            () => ReportImagePickerField(
                              images: controller.images.toList(growable: false),
                              onPick: controller.pickImages,
                              onClear: controller.clearImages,
                            ),
                          ),
                          const SizedBox(height: DFSpacing.spacing500),
                          DFInputField(
                            title: '상세 내용',
                            inputs: [
                              ReportMultilineInput(
                                controller: controller.bodyTEC,
                                placeholder: '물건의 특징이나 상황을 자세히 적어주세요.',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DFButton(
                      label: controller.isSubmitting.value ? '등록 중...' : '등록하기',
                      size: DFButtonSize.large,
                      disabled: controller.isSubmitting.value,
                      onPressed: controller.isSubmitting.value
                          ? null
                          : controller.submit,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
