import 'package:get/get.dart';

import 'controller.dart';

class FrigoPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FrigoController());
  }
}
