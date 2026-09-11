import 'package:get/get.dart';

import 'controller.dart';

class LostfoundDetailPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LostfoundDetailPageController());
  }
}
