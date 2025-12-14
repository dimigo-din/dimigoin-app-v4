import 'dart:io';

import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/services/push/service.dart';
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
    // Initializes the binding between the Flutter framework and the Flutter engine.
    // The WidgetsBinding provides access to the Window widget, which represents
    // the host platform's window and its properties (device metrics, padding, etc.).
    // This binding is required before using any platform channels or plugins.
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    try {
      setPathUrlStrategy();

      await dotenv.load(fileName: "env/.env");

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
