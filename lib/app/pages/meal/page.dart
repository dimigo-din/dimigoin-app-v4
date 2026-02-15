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

            return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: DFSpacing.spacing500,
              ),
              children: [
                const SizedBox(height: DFSpacing.spacing200),
                _DayTabs(
                  selectedIndex: controller.selectedDayIndex.value,
                  labels: controller.mealDays
                      .map((day) => day.dayLabel)
                      .toList(),
                  onSelected: controller.selectDay,
                ),
                const SizedBox(height: DFSpacing.spacing550),
                if (controller.hasLoadError.value)
                  const _MealStateMessage(message: "급식 정보를 불러오지 못했습니다.")
                else if (controller.meals.isEmpty)
                  const _MealStateMessage(message: "급식 정보가 없습니다.")
                else
                  ...controller.meals.map((meal) => _MealCard(meal: meal)),
                const SizedBox(height: DFSpacing.spacing600),
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
                const SizedBox(height: DFSpacing.spacing800),
              ],
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

class _DayTabs extends StatelessWidget {
  final int selectedIndex;
  final List<String> labels;
  final ValueChanged<int> onSelected;

  const _DayTabs({
    required this.selectedIndex,
    required this.labels,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return Container(
      padding: const EdgeInsets.all(DFSpacing.spacing100),
      decoration: BoxDecoration(
        color: colorTheme.componentsTranslucentSecondary,
        borderRadius: BorderRadius.circular(DFRadius.radius700),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == labels.length - 1 ? 0 : DFSpacing.spacing100,
              ),
              child: DFSegment(
                activated: index == selectedIndex,
                label: labels[index],
                onTap: () => onSelected(index),
              ),
            ),
          );
        }),
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
