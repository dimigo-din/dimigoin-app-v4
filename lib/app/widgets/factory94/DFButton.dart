import 'package:dimigoin_app_v4/app/widgets/gestureDetector.dart';
import 'package:flutter/material.dart';
import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';

enum DFButtonSize { small, medium, large }
enum DFButtonTheme { grayscale, accent, negative }
enum DFButtonStyle { primary, secondary }

class DFButton extends StatelessWidget {
  final DFButtonSize size;
  final DFButtonTheme theme;
  final DFButtonStyle style;
  final bool disabled;
  final String label;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onPressed;

  const DFButton({
    super.key,
    required this.label,
    this.onPressed,
    this.size = DFButtonSize.medium,
    this.theme = DFButtonTheme.accent,
    this.style = DFButtonStyle.primary,
    this.disabled = false,
    this.leading,
    this.trailing,
  });

  double get horizontalPadding {
    switch (size) {
      case DFButtonSize.small:
        return DFSpacing.spacing300;
      case DFButtonSize.medium:
        return DFSpacing.spacing400;
      case DFButtonSize.large:
        return DFSpacing.spacing500;
    }
  }

  double get verticalPadding {
    switch (size) {
      case DFButtonSize.small:
        return DFSpacing.spacing150;
      case DFButtonSize.medium:
        return DFSpacing.spacing300;
      case DFButtonSize.large:
        return DFSpacing.spacing400;
    }
  }

  double get itemPadding {
    switch (size) {
      case DFButtonSize.small:
        return DFSpacing.spacing100;
      case DFButtonSize.medium:
        return DFSpacing.spacing150;
      case DFButtonSize.large:
        return DFSpacing.spacing200;
    }
  }

  double get radius {
    switch (size) {
      case DFButtonSize.small:
        return DFRadius.radius300;
      case DFButtonSize.medium:
        return DFRadius.radius400;
      case DFButtonSize.large:
        return DFRadius.radius400;
    }
  }

  double get widgetSize {
    switch (size) {
      case DFButtonSize.small:
        return 16;
      case DFButtonSize.medium:
        return 20;
      case DFButtonSize.large:
        return 24;
    }
  }

  TextStyle getTextStyle(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;
    
    switch (theme) {
      case DFButtonTheme.grayscale:
        return style == DFButtonStyle.primary
            ? textTheme.body.copyWith(
                color: colorTheme.contentInvertedPrimary,
                fontWeight: FontWeight.w700,
              )
            : textTheme.body.copyWith(
                color: colorTheme.contentStandardPrimary,
                fontWeight: FontWeight.w700,
              );
      case DFButtonTheme.accent:
        return style == DFButtonStyle.primary
            ? textTheme.body.copyWith(
                color: colorTheme.solidWhite,
                fontWeight: FontWeight.w700,
              )
            : textTheme.body.copyWith(
                color: colorTheme.coreBrandPrimary,
                fontWeight: FontWeight.w700,
              );
      case DFButtonTheme.negative:
        return style == DFButtonStyle.primary
            ? textTheme.body.copyWith(
                color: colorTheme.contentInvertedPrimary,
                fontWeight: FontWeight.w700,
              )
            : textTheme.body.copyWith(
                color: colorTheme.solidPink,
                fontWeight: FontWeight.w700,
              );
    }
  }

  Color getBackgroundColor(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    switch (theme) {
      case DFButtonTheme.grayscale:
        return style == DFButtonStyle.primary
            ? colorTheme.componentsFillInvertedPrimary
            : colorTheme.componentsTranslucentSecondary;
      case DFButtonTheme.accent:
        return style == DFButtonStyle.primary
            ? colorTheme.coreBrandPrimary
            : colorTheme.coreBrandTertiary;
      case DFButtonTheme.negative:
        return style == DFButtonStyle.primary
            ? colorTheme.coreStatusNegative
            : colorTheme.solidTranslucentRed;
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
    return Opacity(
      opacity: disabled ? 0.3 : 1.0,
      child: DFGestureDetectorWithOpacityInteraction(
        onTap: () => {},
        child: DFGestureDetectorWithScaleInteraction(
          onTap: disabled ? null : onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            decoration: BoxDecoration(
              color: getBackgroundColor(context),
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
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
                Text(label, style: getTextStyle(context)),
                if (trailing != null) ...[
                  SizedBox(width: itemPadding),
                  SizedBox(
                    width: widgetSize,
                    height: widgetSize,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: buildLeading(context),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
  
}