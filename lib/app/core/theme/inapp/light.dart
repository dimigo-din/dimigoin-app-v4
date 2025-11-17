import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../light.dart';

final DFLightTheme _lightTheme = DFLightTheme();

final ThemeData lightThemeData = ThemeData(
  fontFamily: 'SUITv1',
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _lightTheme.colors.coreBrandPrimary,
    brightness: Brightness.light,
  ),
  appBarTheme: AppBarTheme(
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    titleSpacing: 0,
    foregroundColor: _lightTheme.colors.contentStandardPrimary,
    centerTitle: false,
  ),
  textSelectionTheme: TextSelectionThemeData(
      selectionColor: _lightTheme.colors.coreBrandPrimary.withAlpha(100),
      selectionHandleColor: _lightTheme.colors.coreBrandPrimary),
  cupertinoOverrideTheme:
      CupertinoThemeData(primaryColor: _lightTheme.colors.coreBrandPrimary),
  scaffoldBackgroundColor: _lightTheme.colors.backgroundStandardSecondary,
  canvasColor: _lightTheme.colors.solidWhite,
  extensions: [_lightTheme.colors, _lightTheme.textStyle],
  cardColor: _lightTheme.colors.componentsFillStandardPrimary,
);
