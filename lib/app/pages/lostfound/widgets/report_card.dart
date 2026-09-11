import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/services/lostfound/model.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFBadge.dart';
import 'package:flutter/material.dart';
import '../utils/lostfound_format.dart';

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
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;
    final thumbnail = report.img.isNotEmpty ? report.img.first.url : null;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(DFSpacing.spacing400),
        decoration: BoxDecoration(
          color: colorTheme.backgroundStandardPrimary,
          borderRadius: BorderRadius.circular(DFRadius.radius500),
          border: Border.all(color: colorTheme.lineOutline),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      DFBadge(
                        type: DFBadgeType.normal,
                        size: DFBadgeSize.small,
                        // 분실 제보만 강조하고, 회수된 제보는 뉴트럴로 톤다운합니다.
                        theme: report.isConcluded == false
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
                  const SizedBox(height: DFSpacing.spacing200),
                  Text(
                    report.objectName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.headline.copyWith(
                      color: colorTheme.contentStandardPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: DFSpacing.spacing100),
                  Text(
                    report.lastSeenPlace,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.footnote.copyWith(
                      color: colorTheme.contentStandardSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (thumbnail != null) ...[
              const SizedBox(width: DFSpacing.spacing300),
              ClipRRect(
                borderRadius: BorderRadius.circular(DFRadius.radius300),
                child: Image.network(
                  thumbnail,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 56,
                    height: 56,
                    color: colorTheme.backgroundStandardSecondary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
