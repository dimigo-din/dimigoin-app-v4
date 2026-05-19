import 'package:get/get.dart';

import 'controller.dart';

class DormPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(DormPageController());
  }
}
