import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/pages/lostfound/utils/lostfound_format.dart';
import 'package:dimigoin_app_v4/app/services/lostfound/model.dart';
import 'package:dimigoin_app_v4/app/widgets/appBar.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFAnimatedBottomSheet.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFBadge.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFButton.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFDivider.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFInputField.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFHeader.dart';
import 'package:dimigoin_app_v4/app/widgets/image_bottom_sheet.dart';
import 'package:dimigoin_app_v4/app/widgets/network_image.dart';
import '../widgets/report_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class LostfoundDetailPage extends GetView<LostfoundDetailPageController> {
  LostfoundDetailPage({super.key})
    : _reportId = LostfoundDetailPageController.reportIdFromRoute;

  final String _reportId;

  @override
  String get tag => _reportId;

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return Container(
      decoration: BoxDecoration(color: colorTheme.backgroundStandardSecondary),
      child: SafeArea(
        top: false,
        child: Obx(() {
          return Scaffold(
            appBar: const DFAppBar(title: '분실물 제보'),
            body: _buildBody(context, controller),
          );
        }),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    LostfoundDetailPageController controller,
  ) {
    final textTheme = Theme.of(context).extension<DFTypography>()!;
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final report = controller.report;
    if (controller.loadError != null || report == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              controller.loadError ?? '제보를 불러오지 못했습니다.',
              style: textTheme.body.copyWith(
                color: colorTheme.contentStandardTertiary,
              ),
            ),
            const SizedBox(height: DFSpacing.spacing300),
            DFButton(
              label: '다시 시도',
              size: DFButtonSize.small,
              theme: DFButtonTheme.grayscale,
              style: DFButtonStyle.secondary,
              onPressed: controller.loadReport,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(
              DFSpacing.spacing400,
              DFSpacing.spacing400,
              DFSpacing.spacing400,
              DFSpacing.spacing300,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: DFSpacing.spacing200,
                  runSpacing: DFSpacing.spacing100,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    LostfoundReportStatusBadge(report: report),
                    Text(
                      formatLostfoundDate(report.createdAt),
                      style: textTheme.footnote.copyWith(
                        color: colorTheme.contentStandardTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DFSpacing.spacing300),
                DFHeader(title: report.objectName),
                const SizedBox(height: DFSpacing.spacing200),
                _LabeledRow(label: '마지막 위치', value: report.lastSeenPlace),
                if (report.user?.name != null) ...[
                  const SizedBox(height: DFSpacing.spacing100),
                  _LabeledRow(label: '작성자', value: report.user!.name!),
                ],
                const SizedBox(height: DFSpacing.spacing400),
                Text(
                  report.body,
                  style: textTheme.paragraphLarge.copyWith(
                    color: colorTheme.contentStandardPrimary,
                  ),
                ),
                if (report.img.isNotEmpty) ...[
                  const SizedBox(height: DFSpacing.spacing400),
                  _ImageStrip(images: report.img),
                ],
                if (controller.canMarkFound) ...[
                  const SizedBox(height: DFSpacing.spacing400),
                  SizedBox(
                    width: double.infinity,
                    child: DFButton(
                      label: controller.isMarkingFound.value
                          ? '처리 중...'
                          : '찾았어요',
                      size: DFButtonSize.medium,
                      theme: DFButtonTheme.accent,
                      style: DFButtonStyle.secondary,
                      disabled: controller.isBusy,
                      onPressed: controller.isBusy
                          ? null
                          : () => _confirmMarkFound(context, controller),
                    ),
                  ),
                ],
                const SizedBox(height: DFSpacing.spacing500),
                const DFDivider(),
                const SizedBox(height: DFSpacing.spacing400),
                DFSectionHeader(
                  size: DFSectionHeaderSize.medium,
                  title: '댓글 ${report.comment?.length ?? 0}',
                ),
                const SizedBox(height: DFSpacing.spacing300),
                if ((report.comment ?? const <LostfoundComment>[]).isEmpty)
                  Text(
                    '아직 댓글이 없어요.',
                    style: textTheme.footnote.copyWith(
                      color: colorTheme.contentStandardTertiary,
                    ),
                  )
                else
                  ...(report.comment ?? const <LostfoundComment>[]).map(
                    (comment) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: DFSpacing.spacing300,
                      ),
                      child: _CommentTile(
                        comment: comment,
                        isByPoster: comment.userId == report.userId,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            DFSpacing.spacing400,
            0,
            DFSpacing.spacing400,
            DFSpacing.spacing500,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: DFInput(
                  controller: controller.commentTEC,
                  minLines: 1,
                  maxLines: 4,
                  placeholder:
                      controller.isMine || report.status == LostfoundStatus.lost
                      ? '댓글을 입력하세요'
                      : '내 물건이라면 댓글로 알려주세요',
                ),
              ),
              const SizedBox(width: DFSpacing.spacing200),
              DFButton(
                label: controller.isSubmittingComment.value ? '등록 중' : '등록',
                size: DFButtonSize.medium,
                disabled: controller.isBusy,
                onPressed: controller.isBusy ? null : controller.submitComment,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void _confirmMarkFound(
  BuildContext context,
  LostfoundDetailPageController controller,
) {
  DFAnimatedBottomSheet.show(
    context: context,
    children: [
      Padding(
        padding: const EdgeInsets.only(
          left: DFSpacing.spacing500,
          right: DFSpacing.spacing500,
          bottom: DFSpacing.spacing550,
        ),
        child: Column(
          children: [
            const DFHeader(
              title: '물건을 찾으셨나요?',
              content: '회수로 표시하면 되돌릴 수 없습니다.',
            ),
            const SizedBox(height: DFSpacing.spacing500),
            SizedBox(
              width: double.infinity,
              child: DFButton(
                label: '찾았어요',
                theme: DFButtonTheme.accent,
                size: DFButtonSize.large,
                onPressed: () {
                  Navigator.pop(context);
                  controller.markFound();
                },
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _LabeledRow extends StatelessWidget {
  final String label;
  final String value;

  const _LabeledRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).extension<DFTypography>()!;
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.footnote.copyWith(
            color: colorTheme.contentStandardTertiary,
          ),
        ),
        const SizedBox(width: DFSpacing.spacing200),
        Expanded(
          child: Text(
            value,
            style: textTheme.footnote.copyWith(
              color: colorTheme.contentStandardSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _ImageStrip extends StatelessWidget {
  final List<LostfoundImg> images;

  const _ImageStrip({required this.images});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, _) => const SizedBox(width: DFSpacing.spacing200),
        itemBuilder: (context, index) => Semantics(
          button: true,
          label: '사진 ${index + 1} 크게 보기',
          child: InkWell(
            borderRadius: BorderRadius.circular(DFRadius.radius300),
            onTap: () => DFImageBottomSheet.show(
              context: context,
              url: images[index].url,
            ),
            child: DFNetworkImage(
              url: images[index].url,
              width: 160,
              height: 160,
            ),
          ),
        ),
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final LostfoundComment comment;
  final bool isByPoster;

  const _CommentTile({required this.comment, required this.isByPoster});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).extension<DFTypography>()!;
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DFSpacing.spacing400),
      decoration: BoxDecoration(
        color: colorTheme.componentsFillStandardPrimary,
        borderRadius: BorderRadius.circular(DFRadius.radius400),
        border: Border.all(color: colorTheme.lineOutline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: DFSpacing.spacing200,
            runSpacing: DFSpacing.spacing100,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (comment.user?.name != null)
                Text(
                  comment.user!.name!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.callout.copyWith(
                    color: colorTheme.contentStandardPrimary,
                  ),
                ),
              if (isByPoster)
                const DFBadge(
                  type: DFBadgeType.normal,
                  size: DFBadgeSize.small,
                  theme: DFBadgeTheme.grayscale,
                  label: '작성자',
                ),
              Text(
                formatLostfoundDate(comment.createdAt),
                style: textTheme.footnote.copyWith(
                  color: colorTheme.contentStandardTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: DFSpacing.spacing100),
          Text(
            comment.text,
            style: textTheme.paragraphSmall.copyWith(
              color: colorTheme.contentStandardPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
