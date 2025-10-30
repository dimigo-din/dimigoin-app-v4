import 'package:get/get.dart';

import 'controller.dart';

class StayPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StayPageController());
  }
}
