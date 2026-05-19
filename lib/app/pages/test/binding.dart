import 'package:get/get.dart';

import 'controller.dart';

class TestPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TestPageController());
  }
}
