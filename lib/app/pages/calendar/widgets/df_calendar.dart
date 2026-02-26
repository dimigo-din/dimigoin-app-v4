import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/services/calendar/model.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DFCalendar extends StatefulWidget {
  final List<CalendarEvent> events;
  final Function(DateTime)? onDaySelected;
  final Function(DateTime)? onMonthChanged;

  const DFCalendar({
    super.key,
    this.onDaySelected,
    this.onMonthChanged,
    this.events = const [],
  });

  @override
  State<DFCalendar> createState() => _DFCalendarState();
}

class _DFCalendarState extends State<DFCalendar> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    return widget.events.where((event) {
      return isSameDay(event.date, day);
    }).toList();
  }

  Widget _dowText(String label) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Center(
      child: Text(
        label,
        style:
            textTheme.body.copyWith(color: colorTheme.contentStandardSecondary),
      ),
    );
  }

  Widget _dayCell(
    DateTime day,
    List<CalendarEvent> eventList,
    bool isHighlighted,
    bool isPrimaryHighlight,
  ) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Container(
      width: 40,
      height: 54,
      padding: const EdgeInsets.only(
        top: DFSpacing.spacing200,
        bottom: DFSpacing.spacing300,
      ),
      decoration: BoxDecoration(
        color: isPrimaryHighlight
            ? colorTheme.coreBrandPrimary
            : (isHighlighted
                ? colorTheme.coreBrandSecondary
                : Colors.transparent),
        borderRadius: BorderRadius.circular(DFRadius.radius300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${day.day}',
            style: textTheme.callout.copyWith(
              color: colorTheme.contentStandardPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (eventList.isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                eventList.length > 4 ? 4 : eventList.length,
                (index) {
                  final event = eventList[index];

                  return Container(
                    margin: EdgeInsets.only(
                      left: index == 0 ? 0 : 2,
                    ),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: switch (event.type) {
                        CalendarEventType.exam => colorTheme.calenarExam,
                        CalendarEventType.home => colorTheme.calendarHome,
                        CalendarEventType.vacation => colorTheme.calendarVacation,
                        CalendarEventType.event => colorTheme.calendarEvent,
                        CalendarEventType.stay => colorTheme.calendarStay,
                      },
                      shape: BoxShape.circle,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.arrow_back_ios_outlined, size: 24),
              color: colorTheme.contentStandardSecondary,
              onPressed: () {
                setState(() {
                  _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
                });
              },
            ),
            SizedBox(
              width: 50,
              child: Text(
                '${_focusedDay.month}월',
                style: textTheme.headline.copyWith(
                  color: colorTheme.contentStandardSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.arrow_forward_ios_outlined, size: 24),
              color: colorTheme.contentStandardSecondary,
              onPressed: () {
                setState(() {
                  _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
                });
              },
            ),
          ],
        ),
        SizedBox(height: 10),
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2100, 12, 31),
          focusedDay: _focusedDay,
          daysOfWeekHeight: 30,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });

            widget.onDaySelected?.call(selectedDay);
          },
          onPageChanged: (focusedDay) {
            setState(() => _focusedDay = focusedDay);

            widget.onMonthChanged?.call(focusedDay);
          },
          calendarBuilders: CalendarBuilders(
            dowBuilder: (context, day) {
              switch (day.weekday) {
                case 1:
                  return _dowText('월');
                case 2:
                  return _dowText('화');
                case 3:
                  return _dowText('수');
                case 4:
                  return _dowText('목');
                case 5:
                  return _dowText('금');
                case 6:
                  return _dowText('토');
                case 7:
                  return _dowText('일');
              }
              return null;
            },
            defaultBuilder: (context, day, focusedDay) {
              final eventList = _getEventsForDay(day);

              return _dayCell(day, eventList, false, false);
            },
            todayBuilder: (context, day, focusedDay) {
              final eventList = _getEventsForDay(day);

              return _dayCell(day, eventList, true, false);
            },
            selectedBuilder: (context, day, focusedDay) {
              final eventList = _getEventsForDay(day);

              return _dayCell(day, eventList, true, true);
            },
          ),
          headerVisible: false,
          calendarStyle: const CalendarStyle(
            outsideDaysVisible: true,
          ),
          rowHeight: 60,
        ),
      ],
    );
  }
}
