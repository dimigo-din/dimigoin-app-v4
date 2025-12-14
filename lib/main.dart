import 'dart:developer';

import 'package:dimigoin_app_v4/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

import 'app/core/theme/inapp/dark.dart';
import 'app/core/theme/inapp/light.dart';
import 'app/core/utils/loader.dart';
import 'app/routes/pages.dart';
import 'app/routes/routes.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  log('background noti: ${message.messageId}');
}

void main() async {
  // Initializes the binding between the Flutter framework and the Flutter engine.
  // This binding includes access to the Window widget, which represents the host
  // platform's window. The Window widget provides access to platform-specific
  // features like the device pixel ratio, padding, view configuration, and
  // platform brightness. This must be called before using any plugins or
  // platform channels.
  WidgetsFlutterBinding.ensureInitialized(); 
  await Hive.initFlutter();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await AppLoader().load();
  
  runApp(
    GetMaterialApp(
      title: '디미고인',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData,
      darkTheme: darkThemeData,
      initialRoute: kReleaseMode ? Routes.MAIN : Routes.TEST,
      getPages: AppPages.pages,
      builder: (context, child) {
        final app = Overlay(
          initialEntries: [
            OverlayEntry(builder: (_) => child!),
          ],
        );

        if (kIsWeb) {
          return Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? darkThemeData.canvasColor
                : lightThemeData.canvasColor,
            child: Center(
              child: ClipRect(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: app, // ← Overlay 유지
                ),
              ),
            ),
          );
        }

        return app;
      },
    ),
  );
}
