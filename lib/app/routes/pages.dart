import 'package:dimigoin_app_v4/app/pages/frigo/binding.dart';
import 'package:dimigoin_app_v4/app/pages/frigo/page.dart';
import 'package:dimigoin_app_v4/app/pages/laundry/binding.dart';
import 'package:dimigoin_app_v4/app/pages/laundry/page.dart';
import 'package:dimigoin_app_v4/app/pages/signup/binding.dart';
import 'package:dimigoin_app_v4/app/pages/signup/page.dart';
import 'package:dimigoin_app_v4/app/pages/stay/binding.dart';
import 'package:dimigoin_app_v4/app/pages/stay/page.dart';
import 'package:dimigoin_app_v4/app/pages/wakeup/binding.dart';
import 'package:dimigoin_app_v4/app/pages/wakeup/page.dart';
import 'package:flutter/foundation.dart';
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

import '../pages/setting/binding.dart';
import '../pages/setting/page.dart';

import '../pages/meal/binding.dart';
import '../pages/meal/page.dart';

import 'routes.dart';

class AppPages {
  static final pages = [
    if (kDebugMode) ...[
      GetPage(
        name: Routes.TEST,
        page: () => const TestPage(),
        binding: TestPageBinding(),
        transition: Transition.cupertino,
      ),
    ],
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
      name: Routes.STAY,
      page: () => StayPage(),
      binding: StayPageBinding(),
      middlewares: [LoginMiddleware()],
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.LAUNDRY,
      page: () => LaundryPage(),
      binding: LaundryPageBinding(),
      middlewares: [LoginMiddleware()],
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.FRIGO,
      page: () => FrigoPage(),
      binding: FrigoPageBinding(),
      middlewares: [LoginMiddleware()],
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.WAKEUP,
      page: () => WakeupPage(),
      binding: WakeupPageBinding(),
      middlewares: [LoginMiddleware()],
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.MAIN,
      page: () => MainPage(),
      middlewares: [LoginMiddleware()],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => SignupPage(),
      binding: SignupPageBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.SETTING,
      page: () => SettingPage(),
      binding: SettingPageBinding(),
      middlewares: [LoginMiddleware()],
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.MEAL,
      page: () => MealPage(),
      binding: MealPageBinding(),
      middlewares: [LoginMiddleware()],
      transition: Transition.cupertino,
    ),
  ];
}
