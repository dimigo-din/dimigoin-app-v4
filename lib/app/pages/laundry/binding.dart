import 'package:get/get.dart';

import 'controller.dart';

class LaundryPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LaundryPageController());
  }
}
