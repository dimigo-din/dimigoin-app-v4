import 'package:dimigoin_app_v4/app/widgets/factory94/DFInputField.dart';
import 'package:dimigoin_app_v4/app/widgets/gestureDetector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/static.dart';
import '../../../core/theme/typography.dart';
import 'controller.dart';

class PWLoginPage extends GetView<PWLoginPageController> {
  const PWLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: DFSpacing.spacing900),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/dimigoin_icon.png', width: 30, height: 30),
                        SizedBox(width: DFSpacing.spacing200),
                        Text(
                          '디미고인',
                          style: textTheme.headline.copyWith(
                            color: colorTheme.contentStandardPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    DFInput(
                      placeholder: "아이디",
                      onChanged: (value) => controller.email.value = value,
                    ),
                    SizedBox(height: 10),
                    DFInput(
                      placeholder: "비밀번호",
                      obscureText: true,
                      onChanged: (value) => controller.password.value = value,
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: DFGestureDetectorWithOpacityInteraction(
                        onTap: () => {},
                        child: DFGestureDetectorWithScaleInteraction(
                          onTap: () => {controller.loginWithPassword()},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: DFSpacing.spacing200,
                            ),
                            decoration: BoxDecoration(
                              color: colorTheme.coreBrandPrimary,
                              border: Border(
                                bottom: BorderSide(
                                  color: colorTheme.lineOutline,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(DFRadius.radius300),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(DFSpacing.spacing200),
                              child: Center(
                                child: Text(
                                  "로그인",
                                  style: textTheme.callout.copyWith(
                                    color: colorTheme.contentInvertedPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(
                'assets/images/schoolscenery.svg',
                width: double.infinity,
                height: 80,
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        ),
      )
    );
  }
}