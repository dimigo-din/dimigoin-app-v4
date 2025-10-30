import 'package:get/get.dart';

import 'controller.dart';

class PWLoginPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PWLoginPageController());
  }
}
