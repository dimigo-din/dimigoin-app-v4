import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/pages/home/controller.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeTableWidget extends GetView<HomePageController> {
  TimeTableWidget({super.key});

  final AuthService authService = Get.find<AuthService>();

  final List<String> days = ['월', '화', '수', '목', '금'];
  final List<String> periods = ['1', '2', '3', '4', '5', '6', '7'];

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Container(
      padding: const EdgeInsets.all(DFSpacing.spacing400),
      decoration: BoxDecoration(
        color: colorTheme.componentsFillStandardPrimary,
        borderRadius: BorderRadius.circular(DFRadius.radius800),
        border: Border.all(
          color: colorTheme.lineOutline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '시간표  ${authService.user?.userGrade}학년 ${authService.user?.userClass}반',
            style: textTheme.caption.copyWith(
              color: colorTheme.contentStandardSecondary,
            ),
          ),
          const SizedBox(height: 10),

          Table(
            border: TableBorder(
              horizontalInside: BorderSide(color: colorTheme.lineOutline, width: 1),
              verticalInside: BorderSide.none,
              top: BorderSide.none,
              bottom: BorderSide.none,
              left: BorderSide.none,
              right: BorderSide.none,
            ),
            children: [
              TableRow(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: colorTheme.lineOutline, width: 1),
                      ),
                    ),
                    child: const Text(''),
                  ),
                  ...days.map(
                    (day) => Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          day,
                          style: textTheme.callout.copyWith(
                            color: colorTheme.coreBrandPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              ...periods.map((period) {
                final periodIndex = int.parse(period) - 1;

                return TableRow(
                  children: [
                     Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: colorTheme.lineOutline, width: 1),
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          period,
                          style: textTheme.callout.copyWith(
                            color: colorTheme.contentStandardTertiary,
                          ),
                        ),
                      ),
                    ),

                    ...List.generate(days.length, (dayIndex) {
                      return Obx(() {
                        final timetable = controller.timetable.value;

                        if (timetable == null) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                '',
                                style: textTheme.callout.copyWith(
                                  color: colorTheme.contentStandardSecondary,
                                ),
                              ),
                            ),
                          );
                        }

                        final daySchedule = timetable.schedule[dayIndex];

                        if (periodIndex >= daySchedule.length) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                '',
                                style: textTheme.callout.copyWith(
                                  color: colorTheme.contentStandardSecondary,
                                ),
                              ),
                            ),
                          );
                        }

                        final subject = daySchedule[periodIndex];

                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: subject.temp
                                ? colorTheme.coreBrandTertiary
                                : Colors.transparent,
                          ),
                            child: Center(
                            child: Text(
                              subject.content.split('\n')[0],
                              style: textTheme.callout.copyWith(
                              color: subject.temp
                                ? colorTheme.contentStandardSecondary
                                : colorTheme.contentStandardPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        );
                      });
                    }),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}