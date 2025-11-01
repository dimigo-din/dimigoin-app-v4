import 'package:flutter/material.dart';
import 'colors.dart';
import 'theme.dart';
import 'typography.dart';

class DFDarkThemeColors extends DFColors {
  DFDarkThemeColors()
      : super(
          // Solid
          solidRed: const Color(0xFFFF4035),
          solidOrange: const Color(0xFFFF9A05),
          solidYellow: const Color(0xFFF5C905),
          solidGreen: const Color(0xFF32CC58),
          solidBlue: const Color(0xFF057FFF),
          solidIndigo: const Color(0xFF5B59DE),
          solidPurple: const Color(0xFFB756E8),
          solidPink: const Color(0xFFFF325A),
          solidBrown: const Color(0xFFA78963),
          solidBlack: const Color(0xFF000000),
          solidWhite: const Color(0xFFFFFFFF),

          // Solid / Translucent (20%)
          solidTranslucentRed: const Color(0x33FF4035),
          solidTranslucentOrange: const Color(0x33FF9A05),
          solidTranslucentYellow: const Color(0x33F5C905),
          solidTranslucentGreen: const Color(0x3332CC58),
          solidTranslucentBlue: const Color(0x33057FFF),
          solidTranslucentIndigo: const Color(0x335B59DE),
          solidTranslucentPurple: const Color(0x33B756E8),
          solidTranslucentPink: const Color(0x33FF325A),
          solidTranslucentBrown: const Color(0x33A78963),
          solidTranslucentBlack: const Color(0x33000000),
          solidTranslucentWhite: const Color(0x33FFFFFF),

          // Background / Standard
          backgroundStandardPrimary: const Color(0xFF000000),
          backgroundStandardSecondary: const Color(0xFF09090A),

          // Background / Inverted
          backgroundInvertedPrimary: const Color(0xFFFFFFFF),
          backgroundInvertedSecondary: const Color(0xFFF6F6FA),

          // Content / Standard
          contentStandardPrimary: const Color(0xFFF4F4F5),
          contentStandardSecondary: const Color(0x99F4F4F5),
          contentStandardTertiary: const Color(0x66F4F4F5),
          contentStandardQuaternary: const Color(0x33F4F4F5),

          // Content / Inverted
          contentInvertedPrimary: const Color(0xFF202128),
          contentInvertedSecondary: const Color(0x99202128),
          contentInvertedTertiary: const Color(0x66202128),
          contentInvertedQuaternary: const Color(0x33202128),

          // Line
          lineDivider: const Color(0x3D797B8A),
          lineOutline: const Color(0x29797B8A),

          // Components / Fill / Standard
          componentsFillStandardPrimary: const Color(0xFF131314),
          componentsFillStandardSecondary: const Color(0xFF161617),
          componentsFillStandardTertiary: const Color(0xFF1B1B1D),

          // Components / Fill / Inverted
          componentsFillInvertedPrimary: const Color(0xFFFEFEFF),
          componentsFillInvertedSecondary: const Color(0xFFFAFAFA),
          componentsFillInvertedTertiary: const Color(0xFFF4F4F5),

          // Components / Interaction
            componentsInteractiveHover: const Color(0x14FFFFFF),
            componentsInteractiveFocused: const Color(0x1FFFFFFF),
            componentsInteractivePressed: const Color(0x29FFFFFF),

          // Components / Translucent
          componentsTranslucentPrimary: const Color(0x33747B8A),
          componentsTranslucentSecondary: const Color(0x2E747B8A),
          componentsTranslucentTertiary: const Color(0x29747B8A),

          // Core / Brand
          coreBrandPrimary: const Color(0xFFE83C77),
          coreBrandSecondary: const Color(0x80E83C77),
          coreBrandTertiary: const Color(0x1AE83C77),

          // Core / Status
          coreStatusPositive: const Color(0xFF32CC58),
          coreStatusWarning: const Color(0xFFF5C905),
          coreStatusNegative: const Color(0xFFFF4035),

          // Syntax
          syntaxComment: const Color(0x99F4F4F5),
          syntaxFunction: const Color(0xFF5B59DE),
          syntaxVariable: const Color(0xFFE08804),
          syntaxString: const Color(0xFF32CC58),
          syntaxConstant: const Color(0xFF057FFF),
          syntaxOperator: const Color(0xFFB756E8),
          syntaxKeyword: const Color(0xFFFF325A),
        );
}

class DFDarkThemeTypography extends DFTypography {
  DFDarkThemeTypography()
      : super(defaultColor: DFDarkThemeColors().contentStandardPrimary);
}

class DFDarkTheme extends DFTheme {
  DFDarkTheme()
      : super(
            colors: DFDarkThemeColors(),
            textStyle: DFDarkThemeTypography());
}
