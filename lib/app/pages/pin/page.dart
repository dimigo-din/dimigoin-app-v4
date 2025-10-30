import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';
import 'widgets/pin_keypad_grid.dart';
import 'widgets/pin_dot_indicator.dart';

class PinInputPage extends GetView<PinInputController> {
  const PinInputPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorTheme.backgroundStandardSecondary,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxHeight < 600;
            return Column(
              children: [
                SizedBox(height: isSmallScreen ? 40 : 80),
                Text(
                  'PIN 번호를 입력하세요',
                  style: textTheme.headline.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 32 : 56),
                Obx(
                  () => PinDotIndicator(
                    pinLength: controller.pinLength,
                    filledCount: controller.pin.value.length,
                  ),
                ),
                const Spacer(),
                PinKeypadGrid(
                  onNumberPressed: controller.onNumberPressed,
                  onDeletePressed: controller.onDeletePressed,
                ),
                SizedBox(height: isSmallScreen ? 24 : 40),
              ],
            );
          },
        ),
      ),
    );
  }
}
