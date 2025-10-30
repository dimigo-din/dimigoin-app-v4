import 'package:flutter/material.dart';

TextStyle style(
  FontWeight weight,
  double size,
  double lineHeight,
  Color color, {
  bool underlined = false,
  double spacing = 0,
}) =>
    TextStyle(
      color: color,
      height: lineHeight / size,
      fontSize: size,
      fontFamily: 'WantedSans',
      fontWeight: weight,
      letterSpacing: spacing,
      decoration: underlined ? TextDecoration.underline : TextDecoration.none,
      decorationColor: color,
    );

abstract class Weight {
  static const thin = FontWeight.w100;
  static const extraLight = FontWeight.w200;
  static const light = FontWeight.w300;
  static const regular = FontWeight.w400;
  static const medium = FontWeight.w500;
  static const semiBold = FontWeight.w600;
  static const bold = FontWeight.w700;
  static const extraBold = FontWeight.w800;
  static const heavy = FontWeight.w900;
}

class DFTypography extends ThemeExtension<DFTypography> {
  final Color defaultColor;

  final TextStyle display;
  final TextStyle title;
  final TextStyle headline;
  final TextStyle body;
  final TextStyle callout;
  final TextStyle footnote;
  final TextStyle caption;
  final TextStyle paragraphLarge;
  final TextStyle paragraphSmall;

  DFTypography({
    required this.defaultColor,
    TextStyle? display,
    TextStyle? title,
    TextStyle? headline,
    TextStyle? body,
    TextStyle? callout,
    TextStyle? footnote,
    TextStyle? caption,
    TextStyle? paragraphLarge,
    TextStyle? paragraphSmall,
  })  : display = display ??
            style(Weight.semiBold, 48, 70, defaultColor, spacing: -1.44), // Display
        title = title ??
            style(Weight.semiBold, 24, 34, defaultColor, spacing: -0.48), // Title
        headline = headline ??
            style(Weight.semiBold, 20, 28, defaultColor, spacing: -0.4), // Headline
        body = body ??
            style(Weight.regular, 16, 24, defaultColor, spacing: -0.32), // Body
        callout = callout ??
            style(Weight.medium, 14, 20, defaultColor, spacing: -0.28), // Callout
        footnote = footnote ??
            style(Weight.regular, 12, 18, defaultColor, spacing: -0.24), // Footnote
        caption = caption ??
            style(Weight.regular, 10, 14, defaultColor, spacing: -0.2), // Caption
        paragraphLarge = paragraphLarge ??
            style(Weight.regular, 16, 28.8, defaultColor, spacing: -0.32), // Paragraph Large
        paragraphSmall = paragraphSmall ??
            style(Weight.regular, 14, 24, defaultColor, spacing: -0.28); // Paragraph Small

  @override
  ThemeExtension<DFTypography> copyWith({
    Color? defaultColor,
    TextStyle? display,
    TextStyle? title,
    TextStyle? headline,
    TextStyle? body,
    TextStyle? callout,
    TextStyle? footnote,
    TextStyle? caption,
    TextStyle? paragraphLarge,
    TextStyle? paragraphSmall,
  }) {
    return DFTypography(
      defaultColor: defaultColor ?? this.defaultColor,
      display: display ?? this.display,
      title: title ?? this.title,
      headline: headline ?? this.headline,
      body: body ?? this.body,
      callout: callout ?? this.callout,
      footnote: footnote ?? this.footnote,
      caption: caption ?? this.caption,
      paragraphLarge: paragraphLarge ?? this.paragraphLarge,
      paragraphSmall: paragraphSmall ?? this.paragraphSmall,
    );
  }

  @override
  ThemeExtension<DFTypography> lerp(
      covariant ThemeExtension<DFTypography>? other, double t) {
    if (other is! DFTypography) {
      return this;
    }
    return DFTypography(
      defaultColor: Color.lerp(defaultColor, other.defaultColor, t)!,
      display: TextStyle.lerp(display, other.display, t),
      title: TextStyle.lerp(title, other.title, t),
      headline: TextStyle.lerp(headline, other.headline, t),
      body: TextStyle.lerp(body, other.body, t),
      callout: TextStyle.lerp(callout, other.callout, t),
      footnote: TextStyle.lerp(footnote, other.footnote, t),
      caption: TextStyle.lerp(caption, other.caption, t),
      paragraphLarge: TextStyle.lerp(paragraphLarge, other.paragraphLarge, t),
      paragraphSmall: TextStyle.lerp(paragraphSmall, other.paragraphSmall, t),
    );
  }
}
