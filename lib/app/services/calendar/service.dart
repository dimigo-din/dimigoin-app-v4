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

}
