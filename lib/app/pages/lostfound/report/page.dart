import 'dart:io';

import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/widgets/appBar.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFButton.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFInputField.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'controller.dart';

class LostfoundReportPage extends GetView<LostfoundReportPageController> {
  const LostfoundReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return Container(
      decoration: BoxDecoration(color: colorTheme.backgroundStandardSecondary),
      child: SafeArea(
        top: false,
        child: GetBuilder<LostfoundReportPageController>(
          builder: (controller) {
            return Scaffold(
              appBar: const DFAppBar(title: '분실물 등록'),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(
                  DFSpacing.spacing400,
                  DFSpacing.spacing300,
                  DFSpacing.spacing400,
                  DFSpacing.spacing500,
                ),
                child: Column(
                  children: [
                    Text(
                      '잃어버린 물건을 제보해주세요. 물건을 주웠다면 해당 제보에 댓글로 알려주세요.',
                      style: Theme.of(context)
                          .extension<DFTypography>()!
                          .footnote
                          .copyWith(color: colorTheme.contentStandardTertiary),
                    ),
                    const SizedBox(height: DFSpacing.spacing500),
                    Expanded(
                      child: SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            _ImagePickerField(
                              images: controller.images,
                              onPick: controller.pickImages,
                              onClear: controller.clearImages,
                            ),
                            const SizedBox(height: DFSpacing.spacing500),
                            _MultilineInput(
                              title: '상세 내용',
                              controller: controller.bodyTEC,
                              placeholder: '물건의 특징이나 상황을 자세히 적어주세요.',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: DFButton(
                        label: controller.isSubmitting ? '등록 중...' : '등록하기',
                        size: DFButtonSize.large,
                        onPressed: controller.isSubmitting
                            ? null
                            : controller.submit,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MultilineInput extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String placeholder;

  const _MultilineInput({
    required this.title,
    required this.controller,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: DFSpacing.spacing200,
            left: DFSpacing.spacing100,
          ),
          child: Text(
            title,
            style: textTheme.footnote.copyWith(
              color: colorTheme.contentStandardSecondary,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(DFSpacing.spacing300),
          decoration: BoxDecoration(
            color: colorTheme.backgroundStandardPrimary,
            borderRadius: BorderRadius.circular(DFRadius.radius300),
          ),
          child: TextField(
            controller: controller,
            maxLines: 5,
            style: textTheme.body.copyWith(
              color: colorTheme.contentStandardPrimary,
            ),
            decoration: InputDecoration.collapsed(
              hintText: placeholder,
              hintStyle: textTheme.body.copyWith(
                color: colorTheme.contentStandardTertiary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ImagePickerField extends StatelessWidget {
  final List<XFile> images;
  final VoidCallback onPick;
  final VoidCallback onClear;

  const _ImagePickerField({
    required this.images,
    required this.onPick,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: DFSpacing.spacing100),
              child: Text(
                '사진 (최대 5장)',
                style: textTheme.footnote.copyWith(
                  color: colorTheme.contentStandardSecondary,
                ),
              ),
            ),
            Row(
              children: [
                DFButton(
                  label: '사진 선택',
                  size: DFButtonSize.small,
                  theme: DFButtonTheme.grayscale,
                  style: DFButtonStyle.secondary,
                  onPressed: onPick,
                ),
                if (images.isNotEmpty) ...[
                  const SizedBox(width: DFSpacing.spacing200),
                  DFButton(
                    label: '삭제',
                    size: DFButtonSize.small,
                    theme: DFButtonTheme.negative,
                    style: DFButtonStyle.secondary,
                    onPressed: onClear,
                  ),
                ],
              ],
            ),
          ],
        ),
        if (images.isNotEmpty) ...[
          const SizedBox(height: DFSpacing.spacing300),
          SizedBox(
            height: 88,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: DFSpacing.spacing200),
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(DFRadius.radius300),
                // 웹에서는 Image.file 을 쓸 수 없고, 선택한 사진의 path 가 blob URL 입니다.
                child: kIsWeb
                    ? Image.network(
                        images[index].path,
                        width: 88,
                        height: 88,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(images[index].path),
                        width: 88,
                        height: 88,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
