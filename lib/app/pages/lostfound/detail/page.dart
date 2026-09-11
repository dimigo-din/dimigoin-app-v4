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
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class LostfoundDetailPage extends GetView<LostfoundDetailPageController> {
  const LostfoundDetailPage({super.key});

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
                Row(
                  children: [
                    DFBadge(
                      type: DFBadgeType.normal,
                      size: DFBadgeSize.small,
                      theme: report.status == LostfoundStatus.lost
                          ? DFBadgeTheme.negative
                          : DFBadgeTheme.grayscale,
                      label: report.isConcluded == false
                          ? report.status == LostfoundStatus.lost
                                ? '분실'
                                : '습득'
                          : '회수됨',
                    ),
                    const SizedBox(width: DFSpacing.spacing200),
                    Text(
                      formatLostfoundDate(report.createdAt),
                      style: textTheme.caption.copyWith(
                        color: colorTheme.contentStandardTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DFSpacing.spacing300),
                Text(
                  report.objectName,
                  style: textTheme.title.copyWith(
                    color: colorTheme.contentStandardPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: DFSpacing.spacing200),
                _LabeledRow(label: '마지막 위치', value: report.lastSeenPlace),
                if (report.user?.name != null) ...[
                  const SizedBox(height: DFSpacing.spacing100),
                  _LabeledRow(label: '작성자', value: report.user!.name!),
                ],
                const SizedBox(height: DFSpacing.spacing400),
                Text(
                  report.body,
                  style: textTheme.body.copyWith(
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
                Text(
                  '댓글 ${report.comment?.length}',
                  style: textTheme.headline.copyWith(
                    color: colorTheme.contentStandardPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: DFSpacing.spacing300),
                if (report.comment!.isEmpty)
                  Text(
                    '아직 댓글이 없어요.',
                    style: textTheme.footnote.copyWith(
                      color: colorTheme.contentStandardTertiary,
                    ),
                  )
                else
                  ...report.comment!.map(
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
            DFSpacing.spacing300,
          ),
          child: Row(
            children: [
              Expanded(
                child: DFInput(
                  controller: controller.commentTEC,
                  placeholder:
                      controller.isMine || report.status == LostfoundStatus.lost
                      ? '댓글을 입력하세요'
                      : '물건을 주웠다면 댓글로 알려주세요',
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
  final colorTheme = Theme.of(context).extension<DFColors>()!;
  final textTheme = Theme.of(context).extension<DFTypography>()!;

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
            Text(
              '물건을 찾으셨나요?\n회수로 표시하면 되돌릴 수 없습니다.',
              style: textTheme.callout.copyWith(
                color: colorTheme.contentStandardPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
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
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, _) => const SizedBox(width: DFSpacing.spacing200),
        itemBuilder: (context, index) => ClipRRect(
          borderRadius: BorderRadius.circular(DFRadius.radius300),
          child: Image.network(
            images[index].url,
            width: 160,
            height: 160,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              width: 160,
              height: 160,
              color: colorTheme.backgroundStandardSecondary,
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
      padding: const EdgeInsets.all(DFSpacing.spacing300),
      decoration: BoxDecoration(
        color: colorTheme.backgroundStandardPrimary,
        borderRadius: BorderRadius.circular(DFRadius.radius300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (comment.user?.name != null) ...[
                Flexible(
                  child: Text(
                    comment.user!.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.footnote.copyWith(
                      color: colorTheme.contentStandardPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: DFSpacing.spacing200),
              ],
              if (isByPoster) ...[
                const DFBadge(
                  type: DFBadgeType.normal,
                  size: DFBadgeSize.small,
                  theme: DFBadgeTheme.grayscale,
                  label: '작성자',
                ),
                const SizedBox(width: DFSpacing.spacing200),
              ],
              Text(
                formatLostfoundDate(comment.createdAt),
                style: textTheme.caption.copyWith(
                  color: colorTheme.contentStandardTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: DFSpacing.spacing100),
          Text(
            comment.text,
            style: textTheme.footnote.copyWith(
              color: colorTheme.contentStandardPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
