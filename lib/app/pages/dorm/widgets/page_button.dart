import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/widgets/gestureDetector.dart';
import 'package:flutter/material.dart';

class PageButtonWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const PageButtonWidget({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, ) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return DFGestureDetectorWithOpacityInteraction(
      onTap: () {},
      child: DFGestureDetectorWithScaleInteraction(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: colorTheme.componentsFillStandardPrimary,
            borderRadius: BorderRadius.circular(DFRadius.radius400),
            border: Border.all(
              color: colorTheme.lineOutline,
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: DFSpacing.spacing900,
              horizontal: DFSpacing.spacing300,
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    icon,
                    color: colorTheme.coreBrandPrimary),
                  Text(
                    title,
                    style: textTheme.callout.copyWith(color: colorTheme.coreBrandPrimary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}