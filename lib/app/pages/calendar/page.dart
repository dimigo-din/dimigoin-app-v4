import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/services/calendar/model.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFDivider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'controller.dart';
import 'widgets/df_calendar.dart';

class CalendarPage extends GetView<CalendarPageController> {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return Container(
      decoration: BoxDecoration(color: colorTheme.backgroundStandardSecondary),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: colorTheme.backgroundStandardSecondary,
          body: Obx(
            () => ListView(
              padding: const EdgeInsets.only(
                left: DFSpacing.spacing400,
                right: DFSpacing.spacing400,
                bottom: DFSpacing.spacing600,
              ),
              children: [
                DFCalendar(
                  events: controller.events,
                  onDaySelected: controller.selectDay,
                  onMonthChanged: controller.fetchEventsForMonth,
                ),
                const SizedBox(height: DFSpacing.spacing300),
                DFDivider(size: DFDividerSize.small),
                const SizedBox(height: DFSpacing.spacing500),
                _SectionHeader(
                  title: '학사일정',
                  subtitle: _selectedDateLabel(controller.selectedDay.value),
                ),
                const SizedBox(height: DFSpacing.spacing300),
                _AcademicScheduleSection(
                  events: controller.selectedDayEvents,
                  isLoading: controller.isLoadingEvents.value,
                ),
                const SizedBox(height: DFSpacing.spacing600),
                _SectionHeader(
                  title: 'TODO',
                  subtitle: '선택한 날짜 기준',
                  trailing: IconButton(
                    onPressed: () => _showAddTodoSheet(context),
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: colorTheme.coreBrandPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: DFSpacing.spacing300),
                _TodoSection(
                  todos: controller.selectedDayTodos,
                  onToggle: controller.toggleTodo,
                  onDelete: controller.deleteTodo,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _selectedDateLabel(DateTime date) {
    return DateFormat('M월 d일 EEEE', 'ko_KR').format(date);
  }

  void _showAddTodoSheet(BuildContext context) {
    final textController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final colorTheme = Theme.of(context).extension<DFColors>()!;
        final textTheme = Theme.of(context).extension<DFTypography>()!;
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;

        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                DFSpacing.spacing500,
                DFSpacing.spacing500,
                DFSpacing.spacing500,
                DFSpacing.spacing500,
              ),
              decoration: BoxDecoration(
                color: colorTheme.backgroundStandardPrimary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TODO 추가',
                    style: textTheme.headline.copyWith(
                      color: colorTheme.contentStandardPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: DFSpacing.spacing400),
                  TextField(
                    controller: textController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: '할 일을 입력하세요',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _submitTodo(context, textController),
                  ),
                  const SizedBox(height: DFSpacing.spacing400),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => _submitTodo(context, textController),
                      child: const Text('추가'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete(textController.dispose);
  }

  void _submitTodo(BuildContext context, TextEditingController textController) {
    if (textController.text.trim().isEmpty) {
      return;
    }

    controller.addTodo(textController.text);
    Navigator.of(context).pop();
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.headline.copyWith(
                  color: colorTheme.contentStandardPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: DFSpacing.spacing100),
              Text(
                subtitle,
                style: textTheme.callout.copyWith(
                  color: colorTheme.contentStandardTertiary,
                ),
              ),
            ],
          ),
        ),
        ...trailing == null ? const <Widget>[] : [trailing!],
      ],
    );
  }
}

class _AcademicScheduleSection extends StatelessWidget {
  final List<CalendarEvent> events;
  final bool isLoading;

  const _AcademicScheduleSection({
    required this.events,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _EmptyPanel(message: '학사일정을 불러오는 중입니다.');
    }

    if (events.isEmpty) {
      return const _EmptyPanel(message: '등록된 학사일정이 없습니다.');
    }

    return Column(
      children: events
          .map((event) => _AcademicEventTile(event: event))
          .toList(),
    );
  }
}

class _AcademicEventTile extends StatelessWidget {
  final CalendarEvent event;

  const _AcademicEventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Container(
      margin: const EdgeInsets.only(bottom: DFSpacing.spacing300),
      padding: const EdgeInsets.all(DFSpacing.spacing400),
      decoration: BoxDecoration(
        color: colorTheme.backgroundStandardPrimary,
        borderRadius: BorderRadius.circular(DFRadius.radius400),
        border: Border.all(color: colorTheme.lineOutline),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: _eventColor(context, event.type),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: DFSpacing.spacing300),
          Expanded(
            child: Text(
              event.title,
              style: textTheme.body.copyWith(
                color: colorTheme.contentStandardPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            event.description ?? '하루종일',
            style: textTheme.callout.copyWith(
              color: colorTheme.contentStandardTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Color _eventColor(BuildContext context, CalendarEventType type) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return switch (type) {
      CalendarEventType.exam => colorTheme.calenarExam,
      CalendarEventType.home => colorTheme.calendarHome,
      CalendarEventType.vacation => colorTheme.calendarVacation,
      CalendarEventType.event => colorTheme.calendarEvent,
      CalendarEventType.stay => colorTheme.calendarStay,
    };
  }
}

class _TodoSection extends StatelessWidget {
  final List<CalendarTodoItem> todos;
  final ValueChanged<CalendarTodoItem> onToggle;
  final ValueChanged<CalendarTodoItem> onDelete;

  const _TodoSection({
    required this.todos,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return const _EmptyPanel(message: '추가된 TODO가 없습니다.');
    }

    return Column(
      children: todos
          .map(
            (todo) => _TodoTile(
              todo: todo,
              onToggle: () => onToggle(todo),
              onDelete: () => onDelete(todo),
            ),
          )
          .toList(),
    );
  }
}

class _TodoTile extends StatelessWidget {
  final CalendarTodoItem todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _TodoTile({
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Container(
      margin: const EdgeInsets.only(bottom: DFSpacing.spacing300),
      padding: const EdgeInsets.symmetric(
        horizontal: DFSpacing.spacing300,
        vertical: DFSpacing.spacing200,
      ),
      decoration: BoxDecoration(
        color: colorTheme.backgroundStandardPrimary,
        borderRadius: BorderRadius.circular(DFRadius.radius400),
        border: Border.all(color: colorTheme.lineOutline),
      ),
      child: Row(
        children: [
          Checkbox(value: todo.isDone, onChanged: (_) => onToggle()),
          Expanded(
            child: Text(
              todo.title,
              style: textTheme.body.copyWith(
                color: todo.isDone
                    ? colorTheme.contentStandardTertiary
                    : colorTheme.contentStandardPrimary,
                decoration: todo.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(
              Icons.delete_outline,
              color: colorTheme.contentStandardTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  final String message;

  const _EmptyPanel({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DFSpacing.spacing500),
      decoration: BoxDecoration(
        color: colorTheme.backgroundStandardPrimary,
        borderRadius: BorderRadius.circular(DFRadius.radius400),
        border: Border.all(color: colorTheme.lineOutline),
      ),
      child: Text(
        message,
        style: textTheme.callout.copyWith(
          color: colorTheme.contentStandardTertiary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
