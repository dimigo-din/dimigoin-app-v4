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

    return SafeArea(
      child: Scaffold(
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
                  const PinPageTitle(),
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
      ),
    );
  }
}

class PinPageTitle extends GetView<PinInputController> {
  const PinPageTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Obx(() {
      switch(controller.pinStatus.value) {
        case PinStatus.normal:
          return Text(
            'PIN 번호를 입력하세요',
            style: textTheme.headline.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          );
        case PinStatus.wrong:
          return Text(
            'PIN 번호가 올바르지 않습니다.',
            style: textTheme.headline.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
              color: colorTheme.coreStatusNegative,
            ),
          );
        case PinStatus.checking:
          return Text(
            '로그인 중입니다...',
            style: textTheme.headline.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          );
      }
    });
  }
}