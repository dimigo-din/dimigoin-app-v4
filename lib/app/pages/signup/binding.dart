import 'package:get/get.dart';

import 'controller.dart';

class SignupPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignupPageController());
  }
}
