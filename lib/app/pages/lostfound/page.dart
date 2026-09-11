import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFButton.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSegmentControl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'widgets/report_card.dart';

class LostfoundPage extends GetView<LostfoundPageController> {
  const LostfoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: DFSpacing.spacing400),
        child: GetBuilder<LostfoundPageController>(
          builder: (controller) {
            return Column(
              children: [
                DFSegmentControl(
                  key: ValueKey(controller.segmentVersion),
                  initialIndex: controller.tab.index,
                  segments: const [
                    DFSegment(label: '전체'),
                    DFSegment(label: '내 분실물'),
                    DFSegment(label: '회수'),
                  ],
                  onChanged: controller.changeTabByIndex,
                ),
                const SizedBox(height: DFSpacing.spacing300),
                Expanded(child: _LostfoundList(controller: controller)),
                const SizedBox(height: DFSpacing.spacing300),
                SizedBox(
                  width: double.infinity,
                  child: DFButton(
                    label: '분실물 등록하기',
                    size: DFButtonSize.large,
                    onPressed: controller.openReportForm,
                  ),
                ),
                const SizedBox(height: DFSpacing.spacing300),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LostfoundList extends StatelessWidget {
  final LostfoundPageController controller;

  const _LostfoundList({required this.controller});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).extension<DFTypography>()!;
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.loadError != null) {
      return _CenteredMessage(
        message: controller.loadError!,
        actionLabel: '다시 시도',
        onAction: controller.loadReports,
      );
    }

    if (controller.reports.isEmpty) {
      return _CenteredMessage(message: _emptyMessage(controller));
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 200) {
          controller.loadMore();
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: controller.loadReports,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: DFSpacing.spacing300),
          itemCount: controller.reports.length + (controller.hasMore ? 1 : 0),
          separatorBuilder: (_, _) =>
              const SizedBox(height: DFSpacing.spacing300),
          itemBuilder: (context, index) {
            if (index >= controller.reports.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: DFSpacing.spacing400,
                ),
                child: Center(
                  child: controller.isLoadingMore
                      ? const CircularProgressIndicator()
                      : Text(
                          '불러오는 중...',
                          style: textTheme.footnote.copyWith(
                            color: colorTheme.contentStandardTertiary,
                          ),
                        ),
                ),
              );
            }

            final report = controller.reports[index];
            return LostfoundReportCard(
              report: report,
              onTap: () => controller.openReport(report.id),
            );
          },
        ),
      ),
    );
  }
}


String _emptyMessage(LostfoundPageController controller) {
  return switch (controller.tab) {
    LostfoundTab.all => '다른 친구들이 찾고 있는 물건이 없어요.',
    LostfoundTab.myReports => '내가 등록한 분실물이 없어요.',
    LostfoundTab.found => '아직 회수된 물건이 없어요.',
  };
}

class _CenteredMessage extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _CenteredMessage({required this.message, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).extension<DFTypography>()!;
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: textTheme.body.copyWith(
              color: colorTheme.contentStandardTertiary,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: DFSpacing.spacing300),
            DFButton(
              label: actionLabel!,
              size: DFButtonSize.small,
              theme: DFButtonTheme.grayscale,
              style: DFButtonStyle.secondary,
              onPressed: onAction,
            ),
          ],
        ],
      ),
    );
  }
}
