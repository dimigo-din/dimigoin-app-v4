import 'package:dimigoin_app_v4/app/services/wakeup/model.dart';
import 'package:dimigoin_app_v4/app/services/wakeup/service.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class WakeupVotePageController extends GetxController {
  final wakeupService = WakeupService();

  final RxList<WakeupApplicationWithVote> wakeupApplications = <WakeupApplicationWithVote>[].obs;
  final RxList<WakeupApplicationVotes> wakeupVotes = <WakeupApplicationVotes>[].obs;

  @override
  void onInit() async  {
    super.onInit();
    await fetchWakeupApplications();
    await fetchWakeupVotes();
  }

  Future<void> fetchWakeupApplications() async {
    final applications = await wakeupService.getWakeupApplications();

    wakeupApplications.assignAll(applications);
  }

  Future<void> fetchWakeupVotes() async {
    try {
      final votes = await wakeupService.getWakeupApplicationVotes();

      wakeupVotes.assignAll(votes);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> voteWakeupApplication(String applicationId, bool isUpvote) async {
    try {

      final isVoted = wakeupVotes.any((vote) => vote.wakeupSongApplication.id == applicationId && vote.upvote == isUpvote);

      if(isVoted) {
        DFSnackBar.info("투표 취소중입니다...");
        await wakeupService.deleteVoteWakeupApplication(
          wakeupVotes.firstWhere((vote) => vote.wakeupSongApplication.id == applicationId && vote.upvote == isUpvote).id
        );
        DFSnackBar.success("투표가 취소되었습니다.");
      } else {
        DFSnackBar.info("투표 중입니다...");

        final isOtherVoted = wakeupVotes.any((vote) => vote.wakeupSongApplication.id == applicationId && vote.upvote == !isUpvote);
        if (isOtherVoted) {
          await wakeupService.deleteVoteWakeupApplication(
            wakeupVotes.firstWhere((vote) => vote.wakeupSongApplication.id == applicationId && vote.upvote == !isUpvote).id
          );
        }

        await wakeupService.voteWakeupApplication(applicationId, isUpvote);
        DFSnackBar.success("투표가 완료되었습니다.");
      }
      await fetchWakeupApplications();
      await fetchWakeupVotes();
    } catch (e) {
      DFSnackBar.error("투표 중 오류가 발생했습니다.");
      rethrow;
    }
  }

  Future<void> launchYoutubeUrl(String id) async {
    final Uri uri = Uri.parse("https://www.youtube.com/watch?v=$id");
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $id';
    }
  }
}
