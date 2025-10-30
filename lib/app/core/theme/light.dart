import 'package:flutter/material.dart';
import 'colors.dart';
import 'theme.dart';
import 'typography.dart';

class DFLightThemeColors extends DFColors {
  DFLightThemeColors()
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

          // Solid / Translucent (10%)
          solidTranslucentRed: const Color(0x1AFF4035),
          solidTranslucentOrange: const Color(0x1AFF9A05),
          solidTranslucentYellow: const Color(0x1AF5C905),
          solidTranslucentGreen: const Color(0x1A32CC58),
          solidTranslucentBlue: const Color(0x1A057FFF),
          solidTranslucentIndigo: const Color(0x1A5B59DE),
          solidTranslucentPurple: const Color(0x1AB756E8),
          solidTranslucentPink: const Color(0x1AFF325A),
          solidTranslucentBrown: const Color(0x1AA78963),
          solidTranslucentBlack: const Color(0x1A000000),
          solidTranslucentWhite: const Color(0x1AFFFFFF),

          // Background / Standard
          backgroundStandardPrimary: const Color(0xFFFFFFFF),
          backgroundStandardSecondary: const Color(0xFFF6F6FA),

          // Background / Inverted
          backgroundInvertedPrimary: const Color(0xFF000000),
          backgroundInvertedSecondary: const Color(0xFF09090A),

          // Content / Standard
          contentStandardPrimary: const Color(0xFF202128),
          contentStandardSecondary: const Color(0xB3202128),
          contentStandardTertiary: const Color(0x80202128),
          contentStandardQuaternary: const Color(0x4D202128),

          // Content / Inverted
          contentInvertedPrimary: const Color(0xFFF4F4F5),
          contentInvertedSecondary: const Color(0x99F4F4F5),
          contentInvertedTertiary: const Color(0x66F4F4F5),
          contentInvertedQuaternary: const Color(0x33F4F4F5),

          // Line
          lineDivider: const Color(0x29797B8A),
          lineOutline: const Color(0x1F797B8A),

          // Components / Fill / Standard
          componentsFillStandardPrimary: const Color(0xFFFEFEFF),
          componentsFillStandardSecondary: const Color(0xFFFAFAFA),
          componentsFillStandardTertiary: const Color(0xFFF4F4F5),

          // Components / Fill / Inverted
          componentsFillInvertedPrimary: const Color(0xFF131314),
          componentsFillInvertedSecondary: const Color(0xFF161617),
          componentsFillInvertedTertiary: const Color(0xFF1B1B1D),

          // Components / Interaction
          componentsInteractiveHover: const Color(0x14202128),
          componentsInteractiveFocused: const Color(0x1F202128),
          componentsInteractivePressed: const Color(0x29202128),

          // Components / Translucent
          componentsTranslucentPrimary: const Color(0x29747B8A),
          componentsTranslucentSecondary: const Color(0x1E747B8A),
          componentsTranslucentTertiary: const Color(0x14747B8A),

          // Core / Brand
          coreBrandPrimary: const Color(0xFFE83C77),
          coreBrandSecondary: const Color(0x80E83C77),
          coreBrandTertiary: const Color(0x1AE83C77),

          // Core / Status
          coreStatusPositive: const Color(0xFF32CC58),
          coreStatusWarning: const Color(0xFFF5C905),
          coreStatusNegative: const Color(0xFFFF4035),

          // Syntax (Optional)
          syntaxComment: const Color(0x80202128),
          syntaxFunction: const Color(0xFF5B59DE),
          syntaxVariable: const Color(0xFFE08804),
          syntaxString: const Color(0xFF32CC58),
          syntaxConstant: const Color(0xFF057FFF),
          syntaxOperator: const Color(0xFFB756E8),
          syntaxKeyword: const Color(0xFFFF325A),
        );
}

class DFLightThemeTypography extends DFTypography {
  DFLightThemeTypography()
      : super(defaultColor: DFLightThemeColors().contentStandardPrimary);
}
 
class DFLightTheme extends DFTheme {
  DFLightTheme()
      : super(
            colors: DFLightThemeColors(),
            textStyle: DFLightThemeTypography());
}
