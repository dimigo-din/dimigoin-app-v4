import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class PinDotIndicator extends StatelessWidget {
  final int pinLength;
  final int filledCount;

  const PinDotIndicator({
    super.key,
    required this.pinLength,
    required this.filledCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pinLength,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _buildPinDot(context, index),
        ),
      ),
    );
  }

  Widget _buildPinDot(BuildContext context, int index) {
    final isFilled = index < filledCount;

    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: 32,
      height: 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
        color: isFilled ? colorTheme.componentsFillInvertedTertiary : colorTheme.componentsFillStandardTertiary,
      ),
    );
  }
}
