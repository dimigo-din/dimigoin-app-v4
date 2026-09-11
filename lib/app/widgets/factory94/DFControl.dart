import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/widgets/gestureDetector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum DFControlType { heart, star, toggle, check, checkfill, radio }

class DFControl extends StatelessWidget {
  final DFControlType type;
  final bool disabled;
  final bool status;
  final VoidCallback? onTap;

  const DFControl({
    super.key,
    required this.type,
    this.onTap,
    this.disabled = false,
    this.status = false,
  });

  Color getColor(BuildContext context) {
    final colors = Theme.of(context).extension<DFColors>()!;
    if (!status) {
      return switch (type) {
        DFControlType.toggle => colors.componentsTranslucentPrimary,
        DFControlType.checkfill || DFControlType.radio => colors.lineOutline,
        _ => colors.contentStandardQuaternary,
      };
    }
    return switch (type) {
      DFControlType.heart => colors.solidPink,
      DFControlType.star => colors.solidYellow,
      _ => colors.coreBrandPrimary,
    };
  }

  Widget _icon(String name, Color color, {double size = 24}) {
    return SvgPicture.asset(
      'assets/icons/control_$name.svg',
      width: size,
      height: size,
      colorMapper: _ControlColorMapper(color),
      excludeFromSemantics: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<DFColors>()!;
    final color = getColor(context);
    final isToggle = type == DFControlType.toggle;
    final interactive = !disabled && onTap != null;
    final width = isToggle ? 44.0 : 24.0;
    final radius = switch (type) {
      DFControlType.check || DFControlType.checkfill => DFRadius.radius200,
      _ => DFRadius.radius500,
    };

    final visual = switch (type) {
      DFControlType.heart => _icon(
        status ? 'heart_filled' : 'heart_outline',
        color,
      ),
      DFControlType.star => _icon(
        status ? 'star_filled' : 'star_outline',
        color,
      ),
      DFControlType.check => _icon(status ? 'check_fill' : 'check', color),
      DFControlType.toggle => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: width,
        height: 24,
        padding: const EdgeInsets.all(DFSpacing.spacing50),
        alignment: status ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(DFRadius.radius400),
        ),
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: colors.solidWhite,
            shape: BoxShape.circle,
          ),
        ),
      ),
      DFControlType.checkfill => TweenAnimationBuilder<double>(
        tween: Tween(begin: status ? 1 : 0, end: status ? 1 : 0),
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: _icon('check_fill', colors.solidWhite, size: 20),
        builder: (context, progress, check) => SizedBox.square(
          dimension: 24,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.coreBrandPrimary.withValues(
                alpha: colors.coreBrandPrimary.a * progress,
              ),
              border: Border.all(
                color: Color.lerp(
                  colors.lineOutline,
                  colors.coreBrandPrimary,
                  progress,
                )!,
              ),
              borderRadius: BorderRadius.circular(DFRadius.radius100),
            ),
            child: Center(
              child: Opacity(
                opacity: progress,
                child: Transform.scale(
                  scale: 0.85 + 0.15 * progress,
                  child: check,
                ),
              ),
            ),
          ),
        ),
      ),
      DFControlType.radio => Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: status ? color : null,
          border: status ? null : Border.all(color: colors.lineOutline),
          borderRadius: BorderRadius.circular(DFRadius.radius400),
        ),
        child: !status
            ? null
            : Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: colors.solidWhite,
                  shape: BoxShape.circle,
                ),
              ),
      ),
    };

    return Semantics(
      enabled: interactive,
      checked: isToggle ? null : status,
      toggled: isToggle ? status : null,
      inMutuallyExclusiveGroup: type == DFControlType.radio,
      onTap: interactive ? onTap : null,
      child: ExcludeSemantics(
        child: FocusableActionDetector(
          enabled: interactive,
          mouseCursor: interactive
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                if (interactive) onTap!();
                return null;
              },
            ),
          },
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeInOut,
            opacity: disabled ? 0.3 : 1,
            child: SizedBox(
              width: width,
              height: 24,
              // The interaction layer extends 2px beyond the visual bounds.
              child: OverflowBox(
                minWidth: width + DFSpacing.spacing100,
                maxWidth: width + DFSpacing.spacing100,
                minHeight: 28,
                maxHeight: 28,
                child: DFGestureDetectorWithFillInteraction(
                  onTap: interactive ? onTap : null,
                  effectBorderRadius: radius,
                  child: Padding(
                    padding: const EdgeInsets.all(DFSpacing.spacing50),
                    child: isToggle || type == DFControlType.checkfill
                        ? visual
                        : AnimatedSwitcher(
                            duration: const Duration(milliseconds: 160),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            transitionBuilder: (child, animation) =>
                                FadeTransition(
                                  opacity: animation,
                                  child: ScaleTransition(
                                    scale: Tween<double>(
                                      begin: 0.85,
                                      end: 1,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                ),
                            child: KeyedSubtree(
                              key: ValueKey((type, status)),
                              child: visual,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Recolor only the exported glyph, preserving its mask.
class _ControlColorMapper extends ColorMapper {
  final Color color;

  const _ControlColorMapper(this.color);

  @override
  Color substitute(
    String? id,
    String element,
    String attribute,
    Color original,
  ) {
    return element == 'path' && attribute == 'fill' ? color : original;
  }

  @override
  bool operator ==(Object other) =>
      other is _ControlColorMapper && other.color == color;

  @override
  int get hashCode => color.hashCode;
}
