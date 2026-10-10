import 'package:dimigoin_app_v4/app/services/lostfound/model.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFBadge.dart';
import 'package:flutter/material.dart';

class LostfoundReportStatusBadge extends StatelessWidget {
  final LostfoundReport report;

  const LostfoundReportStatusBadge({super.key, required this.report});

  @override
  Widget build(BuildContext context) => DFBadge(
    type: DFBadgeType.normal,
    size: DFBadgeSize.small,
    theme: !report.isConcluded && report.status == LostfoundStatus.lost
        ? DFBadgeTheme.negative
        : !report.isConcluded && report.status == LostfoundStatus.pickup
        ? DFBadgeTheme.solid
        : DFBadgeTheme.grayscale,
    label: report.isConcluded
        ? '회수됨'
        : report.status == LostfoundStatus.lost
        ? '분실'
        : '습득',
  );
}
