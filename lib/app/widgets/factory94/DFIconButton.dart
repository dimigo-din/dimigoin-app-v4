import 'package:dimigoin_app_v4/app/widgets/gestureDetector.dart';
import 'package:flutter/material.dart';
import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';

import 'DFBadge.dart';

enum DFIconButtonSize { small, large }
enum DFIconButtonTheme { grayscale, accent, solid, outlined, badged, badgedText }

class DFIconButton extends StatelessWidget {
  final DFIconButtonSize size;
  final DFIconButtonTheme theme;
  final bool disabled;
  final String? badge;
  final Widget? icon;
  final VoidCallback? onPressed;

  const DFIconButton({
    super.key,
    this.onPressed,
    this.size = DFIconButtonSize.large,
    this.theme = DFIconButtonTheme.accent,
    this.disabled = false,
    this.badge,
    required this.icon,
  });

  double get horizontalPadding {
    switch (size) {
      case DFIconButtonSize.small:
        return DFSpacing.spacing150;
      case DFIconButtonSize.large:
        return DFSpacing.spacing150;
    }
  }

  double get verticalPadding {
    switch (size) {
      case DFIconButtonSize.small:
        return DFSpacing.spacing150;
      case DFIconButtonSize.large:
        return DFSpacing.spacing150;
    }
  }

  double get radius {
    switch (size) {
      case DFIconButtonSize.small:
        return DFRadius.radius600;
      case DFIconButtonSize.large:
        return DFRadius.radius700;
    }
  }

  double get widgetSize {
    switch (size) {
      case DFIconButtonSize.small:
        return 20;
      case DFIconButtonSize.large:
        return 24;
    }
  }

  Color getIconStyle(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    
    switch (theme) {
      case DFIconButtonTheme.outlined:
        return colorTheme.contentStandardPrimary;
      case DFIconButtonTheme.grayscale:
        return colorTheme.contentStandardPrimary;
      case DFIconButtonTheme.accent:
        return colorTheme.solidWhite;
      case DFIconButtonTheme.solid:
        return colorTheme.solidWhite;
      case DFIconButtonTheme.badged:
        return colorTheme.contentStandardPrimary;
      case DFIconButtonTheme.badgedText:
        return colorTheme.contentStandardPrimary;
    }
  }

  Color? getBackgroundColor(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    switch (theme) {
      case DFIconButtonTheme.outlined:
        return colorTheme.componentsFillStandardPrimary;
      case DFIconButtonTheme.grayscale:
        return colorTheme.componentsTranslucentSecondary;
      case DFIconButtonTheme.accent:
        return colorTheme.coreBrandPrimary;
      case DFIconButtonTheme.solid:
        return colorTheme.solidBlue;
      case DFIconButtonTheme.badged:
        return Colors.transparent;
      case DFIconButtonTheme.badgedText:
        return Colors.transparent;
    }
  }

  Widget buildLeading(BuildContext context) {
    final l = icon;

    if (l is Icon) {
      return Icon(l.icon, size: widgetSize, color: getIconStyle(context));
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
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                decoration: BoxDecoration(
                  color: getBackgroundColor(context),
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: SizedBox(
                  width: widgetSize,
                  height: widgetSize,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: buildLeading(context),
                  ),
                ),
              ),

              if (theme == DFIconButtonTheme.badged || theme == DFIconButtonTheme.badgedText)
                Positioned(
                  top: theme == DFIconButtonTheme.badged ? -DFSpacing.spacing50 : -DFSpacing.spacing150,
                  right: theme == DFIconButtonTheme.badged ? -DFSpacing.spacing50 : -DFSpacing.spacing150,
                  child: DFBadge(
                    type: theme == DFIconButtonTheme.badged ? DFBadgeType.circular : DFBadgeType.circularText,
                    label: badge ?? '',
                    theme: DFBadgeTheme.grayscale,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  
}