import 'package:dimigoin_app_v4/app/routes/routes.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginMiddleware extends GetMiddleware {
  LoginMiddleware({super.priority});

  @override
  RouteSettings? redirect(String? route) {
    if (!Get.isRegistered<AuthService>()) {
      return RouteSettings(
        name: Routes.LOGIN,
        arguments: {'redirect': route},
      );
    }

    final authService = Get.find<AuthService>();
    return authService.isLoginSuccess || authService.isPersonalInfoRegistered ? null : RouteSettings(name: Routes.LOGIN, arguments: {'redirect': route});
  }
}
