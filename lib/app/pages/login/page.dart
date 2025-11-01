import 'package:dimigoin_app_v4/app/routes/routes.dart';
import 'package:dimigoin_app_v4/app/widgets/gestureDetector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/static.dart';
import '../../core/theme/typography.dart';
import 'controller.dart';

class LoginPage extends GetView<LoginPageController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Scaffold(
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
                  DFGestureDetectorWithOpacityInteraction(
                    onTap: () => {},
                    onLongPress: () => {Get.toNamed(Routes.PW_LOGIN)},
                    child: DFGestureDetectorWithScaleInteraction(
                      onTap: () => {controller.loginWithGoogle()},
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/icons/google.svg'  , width: 24, height: 24),
                              SizedBox(width: DFSpacing.spacing300),
                              Text(
                                "디미고 구글 계정으로 로그인",
                                style: textTheme.callout.copyWith(
                                  color: colorTheme.solidWhite,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => {
                          controller.openLoginHelpPage(),
                        },
                        child: Text(
                          "로그인에 도움이 필요하신가요?",
                          style: textTheme.footnote.copyWith(
                            color: colorTheme.contentStandardTertiary,
                            decoration: TextDecoration.underline,
                            decorationColor: colorTheme.contentStandardTertiary,
                          ),
                        ),
                      )
                    ],
                  )
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
    );
  }
}