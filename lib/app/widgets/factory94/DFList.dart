import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/widgets/marqueeText.dart';
import 'package:flutter/material.dart';
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

  const DFValueList({
    super.key,
    required this.type,
    this.theme = DFValueListTheme.active,
    required this.title,
    this.subTitle,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DFSpacing.spacing500,
        vertical: DFSpacing.spacing400,
      ),
      decoration: BoxDecoration(
        color: switch (theme) {
          DFValueListTheme.disabled => colorTheme.componentsTranslucentTertiary,
          DFValueListTheme.outlined => colorTheme.componentsFillStandardPrimary,
          DFValueListTheme.active => colorTheme.coreBrandPrimary,
        },
        borderRadius: BorderRadius.circular(DFRadius.radius500),
        border: Border.all(
          color: colorTheme.lineOutline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (type == DFValueListType.horizontal) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (subTitle != null) ...[
                  Text(
                    subTitle!,
                    style: textTheme.callout.copyWith(
                      color: switch (theme) {
                        DFValueListTheme.disabled => colorTheme.contentStandardQuaternary,
                        DFValueListTheme.outlined => colorTheme.contentStandardTertiary,
                        DFValueListTheme.active => colorTheme.solidWhite,
                      },
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: DFSpacing.spacing300),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.body.copyWith(
                      color: switch (theme) {
                        DFValueListTheme.disabled => colorTheme.contentStandardPrimary,
                        DFValueListTheme.outlined => colorTheme.contentStandardPrimary,
                        DFValueListTheme.active => colorTheme.solidWhite,
                      },
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (content != null) ...[
                  const SizedBox(width: DFSpacing.spacing300),
                  Text(
                    content!,
                    style: textTheme.callout.copyWith(
                      color: switch (theme) {
                        DFValueListTheme.disabled => colorTheme.contentStandardQuaternary,
                        DFValueListTheme.outlined => colorTheme.contentStandardTertiary,
                        DFValueListTheme.active => colorTheme.solidWhite,
                      },
                      fontWeight: switch (theme) {
                        DFValueListTheme.disabled => FontWeight.w500,
                        DFValueListTheme.outlined => FontWeight.w500,
                        DFValueListTheme.active => FontWeight.w700,
                      },
                    ),
                  ),
                ],
              ],
            )
          ]
          else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.headline.copyWith(
                      color: switch (theme) {
                        DFValueListTheme.disabled => colorTheme.contentStandardPrimary,
                        DFValueListTheme.outlined => colorTheme.contentStandardPrimary,
                        DFValueListTheme.active => colorTheme.contentInvertedPrimary,
                      },
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (subTitle != null) ...[
                  const SizedBox(width: DFSpacing.spacing300),
                  Text(
                    subTitle!,
                    style: textTheme.footnote.copyWith(
                      color: switch (theme) {
                        DFValueListTheme.disabled => colorTheme.contentStandardQuaternary,
                        DFValueListTheme.outlined => colorTheme.contentStandardTertiary,
                        DFValueListTheme.active => colorTheme.contentInvertedPrimary,
                      },
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
            if (content != null) ...[
              const SizedBox(height: DFSpacing.spacing150),
              Text(
                content!,
                style: textTheme.paragraphSmall.copyWith(
                  color: switch (theme) {
                    DFValueListTheme.disabled => colorTheme.contentStandardQuaternary,
                    DFValueListTheme.outlined => colorTheme.contentStandardSecondary,
                    DFValueListTheme.active => colorTheme.contentInvertedPrimary,
                  },
                  fontWeight: FontWeight.w400,
                ),
              ),
            ]
          ]
        ],
      )
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
    this.marquee = false
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
            SizedBox(width: size == DFItemListSize.large ? DFSpacing.spacing400 : DFSpacing.spacing300),
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
                  ] else ... [
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
                  ]
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
                  ] else ... [
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
                  ]
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
                  ]
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: size == DFItemListSize.large ? DFSpacing.spacing400 : DFSpacing.spacing300),
            trailing!,
          ],
        ],
      )
    );
  }
}