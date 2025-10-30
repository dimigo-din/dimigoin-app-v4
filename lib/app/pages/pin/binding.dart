import 'package:get/get.dart';

import 'controller.dart';

class PinInputPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PinInputController());
  }
}
