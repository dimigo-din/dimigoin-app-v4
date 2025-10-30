import 'package:dimigoin_app_v4/app/pages/wakeup/wakeup_apply/controller.dart';
import 'package:dimigoin_app_v4/app/pages/wakeup/wakeup_vote/controller.dart';
import 'package:get/get.dart';

import 'controller.dart';

class WakeupPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WakeupPageController());
    Get.lazyPut(() => WakeupVotePageController());
    Get.lazyPut(() => WakeupApplyPageController());
  }
}
