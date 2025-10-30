import 'package:get/get.dart';

import 'controller.dart';

class OthersPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OthersPageController());
  }
}
