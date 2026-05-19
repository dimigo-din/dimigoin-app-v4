import 'package:get/get.dart';

import 'controller.dart';

class MealPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MealPageController());
  }
}
