import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/services/meal/model.dart';
import 'package:dimigoin_app_v4/app/services/meal/state.dart';
import 'package:dimigoin_app_v4/app/widgets/animated_cross_fade.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFList.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSegmentControl.dart';
import 'package:dimigoin_app_v4/app/widgets/shimmer_loading_box.dart';
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
          body: SingleChildScrollView(
            child: Obx(() {
              return Padding(
                padding: const EdgeInsets.only(
                  left: DFSpacing.spacing400,
                  right: DFSpacing.spacing400,
                  bottom: DFSpacing.spacing500,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: DFSpacing.spacing200),
                    DFSegmentControl(
                      segments: MealPageController.dayLabels
                          .map((day) => DFSegment(label: day))
                          .toList(),
                      initialIndex: controller.selectedDayIndex.value,
                      onChanged: controller.selectDay,
                    ),
                    const SizedBox(height: DFSpacing.spacing550),
                    Obx(
                      () => DFAnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        animateSize: false,
                        firstChild: (_) => Column(
                          children: List.generate(
                            3,
                            (index) => const Padding(
                              padding: EdgeInsets.only(
                                bottom: DFSpacing.spacing500,
                              ),
                              child: DFShimmerLoadingBox(height: 100),
                            ),
                          ),
                        ),
                        secondChild: (context) => controller.meals.isEmpty
                            ? const Center(
                                child: Text('급식 정보가 없습니다.'),
                              )
                            : Column(
                                children: controller.meals.map(
                                  (meal) => _MealCard(
                                    meal: meal,
                                    highlighted: controller.isHighlightedMeal(
                                      meal.type,
                                      controller.selectedDate,
                                    ),
                                  ),
                                ).toList(),
                              ),
                        crossFadeState: controller.mealService.mealStateRx.value is! MealSuccess
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                      )
                    ),
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: DFButton(
                    //     label: "간편식 신청",
                    //     size: DFButtonSize.large,
                    //     theme: DFButtonTheme.accent,
                    //     style: DFButtonStyle.primary,
                    //     onPressed: () {},
                    //   ),
                    // ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final MealMenuData meal;
  final bool highlighted;

  const _MealCard({required this.meal, required this.highlighted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DFSpacing.spacing500),
      child: DFValueList(
        type: DFValueListType.vertical,
        theme: highlighted
            ? DFValueListTheme.active
            : DFValueListTheme.outlined,
        title: meal.title,
        subTitle: meal.time != ""
            ? "${meal.time.split(':').first}시 ${meal.time.split(':').last}분"
            : "",
        content: meal.regular.isEmpty && meal.simple.isEmpty
            ? "급식 정보가 없습니다."
            : (meal.regular.isEmpty
                  ? meal.simple.join(", ")
                  : meal.regular.join(", ") +
                        (meal.simple.isEmpty
                            ? ""
                            : "\n<간편식> ${meal.simple.join(", ")}")),
      ),
    );
  }
}
