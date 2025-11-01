import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/services/wakeup/model.dart';
import 'package:dimigoin_app_v4/app/services/wakeup/service.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../wakeup_vote/controller.dart';

class WakeupApplyPageController extends GetxController {
  final wakeupService = WakeupService();

  final RxString youtubeSearchQuery = ''.obs;

  final RxList<YoutubeItem> youtubeSearchResults = <YoutubeItem>[].obs;

  final RxList<WakeupApplication> wakeupApplications = <WakeupApplication>[].obs;

  @override
  void onInit() async  {
    super.onInit();
  }

  Future<void> searchYoutubeVideo() async {
    try {
      final result = await wakeupService.searchYoutube(youtubeSearchQuery.value);

      final videoResults = result.items.where((item) => item.id.videoId != null).toList();
      youtubeSearchResults.assignAll(videoResults);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> applyWakeupSong(BuildContext context, String videoId) async {
    try {
      DFSnackBar.info(
        "신청 중입니다...",
      );
      await wakeupService.applyWakeupSong(videoId);
      DFSnackBar.success(
        "신청이 완료되었습니다.",
      );
      Get.find<WakeupVotePageController>().fetchWakeupApplications();
      Navigator.pop(context);
    } on ResourceAlreadyExists  {
      DFSnackBar.error(
        "이미 신청된 곡입니다.",
      );
    } on ResourceNotFoundException {
      DFSnackBar.error(
        "존재하지 않는 리소스입니다. 다시 시도해주세요.",
      );
    } catch (e) {
      DFSnackBar.error(
        "신청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.",
      );
      rethrow;
    }
  }
}