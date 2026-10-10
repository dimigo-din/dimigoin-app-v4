import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/services/lostfound/model.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFList.dart';
import 'package:dimigoin_app_v4/app/widgets/network_image.dart';
import 'package:flutter/material.dart';
import '../utils/lostfound_format.dart';
import 'report_status_badge.dart';

class LostfoundReportCard extends StatelessWidget {
  final LostfoundReport report;
  final VoidCallback onTap;

  const LostfoundReportCard({
    super.key,
    required this.report,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<DFColors>()!;
    final typography = Theme.of(context).extension<DFTypography>()!;
    final thumbnail = report.img.isNotEmpty ? report.img.first.url : null;
    final date = formatLostfoundDate(report.createdAt, includeTime: false);
    return DFValueList(
      type: DFValueListType.vertical,
      theme: DFValueListTheme.outlined,
      title: report.objectName,
      titleMaxLines: 2,
      content: report.lastSeenPlace,
      contentMaxLines: 1,
      onTap: onTap,
      titleLeading: Padding(
        padding: const EdgeInsets.only(top: DFSpacing.spacing50),
        child: LostfoundReportStatusBadge(report: report),
      ),
      trailingAlignment: CrossAxisAlignment.end,
      trailing: SizedBox(
        width: 56,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (thumbnail != null) ...[
              DFNetworkImage(url: thumbnail, width: 48, height: 48),
              const SizedBox(height: DFSpacing.spacing100),
            ],
            Text(
              date.isEmpty ? '날짜 미상' : date,
              textAlign: TextAlign.end,
              style: typography.footnote.copyWith(
                color: colors.contentStandardTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
