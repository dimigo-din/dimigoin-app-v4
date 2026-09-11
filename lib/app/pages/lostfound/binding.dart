import 'package:get/get.dart';

import 'controller.dart';

class LostfoundPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LostfoundPageController());
  }
}
