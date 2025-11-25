import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dark.dart';

final DFDarkTheme _darkTheme = DFDarkTheme();

ThemeData darkThemeData = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'SUITv1',
  colorScheme: ColorScheme.fromSeed(
    seedColor: _darkTheme.colors.coreBrandPrimary,
    brightness: Brightness.dark,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    titleSpacing: 0,
    foregroundColor: _darkTheme.colors.contentStandardPrimary,
    centerTitle: false,
  ),
  textSelectionTheme: TextSelectionThemeData(
      selectionColor: _darkTheme.colors.coreBrandPrimary.withAlpha(100),
      selectionHandleColor: _darkTheme.colors.coreBrandPrimary),
  cupertinoOverrideTheme:
      CupertinoThemeData(primaryColor: _darkTheme.colors.coreBrandPrimary),
  scaffoldBackgroundColor: _darkTheme.colors.backgroundStandardSecondary,
  canvasColor: _darkTheme.colors.solidBlack,
  extensions: [_darkTheme.colors, _darkTheme.textStyle],
  cardColor: _darkTheme.colors.componentsFillStandardPrimary,
);
