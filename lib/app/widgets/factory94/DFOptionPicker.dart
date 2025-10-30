import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';

class DFOption extends StatelessWidget {
  final bool? activated;
  final String label;
  final String? subLabel;
  final VoidCallback? onTap;

  const DFOption({
    this.activated,
    required this.label,
    this.subLabel,
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
        padding: const EdgeInsets.symmetric(
          horizontal: DFSpacing.spacing400,
          vertical: DFSpacing.spacing300,
        ),
        decoration: BoxDecoration(
          color: colorTheme.componentsFillStandardPrimary,
          borderRadius: BorderRadius.circular(DFRadius.radius500),
          border: Border.all(
            color: colorTheme.lineOutline,
            width: 1,
          ),
        ),
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DFRadius.radius500),
          border: Border.all(
            color: activated!
                ? colorTheme.coreBrandPrimary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (subLabel != null) ...[
              Text(
                subLabel!,
                style: textTheme.footnote.copyWith(
                  color: colorTheme.contentStandardSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: textTheme.body.copyWith(
                height: 0,
                color: activated!
                    ? colorTheme.contentStandardPrimary
                    : colorTheme.contentStandardSecondary,
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

enum DFOptionPickerType { doubleHorizontal, doubleVertical, quadruple, sextuple }

class DFOptionPicker extends StatefulWidget {
  final DFOptionPickerType type;
  final List<DFOption> options;
  final int? initialIndex;
  final ValueChanged<int>? onChanged;

  const DFOptionPicker({
    super.key,
    required this.type,
    required this.options,
    this.initialIndex,
    this.onChanged,
  });

  @override
  State<DFOptionPicker> createState() => _DFOptionPickerState();
}

class _DFOptionPickerState extends State<DFOptionPicker> {
  int? selectedIndex;

  int get crossAxisCount {
    switch (widget.type) {
      case DFOptionPickerType.doubleHorizontal:
        return 2;
      case DFOptionPickerType.doubleVertical:
        return 1;
      case DFOptionPickerType.quadruple:
        return 2;
      case DFOptionPickerType.sextuple:
        return 3;
    }
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  void _onTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == DFOptionPickerType.doubleVertical) {
      return Column(
        children: List.generate(widget.options.length, (index) {
          final option = widget.options[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: DFSpacing.spacing150),
            child: DFOption(
              label: option.label,
              subLabel: option.subLabel,
              activated: selectedIndex == index,
              onTap: () => _onTap(index),
            ),
          );
        }),
      );
    }

    final crossAxisCount = switch (widget.type) {
      DFOptionPickerType.doubleHorizontal => 2,
      DFOptionPickerType.quadruple => 2,
      DFOptionPickerType.sextuple => 3,
      _ => 2,
    };

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.options.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: DFSpacing.spacing200,
        mainAxisSpacing: DFSpacing.spacing200,
        mainAxisExtent: 56,
      ),
      itemBuilder: (context, index) {
        final option = widget.options[index];
        return DFOption(
          label: option.label,
          subLabel: option.subLabel,
          activated: selectedIndex == index,
          onTap: () => _onTap(index),
        );
      },
    );
  }

}