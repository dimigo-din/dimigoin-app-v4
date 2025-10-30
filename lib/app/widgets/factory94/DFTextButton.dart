import 'package:dimigoin_app_v4/app/widgets/gestureDetector.dart';
import 'package:flutter/material.dart';
import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';

enum DFTextButtonSize { small, medium, large }
enum DFTextButtonTheme { grayscale, accent, negative }

class DFTextButton extends StatelessWidget {
  final DFTextButtonSize size;
  final DFTextButtonTheme theme;
  final bool disabled;
  final String label;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onPressed;

  const DFTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.size = DFTextButtonSize.medium,
    this.theme = DFTextButtonTheme.accent,
    this.disabled = false,
    this.leading,
    this.trailing,
  });

  double get itemPadding {
    switch (size) {
      case DFTextButtonSize.small:
        return DFSpacing.spacing100;
      case DFTextButtonSize.medium:
        return DFSpacing.spacing150;
      case DFTextButtonSize.large:
        return DFSpacing.spacing200;
    }
  }

  double get radius {
    switch (size) {
      case DFTextButtonSize.small:
        return DFRadius.radius300;
      case DFTextButtonSize.medium:
        return DFRadius.radius400;
      case DFTextButtonSize.large:
        return DFRadius.radius400;
    }
  }

  double get widgetSize {
    switch (size) {
      case DFTextButtonSize.small:
        return 16;
      case DFTextButtonSize.medium:
        return 20;
      case DFTextButtonSize.large:
        return 24;
    }
  }

  TextStyle getTextStyle(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    final textStyle;

    switch (size) {
      case DFTextButtonSize.small:
        textStyle = textTheme.footnote;
      case DFTextButtonSize.medium:
        textStyle = textTheme.callout;
      case DFTextButtonSize.large:
        textStyle = textTheme.body;
    }

    switch (theme) {
      case DFTextButtonTheme.grayscale:
        return textStyle.copyWith(
                color: colorTheme.contentStandardPrimary,
                fontWeight: FontWeight.w400,
              );
      case DFTextButtonTheme.accent:
        return textStyle.copyWith(
                color: colorTheme.coreBrandPrimary,
                fontWeight: FontWeight.w400,
              );
      case DFTextButtonTheme.negative:
        return textStyle.copyWith(
                color: colorTheme.solidPink,
                fontWeight: FontWeight.w400,
              );
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