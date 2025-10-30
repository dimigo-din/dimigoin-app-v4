import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';

class DFSegment extends StatelessWidget {
  final bool? activated;
  final String label;
  final Widget? leading;
  final VoidCallback? onTap;

  const DFSegment({
    this.activated = false,
    required this.label,
    this.leading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: DFSpacing.spacing300,
          vertical: DFSpacing.spacing200,
        ),
        decoration: BoxDecoration(
          color: activated!
              ? colorTheme.componentsFillStandardPrimary
              : colorTheme.componentsFillStandardTertiary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(DFRadius.radius300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: DFSpacing.spacing200),
            ],
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: textTheme.body.copyWith(
                height: 1.5,
                color: activated!
                    ? colorTheme.contentStandardPrimary
                    : colorTheme.contentStandardQuaternary,
                fontWeight: activated! ? FontWeight.w700 : FontWeight.w400,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

class DFSegmentControl extends StatefulWidget {
  final List<DFSegment> segments;
  final int initialIndex;
  final ValueChanged<int>? onChanged;

  const DFSegmentControl({
    super.key,
    required this.segments,
    this.initialIndex = 0,
    this.onChanged,
  });

  @override
  State<DFSegmentControl> createState() => _DFSegmentControlState();
}

class _DFSegmentControlState extends State<DFSegmentControl> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  void _onSegmentTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return Container(
      padding: const EdgeInsets.all(DFSpacing.spacing100),
      decoration: BoxDecoration(
        color: colorTheme.componentsTranslucentSecondary,
        borderRadius: BorderRadius.circular(DFRadius.radius400),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int index = 0; index < widget.segments.length; index++) ...[
            Expanded(
              child: DFSegment(
                activated: selectedIndex == index,
                label: widget.segments[index].label,
                leading: widget.segments[index].leading,
                onTap: () => _onSegmentTap(index),
              ),
            ),
            if (index != widget.segments.length - 1)
              const SizedBox(width: DFSpacing.spacing100),
          ],
        ],
      ),
    );
  }
}
