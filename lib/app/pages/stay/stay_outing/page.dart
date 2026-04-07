import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/services/stay/state.dart';
import 'package:dimigoin_app_v4/app/widgets/animated_cross_fade.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFButton.dart';
import 'package:dimigoin_app_v4/app/widgets/shimmer_loading_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller.dart';
import 'widgets/outing_form_bottom_sheet.dart';
import 'widgets/outing_date_selector.dart';
import 'widgets/outing_list_item.dart';
import 'utils/outing_date_utils.dart';

class StayOutingPage extends GetView<StayPageController> {
  const StayOutingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(
          top: DFSpacing.spacing300,
          bottom: DFSpacing.spacing500,
        ),
        child: Column(
          children: [
            // 날짜 선택기
            Obx(
              () => DFAnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                firstChild: (_) => const DFShimmerLoadingBox(height: 20),
                secondChild: (_) {
                  if (controller.selectedStay.value == null) {
                    return const SizedBox();
                  }

                  final days = OutingDateUtils.getOutingDays(
                    controller.selectedStay.value!,
                  );

                  return OutingDateSelector(dates: days);
                },
                crossFadeState: controller.stayService.stayState is! StaySuccess
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              ),
            ),
            const SizedBox(height: DFSpacing.spacing300),

            // 외출 목록
            Expanded(
              child: Obx(
                () => DFAnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  firstChild: (_) => const DFShimmerLoadingBox(height: 92),
                  secondChild: (_) => SingleChildScrollView(
                    child: Column(children: _buildFilteredOutingList()),
                  ),
                  crossFadeState:
                      controller.stayService.stayOutingState
                              is! StayOutingSuccess &&
                          controller.isApplied.value
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),
              ),
            ),
            const SizedBox(height: DFSpacing.spacing300),

            // 외출 추가 버튼
            Obx(
              () => DFAnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                firstChild: (_) => const DFShimmerLoadingBox(height: 56),
                secondChild: (_) => SizedBox(
                  width: double.infinity,
                  child: DFButton(
                    label: "외출 추가",
                    size: DFButtonSize.large,
                    theme: DFButtonTheme.accent,
                    style: DFButtonStyle.primary,
                    onPressed: () =>
                        _showOutingBottomSheet(context, false, null),
                  ),
                ),
                crossFadeState:
                    controller.stayService.stayApplyState is! StayApplySuccess &&
                        controller.isApplied.value
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFilteredOutingList() {
    if (controller.selectedStay.value == null) {
      return [];
    }

    final days = OutingDateUtils.getOutingDays(controller.selectedStay.value!);
    final selectedDay = days[controller.selectedStayOutingDay.value];

    return controller.currentStayOutings
        .where((outing) {
          if (outing.from == null) return false;

          final outingDate = OutingDateUtils.parseServerDateTime(outing.from!);
          return OutingDateUtils.isSameDay(outingDate, selectedDay);
        })
        .map(
          (outing) => OutingListItem(
            outing: outing,
            onTap: () => _showOutingBottomSheet(Get.context!, true, outing),
          ),
        )
        .toList();
  }

  void _showOutingBottomSheet(
    BuildContext context,
    bool isEditing,
    dynamic outing,
  ) {
    if (controller.selectedStay.value == null) {
      return;
    }

    final days = OutingDateUtils.getOutingDays(controller.selectedStay.value!);
    final selectedDate = days[controller.selectedStayOutingDay.value];

    OutingFormBottomSheet.show(
      context: context,
      isEditing: isEditing,
      outing: outing,
      selectedDate: selectedDate,
    );
  }
}
