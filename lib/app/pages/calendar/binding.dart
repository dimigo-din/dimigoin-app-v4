import 'package:get/get.dart';

import 'controller.dart';

class CalendarPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CalendarPageController());
  }
}
