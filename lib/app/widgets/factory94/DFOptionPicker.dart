import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';

class DFOptionData {
  final String label;
  final String? subLabel;

  const DFOptionData({required this.label, this.subLabel});
}

class DFOption extends StatelessWidget {
  final bool activated;
  final String label;
  final String? subLabel;
  final VoidCallback? onTap;

  const DFOption({
    super.key,
    required this.activated,
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
          border: Border.all(color: colorTheme.lineOutline, width: 1),
        ),
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DFRadius.radius500),
          border: Border.all(
            color: activated ? colorTheme.coreBrandPrimary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (subLabel != null)
              Text(
                subLabel!,
                style: textTheme.footnote.copyWith(
                  color: colorTheme.contentStandardSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: textTheme.body.copyWith(
                height: 0,
                color: activated
                    ? colorTheme.contentStandardPrimary
                    : colorTheme.contentStandardSecondary,
                fontWeight: activated ? FontWeight.w700 : FontWeight.w400,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

enum DFOptionPickerType {
  doubleHorizontal,
  doubleVertical,
  quadruple,
  sextuple,
}

class DFOptionPicker extends StatelessWidget {
  final DFOptionPickerType type;
  final List<DFOptionData> options;
  final int currentIndex;
  final ValueChanged<int>? onChanged;

  const DFOptionPicker({
    super.key,
    required this.type,
    required this.options,
    required this.currentIndex,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (type == DFOptionPickerType.doubleVertical) {
      return Column(
        children: List.generate(options.length, (index) {
          final option = options[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: DFSpacing.spacing150),
            child: DFOption(
              label: option.label,
              subLabel: option.subLabel,
              activated: currentIndex == index,
              onTap: () => onChanged?.call(index),
            ),
          );
        }),
      );
    }

    final crossAxisCount = switch (type) {
      DFOptionPickerType.doubleHorizontal => 2,
      DFOptionPickerType.quadruple => 2,
      DFOptionPickerType.sextuple => 3,
      _ => 2,
    };

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: DFSpacing.spacing200,
        mainAxisSpacing: DFSpacing.spacing200,
        mainAxisExtent: 56,
      ),
      itemBuilder: (context, index) {
        final option = options[index];
        return DFOption(
          label: option.label,
          subLabel: option.subLabel,
          activated: currentIndex == index,
          onTap: () => onChanged?.call(index),
        );
      },
    );
  }
}
