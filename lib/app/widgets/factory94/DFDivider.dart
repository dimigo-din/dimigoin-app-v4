import 'package:flutter/material.dart';
import 'package:dimigoin_app_v4/app/core/theme/colors.dart';

enum DFDividerSize { small, medium, large }

class DFDivider extends StatelessWidget {
  final DFDividerSize size;

  const DFDivider({
    super.key,
    this.size = DFDividerSize.medium,
  });

  double get height {
    switch (size) {
      case DFDividerSize.small:
        return 1;
      case DFDividerSize.medium:
        return 4;
      case DFDividerSize.large:
        return 8;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return SizedBox(
      height: height,
      width: size == DFDividerSize.large ? double.infinity : MediaQuery.of(context).size.width * 0.9,
      child: Divider(
        thickness: height,
        color: colorTheme.lineDivider,
      )
    );
  }
}