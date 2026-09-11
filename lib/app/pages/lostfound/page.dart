import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/widgets/appBar.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFButton.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFControl.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSegmentControl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'widgets/report_card.dart';

class LostfoundPage extends GetView<LostfoundPageController> {
  const LostfoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Container(
      decoration: BoxDecoration(color: colorTheme.backgroundStandardSecondary),
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: DFAppBar(title: '분실물 찾기'),
          body: Padding(
            padding: EdgeInsets.only(
              left: DFSpacing.spacing400,
              right: DFSpacing.spacing400,
              bottom: DFSpacing.spacing500,
            ),
            child: Obx(() {
              return Column(
                children: [
                  DFSegmentControl(
                    key: ValueKey(controller.segmentVersion.value),
                    initialIndex: controller.tab.value.index,
                    segments: const [
                      DFSegment(label: '분실물'),
                      DFSegment(label: '습득물'),
                    ],
                    onChanged: controller.changeTabByIndex,
                  ),
                  const SizedBox(height: DFSpacing.spacing200),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DFSpacing.spacing200,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.toggleMine();
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Row(
                            children: [
                              Obx(
                                () => DFControl(
                                  type: DFControlType.checkfill,
                                  status: controller.showMine.value,
                                ),
                              ),
                              const SizedBox(width: DFSpacing.spacing200),
                              Text(
                                "내 글 보기",
                                style: textTheme.callout.copyWith(
                                  color: colorTheme.contentStandardPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: DFSpacing.spacing500),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            controller.toggleConcluded();
                          },
                          child: Row(
                            children: [
                              Obx(
                                () => DFControl(
                                  type: DFControlType.checkfill,
                                  status: controller.showConcluded.value,
                                ),
                              ),
                              const SizedBox(width: DFSpacing.spacing200),
                              Text(
                                "회수됨 표시하기",
                                style: textTheme.callout.copyWith(
                                  color: colorTheme.contentStandardPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: DFSpacing.spacing300),
                  Expanded(child: _LostfoundList(controller: controller)),
                  const SizedBox(height: DFSpacing.spacing300),
                  SizedBox(
                    width: double.infinity,
                    child: DFButton(
                      label: switch (controller.tab.value) {
                        LostfoundTab.lost => '분실물 등록',
                        LostfoundTab.pickup => '습득물 등록',
                      },
                      size: DFButtonSize.large,
                      onPressed: controller.openReportForm,
                    ),
                  ),
                ],
              );
            }),
          ),
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
    return Obx(() => _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
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

    final reports = controller.reports.where((report) {
      return controller.showConcluded.value || !report.isConcluded;
    }).toList();

    if (reports.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) => RefreshIndicator(
          onRefresh: controller.loadReports,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: constraints.maxHeight,
                child: _CenteredMessage(message: _emptyMessage(controller)),
              ),
            ],
          ),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final nearEnd =
            notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 200;
        final contentDoesNotFillViewport =
            notification.metrics.maxScrollExtent <= 0;
        if (!controller.hasLoadMoreError &&
            (nearEnd || contentDoesNotFillViewport)) {
          controller.loadMore();
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: controller.loadReports,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: DFSpacing.spacing300),
          itemCount: reports.length + (controller.hasMore ? 1 : 0),
          separatorBuilder: (_, _) =>
              const SizedBox(height: DFSpacing.spacing300),
          itemBuilder: (context, index) {
            if (index >= reports.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: DFSpacing.spacing400,
                ),
                child: Center(
                  child: controller.isLoadingMore
                      ? const CircularProgressIndicator()
                      : DFButton(
                          label: controller.hasLoadMoreError ? '다시 시도' : '더 보기',
                          size: DFButtonSize.small,
                          theme: DFButtonTheme.grayscale,
                          style: DFButtonStyle.secondary,
                          onPressed: controller.loadMore,
                        ),
                ),
              );
            }

            final report = reports[index];
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
  return switch (controller.tab.value) {
    LostfoundTab.lost => '등록된 분실물이 없어요.',
    LostfoundTab.pickup => '등록된 습득물이 없어요.',
  };
}

class _CenteredMessage extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _CenteredMessage({
    required this.message,
    this.actionLabel,
    this.onAction,
  });

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
