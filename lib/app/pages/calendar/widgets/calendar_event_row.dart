import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:flutter/material.dart';

class CalendarEventRow extends StatelessWidget {
  final String title;
  final String day;
  final String weekday;
  final String content;

  const CalendarEventRow({
    super.key,
    required this.title,
    required this.day,
    required this.weekday,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DFSpacing.spacing500,
        vertical: DFSpacing.spacing400,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 25,
                child: Text(
                  day,
                  style: textTheme.callout.copyWith(
                    color: colorTheme.contentStandardTertiary,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 30,
                child: Text(
                  "($weekday)",
                  style: textTheme.callout.copyWith(
                    color: colorTheme.contentStandardTertiary,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: DFSpacing.spacing300),
              Expanded(
                child: Text(
                  title,
                  style: textTheme.body.copyWith(
                    color: colorTheme.contentStandardPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: DFSpacing.spacing300),
              Text(
                content,
                style: textTheme.callout.copyWith(
                  color: colorTheme.contentStandardTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
