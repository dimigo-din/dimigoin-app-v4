import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/services/wakeup/model.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFAnimatedBottomSheet.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFAvatar.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFDivider.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFInputField.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFList.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFbutton.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:get/get.dart';

import 'controller.dart';
import '../widgets/WakeupItem.dart';

class WakeupApplyPage extends GetView<WakeupApplyPageController> {
  const WakeupApplyPage({super.key});

  String cleanText(String text) {
    final unescape = HtmlUnescape();
    String cleaned = unescape.convert(text);
    
    cleaned = cleaned.replaceAll(RegExp(r'\([^\)]*\)'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\[[^\]]*\]'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\{[^\}]*\}'), '');
    
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    return cleaned;
  }

  void _showApplyBottomSheet(BuildContext context, YoutubeItem video) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    DFAnimatedBottomSheet.show(
      context: context,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 24,
          ),
          child: Column(
            children: [
              Text(
                "정말로 신청하시겠습니까?\n신청 후에는 수정 및 취소가 불가능합니다.",
                style: textTheme.callout.copyWith(
                  color: colorTheme.solidRed,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              DFItemList(
                title: cleanText(video.snippet.title),
                content: cleanText(video.snippet.channelTitle),
                leading: DFAvatar(
                  type: DFAvatarType.classroom,
                  size: DFAvatarSize.large,
                  fill: DFAvatarFill.image,
                  image: Image.network(video.snippet.thumbnails.high.url),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: DFButton(
                  label: "신청하기",
                  theme: DFButtonTheme.accent,
                  size: DFButtonSize.large,
                  onPressed: () {
                    controller.applyWakeupSong(context, video.id.videoId!);
                  },
                ),
              ),
            ]
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: DFSpacing.spacing500),
        child: Column(
          children: [
            DFInput(
              placeholder: "검색어를 입력하세요",
              type: DFInputType.focus,
              onChanged: (value) => controller.youtubeSearchQuery.value = value,
              onSubmit: (value) => controller.searchYoutubeVideo(),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Obx(() => Column(
                  children: [
                    ...(controller.youtubeSearchResults.toList())
                    .map((video) => [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque, 
                        onTap: () => _showApplyBottomSheet(context, video),
                        child: WakeupItem(
                          title: cleanText(video.snippet.title),
                          content: cleanText(video.snippet.channelTitle),
                          leading: DFAvatar(
                          type: DFAvatarType.classroom,
                          size: DFAvatarSize.large,
                          fill: DFAvatarFill.image,
                          image: Image.network(video.snippet.thumbnails.high.url),
                          ),
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
              ),
            ),
          ],
        ),
      )
    );
  }
}