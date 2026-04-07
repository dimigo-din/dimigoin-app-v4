import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/core/utils/text_cleaner.dart';
import 'package:dimigoin_app_v4/app/services/wakeup/model.dart';
import 'package:dimigoin_app_v4/app/services/wakeup/state.dart';
import 'package:dimigoin_app_v4/app/widgets/animated_cross_fade.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFAvatar.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFDivider.dart';
import 'package:dimigoin_app_v4/app/widgets/shimmer_loading_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import '../widgets/WakeupItem.dart';
import 'widgets/wakeup_vote_button.dart';

class WakeupVotePage extends GetView<WakeupVotePageController> {
  const WakeupVotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: DFSpacing.spacing500),
        child: Column(
          children: [
            _buildTodayWakeupSection(context),
            Expanded(
              child: Obx(
                () => DFAnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  firstChild: (_) => Column(
                children: List.generate(
                  3,
                  (index) => const Column(
                    children: [
                      SizedBox(height: 5),
                      DFShimmerLoadingBox(height: 72),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
                  secondChild: (_) => _buildApplicationsList(context),
                  crossFadeState:
                      controller.wakeupService.wakeupState is! WakeupSuccess ||
                          controller.wakeupService.wakeupVoteState
                              is! WakeupVoteSuccess
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayWakeupSection(BuildContext context) {
    return Obx(() {
      final todayWakeup = controller.todayWakeup.value;
      if (todayWakeup == null) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          GestureDetector(
            onTap: () => controller.launchYoutubeUrl(todayWakeup.videoId),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DFSpacing.spacing400,
              ),
              child: WakeupItem(
                title: TextCleaner.cleanText(todayWakeup.videoTitle),
                trailing: Text(
                  '오늘의 기상송',
                  style: Theme.of(context)
                      .extension<DFTypography>()!
                      .callout
                      .copyWith(
                        color: Theme.of(
                          context,
                        ).extension<DFColors>()!.contentStandardSecondary,
                      ),
                ),
              ),
            ),
          ),
          const SizedBox(height: DFSpacing.spacing300),
          const DFDivider(size: DFDividerSize.medium),
          const SizedBox(height: DFSpacing.spacing300),
        ],
      );
    });
  }

  Widget _buildApplicationsList(BuildContext context) {
    return Obx(() {
      final List<WakeupApplicationWithVote> wakeupApplications =
          (controller.wakeupService.wakeupState as WakeupSuccess).wakeups;

      final List<WakeupApplicationVotes> wakeupVotes =
          (controller.wakeupService.wakeupVoteState as WakeupVoteSuccess).votes;

      if (wakeupApplications.isEmpty) {
        return _buildEmptyState(context);
      }

      final sortedApplications = wakeupApplications.toList()
        ..sort((a, b) => b.up.compareTo(a.up));

      return ListView.separated(
        itemCount: sortedApplications.length,
        separatorBuilder: (_, _) => const Column(
          children: [
            SizedBox(height: 5),
            DFDivider(size: DFDividerSize.small),
            SizedBox(height: 5),
          ],
        ),
        itemBuilder: (_, index) {
          final current = sortedApplications[index];
          final vote = wakeupVotes.firstWhereOrNull(
            (v) => v.wakeupSongApplication.id == current.id,
          );
          return _buildApplicationItem(current, vote);
        },
      );
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Text(
          '신청된 기상송이 없습니다',
          style: Theme.of(context).extension<DFTypography>()!.body.copyWith(
            color: Theme.of(
              context,
            ).extension<DFColors>()!.contentStandardSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildApplicationItem(
    WakeupApplicationWithVote application,
    WakeupApplicationVotes? vote,
  ) {
    return WakeupItem(
      title: TextCleaner.cleanText(application.videoTitle),
      content: TextCleaner.cleanText(application.videoChannel ?? ''),
      leading: GestureDetector(
        onTap: () => controller.launchYoutubeUrl(application.videoId),
        child: DFAvatar(
          type: DFAvatarType.classroom,
          size: DFAvatarSize.large,
          fill: DFAvatarFill.image,
          image: Image.network(application.videoThumbnail ?? ''),
        ),
      ),
      trailing: _buildVoteButtons(application, vote),
    );
  }

  Widget _buildVoteButtons(
    WakeupApplicationWithVote application,
    WakeupApplicationVotes? vote,
  ) {
    return Column(
      children: [
        WakeupVoteButton(
          count: application.up,
          isUpvote: true,
          onPressed: () =>
              controller.voteWakeupApplication(application.id, true),
          isVoted: vote?.upvote == true,
        ),
        const SizedBox(height: DFSpacing.spacing100),
        WakeupVoteButton(
          count: application.down,
          isUpvote: false,
          onPressed: () =>
              controller.voteWakeupApplication(application.id, false),
          isVoted: vote?.upvote == false,
        ),
      ],
    );
  }
}
