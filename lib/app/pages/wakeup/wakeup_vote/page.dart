import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFAvatar.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFDivider.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import '../widgets/WakeupItem.dart';

class WakeupVotePage extends GetView<WakeupVotePageController> {
  const WakeupVotePage({super.key});

  String cleanText(String text) {
    final unescape = HtmlUnescape();
    String cleaned = unescape.convert(text);
    
    cleaned = cleaned.replaceAll(RegExp(r'\([^\)]*\)'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\[[^\]]*\]'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\{[^\}]*\}'), '');
    
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    return cleaned;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: DFSpacing.spacing500),
        child: SingleChildScrollView(
          child: Obx(() =>Column(
            children: [
              if (controller.wakeupApplications.isEmpty)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Center(
                    child: Text(
                      '신청된 기상송이 없습니다',
                      style: Theme.of(context).extension<DFTypography>()!.body.copyWith(
                      color: Theme.of(context).extension<DFColors>()!.contentStandardSecondary,
                      ),
                    ),
                  ),
                )
              else
                ...(controller.wakeupApplications.toList()
                ..sort((a, b) => b.up.compareTo(a.up)))
                .map((application) => [
                  WakeupItem(
                    title: cleanText(application.videoTitle),
                    content: cleanText(application.videoChannel),
                    leading: GestureDetector(
                      onTap: () => {
                        controller.launchYoutubeUrl(application.videoId)
                      },
                      child: DFAvatar(
                        type: DFAvatarType.classroom,
                        size: DFAvatarSize.large,
                        fill: DFAvatarFill.image,
                        image: Image.network(application.videoThumbnail),
                      ),
                    ),
                    trailing: Column(
                    children: [
                      Obx(() => WakeupVoteButton(
                        count: application.up,
                        isUpvote: true,
                        onPressed: () => controller.voteWakeupApplication(application.id, true),
                        isVoted: controller.wakeupVotes.any((vote) => vote.wakeupSongApplication.id == application.id && vote.upvote == true),
                      )),
                      const SizedBox(height: DFSpacing.spacing100),
                      Obx(() => WakeupVoteButton(
                        count: application.down,
                        isUpvote: false,
                        onPressed: () => controller.voteWakeupApplication(application.id, false),
                        isVoted: controller.wakeupVotes.any((vote) => vote.wakeupSongApplication.id == application.id && vote.upvote == false),
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                const DFDivider(
                  size: DFDividerSize.small,
                ),
                const SizedBox(height: 5),
              ]).expand((element) => element).toList(),
            ],
          )),
        )
      )
    );
  }
}

class WakeupVoteButton extends StatelessWidget {
  final int count;
  final bool isUpvote;
  final bool isVoted;
  final VoidCallback? onPressed;

  const WakeupVoteButton({
    super.key,
    required this.count,
    required this.isUpvote,
    required this.isVoted,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        padding: const EdgeInsets.symmetric(
          horizontal: DFSpacing.spacing200,
          vertical: DFSpacing.spacing50,
        ),
        decoration: BoxDecoration(
          color: colorTheme.componentsFillStandardPrimary,
          borderRadius: BorderRadius.circular(DFRadius.radius400),
          border: Border.all(
            color: isVoted ? colorTheme.coreBrandPrimary : colorTheme.lineOutline,
            width: isVoted ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "$count",
              style: textTheme.callout.copyWith(
                color: colorTheme.contentStandardPrimary,
              ),
            ),
            const SizedBox(width: DFSpacing.spacing200),
            Icon(
              isUpvote ? Icons.thumb_up : Icons.thumb_down,
              size: 16,
              color: colorTheme.contentStandardPrimary,
            ),
          ],
        ),
      ),
    );
  }
}