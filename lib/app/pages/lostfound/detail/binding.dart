import 'package:get/get.dart';

import 'controller.dart';

class LostfoundDetailPageBinding implements Bindings {
  @override
  void dependencies() {
    final reportId = LostfoundDetailPageController.reportIdFromRoute;
    Get.lazyPut(
      () => LostfoundDetailPageController(reportId: reportId),
      tag: reportId,
    );
  }
}
