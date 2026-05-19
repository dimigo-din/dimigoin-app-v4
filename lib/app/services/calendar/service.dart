import 'dart:async';

import 'package:get/get.dart';

import 'model.dart';
import 'repository.dart';

class CalendarService extends GetxController {
  final CalendarRepository repository;

  CalendarService({CalendarRepository? repository})
    : repository = repository ?? CalendarRepository();

  @override
  Future<void> onInit() async {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {}

  Future<List<CalendarEvent>> fetchAcademicEventsForMonth(
    DateTime month,
  ) async {
    // Backend API is not ready yet. Keep the service boundary so the page can
    // swap this stub for a repository call without changing UI state handling.
    return const [];
  }
}
