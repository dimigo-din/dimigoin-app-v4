import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/services/stay/model.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFAnimatedBottomSheet.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFInputField.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFOptionPicker.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackBar.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFButton.dart';
import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../controller.dart';

class OutingFormBottomSheet extends StatelessWidget {
  final bool isEditing;
  final Outing? outing;
  final DateTime selectedDate;

  const OutingFormBottomSheet({
    super.key,
    required this.isEditing,
    this.outing,
    required this.selectedDate,
  });

  static void show({
    required BuildContext context,
    required bool isEditing,
    Outing? outing,
    required DateTime selectedDate,
  }) {
    final controller = Get.find<StayPageController>();

    if (isEditing && outing != null) {
      controller.initOutingForm(outing);
    } else {
      controller.resetOutingForm();
    }

    DFAnimatedBottomSheet.show(
      context: context,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
      children: OutingFormBottomSheet(
        isEditing: isEditing,
        outing: outing,
        selectedDate: selectedDate,
      )._buildChildren(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildChildren(context),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    final controller = Get.find<StayPageController>();
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return [
      // 신청 시간
      Obx(() => DFInputField(
        title: "신청 시간",
        inputs: [
          Row(
            children: [
              Expanded(
                child: DFInput(
                  key: ValueKey(controller.outingFrom.value.toString()),
                  initialTime: controller.outingFrom.value,
                  placeholder: "시작 시간",
                  type: DFInputType.normal,
                  mode: DFInputMode.time,
                  onTimeChanged: (t) => controller.outingFrom.value = t,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: DFSpacing.spacing400),
                child: Text(
                  "~",
                  style: textTheme.headline.copyWith(
                    color: colorTheme.contentStandardSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: DFInput(
                  key: ValueKey(controller.outingTo.value.toString()),
                  initialTime: controller.outingTo.value,
                  placeholder: "종료 시간",
                  type: DFInputType.normal,
                  mode: DFInputMode.time,
                  onTimeChanged: (t) => controller.outingTo.value = t,
                ),
              ),
            ],
          ),
          const SizedBox(height: DFSpacing.spacing400),
        ],
      )),

      // 신청 사유
      DFInputField(
        title: "신청 사유",
        inputs: [
          DFInput(
            controller: controller.outingReasonTEC,
            placeholder: "신청 사유를 입력하세요",
            type: DFInputType.normal,
          ),
          const SizedBox(height: DFSpacing.spacing400),
        ],
      ),

      // 급식 취소
      Obx(() => DFInputField(
        title: "급식 취소",
        inputs: [
          Row(
            children: [
              Expanded(
                child: DFOption(
                  label: "아침",
                  activated: controller.breakfastCancel.value,
                  onTap: () => controller.breakfastCancel.toggle(),
                ),
              ),
              const SizedBox(width: DFSpacing.spacing200),
              Expanded(
                child: DFOption(
                  label: "점심",
                  activated: controller.lunchCancel.value,
                  onTap: () => controller.lunchCancel.toggle(),
                ),
              ),
              const SizedBox(width: DFSpacing.spacing200),
              Expanded(
                child: DFOption(
                  label: "저녁",
                  activated: controller.dinnerCancel.value,
                  onTap: () => controller.dinnerCancel.toggle(),
                ),
              ),
              const SizedBox(height: DFSpacing.spacing400),
            ],
          ),
          const SizedBox(height: DFSpacing.spacing400),
        ],
      )),

      // 자기계발외출 버튼
      if (controller.selectedStay.value?.outingDay?.contains(
        DateFormat("yyyy-MM-dd").format(selectedDate),
      ) ?? false) ...[
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: DFButton(
                label: "자기 계발 외출",
                size: DFButtonSize.large,
                theme: DFButtonTheme.grayscale,
                style: DFButtonStyle.secondary,
                onPressed: controller.applyOutingPreset,
              ),
            ),
            const SizedBox(height: DFSpacing.spacing200),
          ],
        ),
      ],

      // 하단 버튼
      Row(
        children: [
          Expanded(
            child: DFButton(
              label: isEditing ? "수정하기" : "신청하기",
              size: DFButtonSize.large,
              theme: DFButtonTheme.accent,
              onPressed: () => _handleSubmit(context, controller),
            ),
          ),
          if (isEditing) ...[
            const SizedBox(width: DFSpacing.spacing200),
            Expanded(
              child: DFButton(
                label: "삭제하기",
                size: DFButtonSize.large,
                theme: DFButtonTheme.negative,
                style: DFButtonStyle.secondary,
                onPressed: () => _handleDelete(context, controller),
              ),
            ),
          ],
        ],
      ),
    ];
  }

  Future<void> _handleSubmit(BuildContext context, StayPageController controller) async {
    if (controller.outingFrom.value == null ||
        controller.outingTo.value == null ||
        controller.outingReasonTEC.text.isEmpty) {
      DFSnackBar.error("모든 항목을 입력해주세요.");
      return;
    }

    final fromDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      controller.outingFrom.value!.hour,
      controller.outingFrom.value!.minute,
    );

    final toDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      controller.outingTo.value!.hour,
      controller.outingTo.value!.minute,
    );

    final newOuting = Outing(
      id: outing?.id,
      from: fromDateTime.toIso8601String(),
      to: toDateTime.toIso8601String(),
      reason: controller.outingReasonTEC.text,
      breakfastCancel: controller.breakfastCancel.value,
      lunchCancel: controller.lunchCancel.value,
      dinnerCancel: controller.dinnerCancel.value,
    );

    try {
      if (isEditing && outing != null) {
        await controller.updateStayOuting(newOuting);
      } else {
        await controller.addStayOuting(newOuting);
      }
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      return;
    }
  }

  Future<void> _handleDelete(BuildContext context, StayPageController controller) async {
    try {
      await controller.deleteStayOuting(outing!.id!);
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      return;
    }
  }
}
