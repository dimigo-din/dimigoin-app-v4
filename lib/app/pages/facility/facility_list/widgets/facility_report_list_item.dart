import 'package:dimigoin_app_v4/app/services/facility/model.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFList.dart';
import 'package:flutter/material.dart';

class FacilityReportListItem extends StatelessWidget {
  final ReportFacility report;
  final VoidCallback onTap;

  const FacilityReportListItem({
    super.key,
    required this.report,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DFValueList(
        type: DFValueListType.horizontal,
        theme: DFValueListTheme.outlined,
        title: report.subject,
        content: switch (report.status) {
          'under_review' => '검토중',
          'working' => '처리중',
          'done' => '완료',
          'ignored' => '거절됨',
          'failed' => '수리실패',
          _ => '대기',
        },
      ),
    );
  }
}
