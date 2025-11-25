import 'package:get/get.dart';

import 'controller.dart';

class LoginPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(LoginPageController());
  }
}
