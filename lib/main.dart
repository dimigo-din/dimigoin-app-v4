import 'package:dimigoin_app_v4/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

import 'app/core/theme/inapp/dark.dart';
import 'app/core/theme/inapp/light.dart';
import 'app/core/utils/loader.dart';
import 'app/routes/pages.dart';
import 'app/routes/routes.dart';

void main() async {
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
    ),
  );
}
