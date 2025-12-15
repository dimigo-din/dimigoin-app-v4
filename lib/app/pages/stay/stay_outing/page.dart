import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFButton.dart';
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
            Obx(() {
              if (controller.selectedStay.value == null) {
                return const SizedBox();
              }

              final days = OutingDateUtils.getOutingDays(
                controller.selectedStay.value!,
              );

              return OutingDateSelector(dates: days);
            }),
            const SizedBox(height: DFSpacing.spacing300),

            // 외출 목록
            Expanded(
              child: Obx(() => SingleChildScrollView(
                child: Column(
                  children: _buildFilteredOutingList(),
                ),
              )),
            ),
            const SizedBox(height: DFSpacing.spacing300),

            // 외출 추가 버튼
            SizedBox(
              width: double.infinity,
              child: DFButton(
                label: "외출 추가",
                size: DFButtonSize.large,
                theme: DFButtonTheme.accent,
                style: DFButtonStyle.primary,
                onPressed: () => _showOutingBottomSheet(context, false, null),
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

    final days = OutingDateUtils.getOutingDays(
      controller.selectedStay.value!,
    );
    final selectedDay = days[controller.selectedStayOutingDay.value];

    return controller.currentStayOutings
        .where((outing) {
          if (outing.from == null) return false;

          final outingDate = DateTime.parse(outing.from!).toLocal();
          return OutingDateUtils.isSameDay(outingDate, selectedDay);
        })
        .map((outing) => OutingListItem(
              outing: outing,
              onTap: () => _showOutingBottomSheet(
                Get.context!,
                true,
                outing,
              ),
            ))
        .toList();
  }

  void _showOutingBottomSheet(
    BuildContext context,
    bool isEditing,
    dynamic outing,
  ) {
    if(controller.selectedStay.value == null){
      return;
    }

    final days = OutingDateUtils.getOutingDays(
      controller.selectedStay.value!,
    );
    final selectedDate = days[controller.selectedStayOutingDay.value];

    OutingFormBottomSheet.show(
      context: context,
      isEditing: isEditing,
      outing: outing,
      selectedDate: selectedDate,
    );
  }
}
