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
    return DFValueList(
      type: DFValueListType.vertical,
      theme: DFValueListTheme.outlined,
      title: report.objectName,
      content: report.lastSeenPlace,
      onTap: onTap,
      header: Wrap(
        spacing: DFSpacing.spacing200,
        runSpacing: DFSpacing.spacing100,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          LostfoundReportStatusBadge(report: report),
          Text(
            formatLostfoundDate(report.createdAt),
            style: typography.footnote.copyWith(
              color: colors.contentStandardTertiary,
            ),
          ),
        ],
      ),
      trailing: thumbnail == null
          ? null
          : DFNetworkImage(url: thumbnail, width: 56, height: 56),
    );
  }
}
