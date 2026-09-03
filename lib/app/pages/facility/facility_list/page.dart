import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/pages/facility/controller.dart';
import 'package:dimigoin_app_v4/app/services/facility/state.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFButton.dart';
import 'package:dimigoin_app_v4/app/widgets/shimmer_loading_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/facility_report_list_item.dart';

class FacilityListPage extends GetView<FacilityPageController> {
  const FacilityListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: DFSpacing.spacing300,
          bottom: DFSpacing.spacing500,
        ),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                final state = controller.facilityService.facilityState;

                if (state is FacilityListInitial ||
                    state is FacilityListLoading) {
                  return const Align(
                    alignment: Alignment.topCenter,
                    child: DFShimmerLoadingBox(height: 60),
                  );
                }

                if (state is FacilityListFailure) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '수리 신청 내역을 불러오지 못했습니다.',
                          style: textTheme.body.copyWith(
                            color: colorTheme.contentStandardSecondary,
                          ),
                        ),
                        const SizedBox(height: DFSpacing.spacing300),
                        DFButton(
                          label: '다시 불러오기',
                          size: DFButtonSize.small,
                          theme: DFButtonTheme.grayscale,
                          style: DFButtonStyle.secondary,
                          onPressed: controller.fetchReports,
                        ),
                      ],
                    ),
                  );
                }

                if (controller.reports.isEmpty) {
                  return Center(
                    child: Text(
                      '접수된 수리 신청이 없습니다.',
                      style: textTheme.body.copyWith(
                        color: colorTheme.contentStandardSecondary,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  color: colorTheme.coreBrandPrimary,
                  onRefresh: () async {
                    await controller.fetchReports(showError: false);
                  },
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: controller.reports.length,
                    separatorBuilder: (_, _) => const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: DFSpacing.spacing200,
                      ),
                    ),
                    itemBuilder: (_, index) => FacilityReportListItem(
                      onTap: () => controller.openReportDetail(
                        controller.reports[index],
                      ),
                      report: controller.reports[index],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
