import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFDivider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import 'controller.dart';
import 'widgets/calendar_event_row.dart';
import 'widgets/df_calendar.dart';

class CalendarPage extends GetView<CalendarPageController> {
  CalendarPage({super.key});

  final ScrollController _scrollController = ScrollController();

  final Map<DateTime, GlobalKey> _itemKeys = {};
  DateTime normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return Container(
      decoration: BoxDecoration(color: colorTheme.backgroundStandardSecondary),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: colorTheme.backgroundStandardSecondary,
          body: Padding(
            padding: const EdgeInsets.only(
              left: DFSpacing.spacing400,
              right: DFSpacing.spacing400,
              bottom: DFSpacing.spacing500),
            child: Column(
              children: [
                DFCalendar(
                  events: controller.events,
                  onDaySelected: (selectedDay) {
                    controller.selectedDay.value = selectedDay;

                    final key = _itemKeys[normalize(selectedDay)];

                    if (key?.currentContext != null) {
                      Scrollable.ensureVisible(
                        key!.currentContext!,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        alignment: 0.0,
                      );
                    }
                  },
                  onMonthChanged: (focusedDay) {
                    controller.fetchEventsForMonth(focusedDay);
                  },
                ),
                const SizedBox(height: 10),
                DFDivider(
                  size: DFDividerSize.small,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      controller: _scrollController,
                      itemCount: controller.events.length,
                      itemBuilder: (context, index) {
                        final event = controller.events[index];
                        final normalized = normalize(event.date);

                        final isFirstOfDay = index ==
                            controller.events.indexWhere(
                              (e) => isSameDay(e.date, event.date),
                            );

                        if (isFirstOfDay) {
                          _itemKeys.putIfAbsent(
                            normalized,
                            () => GlobalKey(),
                          );
                        }

                        return Column(
                          key: isFirstOfDay ? _itemKeys[normalized] : null,
                          children: [
                            CalendarEventRow(
                              title: event.title,
                              day: DateFormat('dd', 'ko_KR').format(event.date),
                              weekday: DateFormat('E', 'ko_KR').format(event.date),
                              content: '하루종일',
                            ),
                            const SizedBox(height: DFSpacing.spacing500),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
