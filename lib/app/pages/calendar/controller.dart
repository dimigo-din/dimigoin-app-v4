import 'dart:developer';

import 'package:dimigoin_app_v4/app/services/calendar/model.dart';
import 'package:dimigoin_app_v4/app/services/calendar/service.dart';
import 'package:get/get.dart';

class CalendarPageController extends GetxController {
  final calendarService = CalendarService();

  final selectedDay = DateTime.now().obs;

  // ignore: invalid_use_of_protected_member
  List<CalendarEvent> get events => _events.value;
  final RxList<CalendarEvent> _events = RxList<CalendarEvent>();

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchEventsForMonth(DateTime.now());
  }

  Future<void> fetchEventsForMonth(DateTime month) async {
    try {
      // final events = await calendarService.fetchEventsForMonth(month);
      // _events.value = events;
    } catch (e) {
      log('Failed to fetch calendar events: $e');
    }
  }
}