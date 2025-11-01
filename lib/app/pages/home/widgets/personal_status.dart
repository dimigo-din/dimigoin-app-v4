import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/pages/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PersonalStatusWidget extends GetView<HomePageController> {
  const PersonalStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;
    
    return Container(
      padding: const EdgeInsets.all(DFSpacing.spacing400),
      decoration: BoxDecoration(
        color: colorTheme.componentsFillStandardPrimary,
        borderRadius: BorderRadius.circular(DFRadius.radius800),
        border: Border.all(
          color: colorTheme.lineOutline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '내 신청',
            style: textTheme.caption.copyWith(
              color: colorTheme.contentStandardSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: DFSpacing.spacing400),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '내 좌석',
                        style: textTheme.callout.copyWith(
                          color: colorTheme.contentStandardSecondary,
                        ),
                      ),
                      Obx(() => Text(
                        controller.stayApply.value?.staySeat ?? '없음',
                        style: textTheme.headline.copyWith(
                          color: controller.stayApply.value != null ? colorTheme.coreBrandPrimary : colorTheme.coreBrandSecondary,
                        ),
                      )),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '외출',
                        style: textTheme.callout.copyWith(
                          color: colorTheme.contentStandardSecondary,
                        ),
                      ),
                      Obx(() {
                        final now = DateTime.now();
                        final outings = controller.stayApply.value?.outing;

                        if (outings == null || outings.isEmpty) {
                          return Text(
                            "없음",
                            style: textTheme.headline.copyWith(
                              color: colorTheme.coreBrandSecondary,
                            ),
                          );
                        }
                        
                        final upcomingOutings = outings
                          .where((outing) {
                            if (outing.from == null) return false;
                            try {
                              return DateTime.parse(outing.from!).isAfter(now);
                            } catch (e) {
                              return false;
                            }
                          })
                          .toList()
                        ..sort((a, b) {
                          try {
                            return DateTime.parse(a.from!).compareTo(DateTime.parse(b.from!));
                          } catch (e) {
                            return 0;
                          }
                        });

                        return Text(
                          upcomingOutings.isEmpty ? '없음' : DateFormat.Hm().format(DateTime.parse(upcomingOutings.first.from!).toLocal()),
                          style: textTheme.headline.copyWith(
                            color: upcomingOutings.isEmpty ? colorTheme.coreBrandSecondary : colorTheme.coreBrandPrimary,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '세탁',
                        style: textTheme.callout.copyWith(
                          color: colorTheme.contentStandardSecondary,
                        ),
                      ),
                      Obx(() => Text(
                        controller.laundryApply.value?.laundryTime.time ?? '없음',
                        style: textTheme.headline.copyWith(
                          color: controller.laundryApply.value != null ? colorTheme.coreBrandPrimary : colorTheme.coreBrandSecondary,
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}