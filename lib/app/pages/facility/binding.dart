import 'package:get/get.dart';

import 'controller.dart';

class FacilityPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FacilityPageController());
  }
}
