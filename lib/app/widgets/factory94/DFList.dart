import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/widgets/marqueeText.dart';
import 'package:dimigoin_app_v4/app/widgets/gestureDetector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';

enum DFValueListType { horizontal, vertical }

enum DFValueListTheme { disabled, outlined, active }

class DFValueList extends StatelessWidget {
  final DFValueListType type;
  final DFValueListTheme theme;
  final String title;
  final String? subTitle;
  final String? content;
  final Widget? header;
  final Widget? titleLeading;
  final int? titleMaxLines;
  final int? contentMaxLines;
  final Widget? trailing;
  final CrossAxisAlignment trailingAlignment;
  final VoidCallback? onTap;

  const DFValueList({
    super.key,
    required this.type,
    this.theme = DFValueListTheme.active,
    required this.title,
    this.subTitle,
    this.content,
    this.header,
    this.titleLeading,
    this.titleMaxLines,
    this.contentMaxLines,
    this.trailing,
    this.trailingAlignment = CrossAxisAlignment.start,
    this.onTap,
  }) : assert(titleMaxLines == null || titleMaxLines > 0),
       assert(contentMaxLines == null || contentMaxLines > 0);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<DFColors>()!;
    final typography = Theme.of(context).extension<DFTypography>()!;
    final isActive = theme == DFValueListTheme.active;
    final isDisabled = theme == DFValueListTheme.disabled;
    final titleColor = isActive
        ? colors.solidWhite
        : colors.contentStandardPrimary;
    final secondaryColor = isActive
        ? colors.solidWhite
        : isDisabled
        ? colors.contentStandardQuaternary
        : colors.contentStandardSecondary;
    final tertiaryColor = isActive
        ? colors.solidWhite
        : isDisabled
        ? colors.contentStandardQuaternary
        : colors.contentStandardTertiary;

    final horizontal = type == DFValueListType.horizontal;
    final headingText = _DFValueListTitleRow(
      title: title,
      titleMaxLines: titleMaxLines,
      titleStyle: (horizontal ? typography.body : typography.headline).copyWith(
        color: titleColor,
        fontWeight: FontWeight.w700,
      ),
      leadingValue: horizontal ? subTitle : null,
      leadingStyle: typography.callout.copyWith(
        color: tertiaryColor,
        fontWeight: FontWeight.w400,
      ),
      trailingValue: horizontal ? content : subTitle,
      trailingStyle: horizontal
          ? typography.callout.copyWith(
              color: isActive ? colors.contentStandardTertiary : tertiaryColor,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            )
          : typography.footnote.copyWith(
              color: tertiaryColor,
              fontWeight: FontWeight.w400,
            ),
    );
    final heading = titleLeading == null
        ? headingText
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleLeading!,
              const SizedBox(width: DFSpacing.spacing200),
              Expanded(child: headingText),
            ],
          );
    final contentStyle = typography.paragraphSmall.copyWith(
      color: secondaryColor,
      fontWeight: FontWeight.w400,
    );
    final contentRow = Text(
      content ?? '',
      style: contentStyle,
      maxLines: contentMaxLines,
      overflow: contentMaxLines == null
          ? TextOverflow.clip
          : TextOverflow.ellipsis,
    );
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null) ...[
          header!,
          const SizedBox(height: DFSpacing.spacing200),
        ],
        heading,
        if (!horizontal && content != null) ...[
          const SizedBox(height: DFSpacing.spacing150),
          contentRow,
        ],
      ],
    );
    final card = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DFSpacing.spacing500,
        vertical: DFSpacing.spacing400,
      ),
      decoration: BoxDecoration(
        color: switch (theme) {
          DFValueListTheme.disabled => colors.componentsTranslucentTertiary,
          DFValueListTheme.outlined => colors.componentsFillStandardPrimary,
          DFValueListTheme.active => colors.coreBrandPrimary,
        },
        borderRadius: BorderRadius.circular(DFRadius.radius500),
        border: Border.all(color: colors.lineOutline),
      ),
      child: trailing == null
          ? body
          : Row(
              crossAxisAlignment: trailingAlignment,
              children: [
                Expanded(child: body),
                const SizedBox(width: DFSpacing.spacing300),
                trailing!,
              ],
            ),
    );
    if (onTap == null || isDisabled) return card;
    return Semantics(
      button: true,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              onTap!();
              return null;
            },
          ),
        },
        child: DFGestureDetectorWithScaleInteraction(onTap: onTap, child: card),
      ),
    );
  }
}

class _DFValueListTitleRow extends StatelessWidget {
  final String title;
  final TextStyle titleStyle;
  final int? titleMaxLines;
  final String? leadingValue;
  final TextStyle leadingStyle;
  final String? trailingValue;
  final TextStyle trailingStyle;

  const _DFValueListTitleRow({
    required this.title,
    required this.titleStyle,
    this.titleMaxLines,
    required this.leadingValue,
    required this.leadingStyle,
    required this.trailingValue,
    required this.trailingStyle,
  });

