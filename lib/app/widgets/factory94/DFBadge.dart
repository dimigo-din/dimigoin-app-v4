import 'package:flutter/material.dart';
import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';

enum DFBadgeType { normal, circular, circularText }
enum DFBadgeSize { small, large }
enum DFBadgeTheme { grayscale, accent, negative, solid }
enum DFBadgeStyle { primary, secondary }

class DFBadge extends StatelessWidget {
  final DFBadgeType type;
  final DFBadgeSize size;
  final DFBadgeTheme theme;
  final DFBadgeStyle style;
  final String label;
  final Widget? leading;

  const DFBadge({
    super.key,
    required this.type,
    required this.label,
    this.size = DFBadgeSize.large,
    this.theme = DFBadgeTheme.accent,
    this.style = DFBadgeStyle.primary,
    this.leading,
  });

  double get horizontalPadding {
    switch (size) {
      case DFBadgeSize.small:
        return DFSpacing.spacing100;
      case DFBadgeSize.large:
        return DFSpacing.spacing150;
    }
  }

  double get verticalPadding {
    switch (size) {
      case DFBadgeSize.small:
        return DFSpacing.spacing50;
      case DFBadgeSize.large:
        return DFSpacing.spacing50;
    }
  }

  double get itemPadding {
    switch (size) {
      case DFBadgeSize.small:
        return DFSpacing.spacing50;
      case DFBadgeSize.large:
        return DFSpacing.spacing100;
    }
  }

  double get radius {
    switch (size) {
      case DFBadgeSize.small:
        return DFRadius.radius100;
      case DFBadgeSize.large:
        return DFRadius.radius200;
    }
  }

  double get widgetSize {
    switch (size) {
      case DFBadgeSize.small:
        return 12;
      case DFBadgeSize.large:
        return 16;
    }
  }

  TextStyle getTextStyle(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;
    
    switch (theme) {
      case DFBadgeTheme.grayscale:
        return textTheme.body.copyWith(
                color: colorTheme.contentStandardSecondary,
                fontWeight: FontWeight.w400,
              );
      case DFBadgeTheme.accent:
        return textTheme.body.copyWith(
                color: colorTheme.coreBrandPrimary,
                fontWeight: FontWeight.w400,
              );
      case DFBadgeTheme.negative:
        return textTheme.body.copyWith(
                color: colorTheme.coreStatusNegative,
                fontWeight: FontWeight.w400,
              );
      case DFBadgeTheme.solid:
        return textTheme.body.copyWith(
                color: colorTheme.solidBlue,
                fontWeight: FontWeight.w400,
              );
    }
  }

  Color getBackgroundColor(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    if (type == DFBadgeType.circular) {
      switch (theme) {
        case DFBadgeTheme.grayscale:
          return colorTheme.componentsFillInvertedPrimary;
        case DFBadgeTheme.accent:
          return colorTheme.coreBrandPrimary;
        case DFBadgeTheme.negative:
          return colorTheme.coreStatusNegative;
        case DFBadgeTheme.solid:
          return colorTheme.solidBlue;
      }
    }

    switch (theme) {
      case DFBadgeTheme.grayscale:
        return colorTheme.componentsTranslucentSecondary;
      case DFBadgeTheme.accent:
        return colorTheme.coreBrandTertiary;
      case DFBadgeTheme.negative:
        return colorTheme.solidTranslucentRed;
      case DFBadgeTheme.solid:
        return colorTheme.solidTranslucentBlue;
    }
  }

  Widget buildLeading(BuildContext context) {
    final l = leading;

    if (l is Icon) {
      return Icon(l.icon, size: widgetSize, color: getTextStyle(context).color);
    } else {
      return l ?? const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case DFBadgeType.normal:
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: getBackgroundColor(context),
            borderRadius: BorderRadius.circular(radius),
          ),
          constraints: const BoxConstraints(minWidth: 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading != null) ...[
                SizedBox(
                  width: widgetSize,
                  height: widgetSize,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: buildLeading(context),
                  ),
                ),
                SizedBox(width: itemPadding),
              ],
              Text(
                label,
                style: getTextStyle(context),
              ),
            ],
          ),
        );

      case DFBadgeType.circular:
        return Container(
          width: size == DFBadgeSize.small ? 4 : 6,
          height: size == DFBadgeSize.small ? 4 : 6,
          decoration: BoxDecoration(
            color: getBackgroundColor(context),
            shape: BoxShape.circle,
          ),
        );

      case DFBadgeType.circularText:
        return Container(
          width: size == DFBadgeSize.small ? 16 : 20,
          height: size == DFBadgeSize.small ? 16 : 20,
          decoration: BoxDecoration(
            color: getBackgroundColor(context),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: getTextStyle(context),
              textHeightBehavior: const TextHeightBehavior(
                applyHeightToFirstAscent: false,
                applyHeightToLastDescent: false,
              ),
            ),
          ),
        );
    }
  }
}