import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFChip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller.dart';

class OutingDateSelector extends StatelessWidget {
  final List<DateTime> dates;

  const OutingDateSelector({
    super.key,
    required this.dates,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StayPageController>();

    return Row(
      children: [
        for (int i = 0; i < dates.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: i == 0 ? 0 : DFSpacing.spacing200 / 2,
                right: i == dates.length - 1 ? 0 : DFSpacing.spacing200 / 2,
              ),
              child: Obx(() => DFChip(
                label: DateFormat('M월 d일').format(dates[i]),
                status: controller.selectedStayOutingDay.value == i,
                onTap: () {
                  controller.selectedStayOutingDay.value = i;
                },
              )),
            ),
          ),
      ],
    );
  }
}
