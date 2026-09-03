import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/services/facility/model.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFAnimatedBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';

class FacilityDetailBottomSheet {
  static void show({
    required BuildContext context,
    required ReportFacility report,
  }) {
    final textTheme = Theme.of(context).extension<DFTypography>()!;
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    DFAnimatedBottomSheet.show(
      context: context,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            "제목",
            style: textTheme.callout.copyWith(
              color: colorTheme.contentStandardSecondary,
            ),
          ),
        ),
        const SizedBox(height: DFSpacing.spacing100),
        SizedBox(
          width: double.infinity,
          child: Text(
            report.subject,
            style: textTheme.body.copyWith(
              color: colorTheme.contentStandardPrimary,
            ),
          ),
        ),
        const SizedBox(height: DFSpacing.spacing300),
        SizedBox(
          width: double.infinity,
          child: Text(
            "내용",
            style: textTheme.callout.copyWith(
              color: colorTheme.contentStandardSecondary,
            ),
          ),
        ),
        const SizedBox(height: DFSpacing.spacing100),
        SizedBox(
          width: double.infinity,
          child: Text(
            report.body,
            style: textTheme.body.copyWith(
              color: colorTheme.contentStandardPrimary,
            ),
          ),
        ),
        const SizedBox(height: DFSpacing.spacing300),
        SizedBox(
          width: double.infinity,
          child: Text(
            "처리 상태",
            style: textTheme.callout.copyWith(
              color: colorTheme.contentStandardSecondary,
            ),
          ),
        ),
        const SizedBox(height: DFSpacing.spacing100),
        SizedBox(
          width: double.infinity,
          child: Text(
            switch (report.status) {
              'under_review' => '검토중',
              'working' => '처리중',
              'done' => '완료',
              'ignored' => '거절됨',
              'failed' => '수리실패',
              _ => '대기',
            },
            style: textTheme.body.copyWith(
              color: colorTheme.contentStandardPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
