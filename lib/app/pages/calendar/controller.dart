import 'dart:developer';

import 'package:dimigoin_app_v4/app/services/calendar/model.dart';
import 'package:dimigoin_app_v4/app/services/calendar/service.dart';
import 'package:get/get.dart';

class CalendarPageController extends GetxController {
  final calendarService = CalendarService();

  final selectedDay = DateTime.now().obs;
  final focusedMonth = DateTime(DateTime.now().year, DateTime.now().month).obs;
  final isLoadingEvents = false.obs;

  // ignore: invalid_use_of_protected_member
  List<CalendarEvent> get events => _events.value;
  final RxList<CalendarEvent> _events = RxList<CalendarEvent>();
  final RxList<CalendarTodoItem> todos = RxList<CalendarTodoItem>();

  List<CalendarEvent> get selectedDayEvents {
    final day = _dateOnly(selectedDay.value);
    return events.where((event) => _dateOnly(event.date) == day).toList();
  }

  List<CalendarTodoItem> get selectedDayTodos {
    final day = _dateOnly(selectedDay.value);
    return todos.where((todo) => _dateOnly(todo.date) == day).toList();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchEventsForMonth(DateTime.now());
  }

  Future<void> fetchEventsForMonth(DateTime month) async {
    focusedMonth.value = DateTime(month.year, month.month);
    isLoadingEvents.value = true;

    try {
      final events = await calendarService.fetchAcademicEventsForMonth(month);
      _events.value = events..sort((a, b) => a.date.compareTo(b.date));
    } catch (e) {
      log('Failed to fetch calendar events: $e');
    } finally {
      isLoadingEvents.value = false;
    }
  }

  void selectDay(DateTime day) {
    selectedDay.value = _dateOnly(day);
  }

  void addTodo(String title) {
    final normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty) {
      return;
    }

    todos.add(
      CalendarTodoItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        date: _dateOnly(selectedDay.value),
        title: normalizedTitle,
      ),
    );
  }

  void toggleTodo(CalendarTodoItem todo) {
    final index = todos.indexWhere((item) => item.id == todo.id);
    if (index == -1) {
      return;
    }

    todos[index] = todo.copyWith(isDone: !todo.isDone);
  }

  void deleteTodo(CalendarTodoItem todo) {
    todos.removeWhere((item) => item.id == todo.id);
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
