import 'dart:io';

import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/services/push/service.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';

import '../../provider/api.dart';
import '../../provider/api_interface.dart';

class AppLoader {
  Future<void> load() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    try {
      setPathUrlStrategy();

      await dotenv.load(fileName: "env/.env");

      await FirebaseAppCheck.instance.activate(
          providerAndroid: kDebugMode
              ? const AndroidDebugProvider()
              : const AndroidPlayIntegrityProvider(),
          providerApple: kDebugMode
              ? const AppleDebugProvider()
              : const AppleAppAttestProvider(),
          providerWeb: ReCaptchaV3Provider(dotenv.env["RECAPTCHA_SITE_KEY"]!),
        );

      Get.put<ApiProvider>(ProdApiProvider());
      final authService = Get.put(AuthService());
      await authService.initComplete;
      Get.put(PushService());

      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

      if (!kIsWeb) {
        if (Platform.isAndroid) {
          await FlutterDisplayMode.setHighRefreshRate();
        }
      }

      FlutterNativeSplash.remove();
    } catch (e) {
      rethrow;
    }
  }
}
