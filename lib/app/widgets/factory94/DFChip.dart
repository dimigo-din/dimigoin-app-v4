import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';

enum DFChipTheme { grayscale, accent, solid, outlined }

class DFChip extends StatelessWidget {
  final String label;
  final bool status;
  final DFChipTheme theme;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  const DFChip({
    super.key,
    required this.label,
    required this.status,
    required this.onTap,
    this.theme = DFChipTheme.grayscale,
    this.leading,
    this.trailing,
  });

  Color getBackgroundColor(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    switch (theme) {
      case DFChipTheme.accent:
        return status
            ? colorTheme.coreBrandPrimary
            : colorTheme.coreBrandTertiary;
      case DFChipTheme.solid:
        return status
            ? colorTheme.solidBlue
            : colorTheme.solidTranslucentBlue;
      case DFChipTheme.outlined:
        return status
            ? colorTheme.componentsFillInvertedPrimary
            : Colors.transparent;
      case DFChipTheme.grayscale:
        return status
            ? colorTheme.componentsFillInvertedPrimary
            : colorTheme.componentsTranslucentPrimary;
    }
  }

  TextStyle getTextStyle(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    switch (theme) {
      case DFChipTheme.accent:
        return status
            ? textTheme.footnote.copyWith(color: colorTheme.contentInvertedPrimary, fontWeight: FontWeight.w700)
            : textTheme.footnote.copyWith(color: colorTheme.coreBrandPrimary, fontWeight: FontWeight.w400);
      case DFChipTheme.solid:
        return status
            ? textTheme.footnote.copyWith(color: colorTheme.contentInvertedPrimary, fontWeight: FontWeight.w700)
            : textTheme.footnote.copyWith(color: colorTheme.solidBlue, fontWeight: FontWeight.w400);
      default:
        return status
            ? textTheme.footnote.copyWith(color: colorTheme.contentInvertedPrimary, fontWeight: FontWeight.w700)
            : textTheme.footnote.copyWith(color: colorTheme.contentStandardSecondary, fontWeight: FontWeight.w400);
    }
  }

  BoxBorder? getBorder(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    if (theme == DFChipTheme.outlined && !status) {
      return Border.all(
        color: colorTheme.lineOutline,
        width: 1,
      );
    }
    return null;
  }

  Widget buildLeading(BuildContext context) {
    final l = leading;

    if (l is Icon) {
      return Icon(l.icon, size: 16, color: getTextStyle(context).color);
    } else {
      return l ?? const SizedBox();
    }
  }

  Widget buildTrailing(BuildContext context) {
    final t = trailing;

    if (t is Icon) {
      return Icon(t.icon, size: 16, color: getTextStyle(context).color);
    } else {
      return t ?? const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(
          horizontal: DFSpacing.spacing300,
          vertical: DFSpacing.spacing150,
        ),
        decoration: BoxDecoration(
          color: getBackgroundColor(context),
          border: getBorder(context),
          borderRadius: BorderRadius.circular(DFRadius.radius300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[
              buildLeading(context),
              const SizedBox(width: DFSpacing.spacing150),
            ],
            Text(
              label,
              style: getTextStyle(context),
            ),
            if (trailing != null) ...[
              const SizedBox(width: DFSpacing.spacing150),
              buildTrailing(context),
            ],
          ],
        ),
      ),
    );
  }
}
