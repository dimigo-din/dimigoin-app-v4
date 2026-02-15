import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFButton.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFList.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSegmentControl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class MealPage extends GetView<MealPageController> {
  const MealPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return Container(
      decoration: BoxDecoration(color: colorTheme.backgroundStandardSecondary),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: colorTheme.backgroundStandardSecondary,
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.only(
                left: DFSpacing.spacing400,
                right: DFSpacing.spacing400,
                bottom: DFSpacing.spacing500),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(height: DFSpacing.spacing200),
                        DFSegmentControl(
                          segments: controller.mealDays.map((day) => DFSegment(label: day.dayLabel)).toList(),
                          initialIndex: controller.selectedDayIndex.value,
                          onChanged: controller.selectDay,
                        ),
                        const SizedBox(height: DFSpacing.spacing550),
                        if (controller.hasLoadError.value)
                          const _MealStateMessage(message: "급식 정보를 불러오지 못했습니다.")
                        else if (controller.meals.isEmpty)
                          const _MealStateMessage(message: "급식 정보가 없습니다.")
                        else
                          ...controller.meals.map((meal) => _MealCard(meal: meal)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DFButton(
                      label: "간편식 신청",
                      size: DFButtonSize.large,
                      theme: DFButtonTheme.accent,
                      style: DFButtonStyle.primary,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _MealStateMessage extends StatelessWidget {
  final String message;

  const _MealStateMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DFSpacing.spacing800),
      child: Center(
        child: Text(
          message,
          style: Theme.of(context).extension<DFTypography>()!.body.copyWith(
            color: colorTheme.contentStandardSecondary,
          ),
        ),
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final MealMenu meal;

  const _MealCard({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DFSpacing.spacing500),
      child: DFValueList(
        type: DFValueListType.vertical,
        theme: meal.highlighted
            ? DFValueListTheme.active
            : DFValueListTheme.outlined,
        title: meal.title,
        subTitle: meal.time,
        content: meal.items.join(", "),
      ),
    );
  }
}
