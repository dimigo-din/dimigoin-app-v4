import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import '../core/middleware/login.dart';

import '../pages/login/binding.dart';
import '../pages/login/page.dart';

import '../pages/test/binding.dart';
import '../pages/test/page.dart';

import '../pages/main/page.dart';

import '../pages/login/pw/binding.dart';
import '../pages/login/pw/page.dart';

import '../pages/pin/page.dart';
import '../pages/pin/binding.dart';

import '../pages/setting/binding.dart';
import '../pages/setting/page.dart';

import 'routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.TEST,
      page: () => const TestPage(),
      binding: TestPageBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.LICENSE,
      page: () => const LicensePage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginPage(),
      binding: LoginPageBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.PW_LOGIN,
      page: () => const PWLoginPage(),
      binding: PWLoginPageBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.MAIN,
      page: () => MainPage(),
      middlewares: [LoginMiddleware()],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.PIN,
      page: () => const PinInputPage(),
      binding: PinInputPageBinding(),
      middlewares: [LoginMiddleware()],
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.SETTING,
      page: () => SettingPage(),
      binding: SettingPageBinding(),
      middlewares: [LoginMiddleware()],
      transition: Transition.cupertino,
    ),
  ];
}