  @override
  Widget build(BuildContext context) {
    final direction = Directionality.of(context);
    final scaler = MediaQuery.textScalerOf(context);
    double width(String value, TextStyle style) => TextPainter.computeWidth(
      text: TextSpan(text: value, style: style),
      textDirection: direction,
      textScaler: scaler,
      locale: Localizations.maybeLocaleOf(context),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final sideWidth =
            (leadingValue == null
                ? 0
                : width(leadingValue!, leadingStyle) + DFSpacing.spacing300) +
            (trailingValue == null
                ? 0
                : width(trailingValue!, trailingStyle) + DFSpacing.spacing300);
        final titleWidth = width(title, titleStyle);
        final minimumTitleWidth = titleWidth.clamp(
          0.0,
          constraints.maxWidth / 3,
        );
        final titleText = Text(
          title,
          style: titleStyle,
          maxLines: titleMaxLines,
          overflow: titleMaxLines == null
              ? TextOverflow.clip
              : TextOverflow.ellipsis,
        );
        final leadingText = leadingValue == null
            ? null
            : Text(leadingValue!, style: leadingStyle);
        final trailingText = trailingValue == null
            ? null
            : Text(
                trailingValue!,
                style: trailingStyle,
                textAlign: TextAlign.end,
              );

        // Preserve the natural width of side values in the existing list layout.
        // Only stack them when the available space would squeeze the title.
        if (sideWidth + minimumTitleWidth > constraints.maxWidth) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (leadingText == null)
                titleText
              else
                Wrap(
                  spacing: DFSpacing.spacing300,
                  runSpacing: DFSpacing.spacing150,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [leadingText, titleText],
                ),
              if (trailingText != null) ...[
                const SizedBox(height: DFSpacing.spacing150),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: trailingText,
                ),
              ],
            ],
          );
        }
        return Row(
          children: [
            if (leadingText != null) ...[
              leadingText,
              const SizedBox(width: DFSpacing.spacing300),
            ],
            Expanded(child: titleText),
            if (trailingText != null) ...[
              const SizedBox(width: DFSpacing.spacing300),
              trailingText,
            ],
          ],
        );
      },
    );
  }
}

enum DFItemListSize { small, large }

class DFItemList extends StatelessWidget {
  final DFItemListSize size;
  final String? title;
  final String? subTitle;
  final String? content;
  final Widget? leading;
  final Widget? trailing;
  final bool marquee;

  const DFItemList({
    super.key,
    this.size = DFItemListSize.large,
    this.title,
    this.subTitle,
    this.content,
    this.leading,
    this.trailing,
    this.marquee = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Container(
      padding: const EdgeInsets.only(
        left: DFSpacing.spacing100,
        // right: DFSpacing.spacing400,
        // top: DFSpacing.spacing400,
        // bottom: DFSpacing.spacing400,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(
              width: size == DFItemListSize.large
                  ? DFSpacing.spacing400
                  : DFSpacing.spacing300,
            ),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (subTitle != null) ...[
                  if (marquee) ...[
                    MarqueeText(
                      text: subTitle!,
                      style: size == DFItemListSize.large
                          ? textTheme.body.copyWith(
                              color: colorTheme.contentStandardSecondary,
                              fontWeight: FontWeight.w400,
                            )
                          : textTheme.footnote.copyWith(
                              color: colorTheme.contentStandardSecondary,
                              fontWeight: FontWeight.w400,
                            ),
                      velocity: 30.0,
                    ),
                  ] else ...[
                    Text(
                      subTitle!,
                      style: size == DFItemListSize.large
                          ? textTheme.body.copyWith(
                              color: colorTheme.contentStandardSecondary,
                              fontWeight: FontWeight.w400,
                            )
                          : textTheme.footnote.copyWith(
                              color: colorTheme.contentStandardSecondary,
                              fontWeight: FontWeight.w400,
                            ),
                    ),
                  ],
                ],
                if (title != null) ...[
                  if (marquee) ...[
                    MarqueeText(
                      text: title!,
                      style: size == DFItemListSize.large
                          ? textTheme.headline.copyWith(
                              color: colorTheme.contentStandardPrimary,
                              fontWeight: FontWeight.w700,
                            )
                          : textTheme.body.copyWith(
                              color: colorTheme.contentStandardPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                    ),
                  ] else ...[
                    Text(
                      title!,
                      style: size == DFItemListSize.large
                          ? textTheme.headline.copyWith(
                              color: colorTheme.contentStandardPrimary,
                              fontWeight: FontWeight.w700,
                            )
                          : textTheme.body.copyWith(
                              color: colorTheme.contentStandardPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                    ),
                  ],
                ],
                if (content != null) ...[
                  if (marquee) ...[
                    MarqueeText(
                      text: content!,
                      style: size == DFItemListSize.large
                          ? textTheme.paragraphLarge.copyWith(
                              color: colorTheme.contentStandardSecondary,
                              fontWeight: FontWeight.w400,
                            )
                          : textTheme.paragraphSmall.copyWith(
                              color: colorTheme.contentStandardSecondary,
                              fontWeight: FontWeight.w400,
                            ),
                    ),
                  ] else ...[
                    Text(
                      content!,
                      style: size == DFItemListSize.large
                          ? textTheme.paragraphLarge.copyWith(
                              color: colorTheme.contentStandardSecondary,
                              fontWeight: FontWeight.w400,
                            )
                          : textTheme.paragraphSmall.copyWith(
                              color: colorTheme.contentStandardSecondary,
                              fontWeight: FontWeight.w400,
                            ),
                    ),
                  ],
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            SizedBox(
              width: size == DFItemListSize.large
                  ? DFSpacing.spacing400
                  : DFSpacing.spacing300,
            ),
            trailing!,
          ],
        ],
      ),
    );
  }
}
