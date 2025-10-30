import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';

enum DFHeaderSize { small, large }

class DFHeader extends StatelessWidget {
  final String title;
  final String? content;
  final DFHeaderSize size;
  final String? subTitle;

  const DFHeader({
    super.key,
    required this.title,
    this.content,
    this.size = DFHeaderSize.large,
    this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (subTitle != null) ...[
            Text(
              subTitle!,
              style: size == DFHeaderSize.large
                  ? textTheme.footnote.copyWith(
                    color: colorTheme.contentStandardSecondary,
                    fontWeight: FontWeight.w400,
                  )
                  : textTheme.caption.copyWith(
                    color: colorTheme.contentStandardSecondary,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            const SizedBox(height: DFSpacing.spacing100),
          ],
          Text(
            title,
            style: size == DFHeaderSize.large
                ? textTheme.headline.copyWith(
                  color: colorTheme.contentStandardPrimary,
                  fontWeight: FontWeight.w700,
                )
                : textTheme.body.copyWith(
                  color: colorTheme.contentStandardPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
          if (content != null) ...[
            const SizedBox(height: DFSpacing.spacing100),
            Text(
              content!,
              style: size == DFHeaderSize.large
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
      ),
    );
  }
}

enum DFSectionHeaderSize { small, medium, large }

class DFSectionHeader extends StatelessWidget {
  final DFSectionHeaderSize size;
  final String title;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final String? trailingText;
  final Widget? trailingArea;

  const DFSectionHeader({
    super.key,
    required this.size,
    required this.title,
    this.leftIcon,
    this.rightIcon,
    this.trailingText,
    this.trailingArea,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (leftIcon != null) ...[
                Icon(leftIcon, size: 16, color: colorTheme.contentStandardPrimary),
                const SizedBox(width: DFSpacing.spacing300),
              ],
              Text(
                title,
                style: size == DFSectionHeaderSize.large
                    ? textTheme.title.copyWith(
                      color: colorTheme.contentStandardPrimary,
                      fontWeight: FontWeight.w700,
                    )
                    : size == DFSectionHeaderSize.medium
                        ? textTheme.headline.copyWith(
                          color: colorTheme.contentStandardPrimary,
                          fontWeight: FontWeight.w700,
                        )
                        : textTheme.callout.copyWith(
                          color: colorTheme.contentStandardPrimary,
                          fontWeight: FontWeight.w500,
                        ),
              ),
              if (rightIcon != null) ...[
                const SizedBox(width: DFSpacing.spacing200),
                Icon(rightIcon, size: 16, color: colorTheme.contentStandardPrimary),
              ],
            ],
          ),
          Row(
            children: [
              if (trailingText != null) ...[
                Text(
                  trailingText!,
                  style: size == DFSectionHeaderSize.large
                      ? textTheme.body.copyWith(
                        color: colorTheme.contentStandardSecondary,
                        fontWeight: FontWeight.w400,
                      )
                      : size == DFSectionHeaderSize.medium
                          ? textTheme.body.copyWith(
                            color: colorTheme.contentStandardSecondary,
                            fontWeight: FontWeight.w400,
                          )
                          : textTheme.callout.copyWith(
                            color: colorTheme.contentStandardSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                ),
                const SizedBox(width: DFSpacing.spacing200),
              ],
              if (trailingArea != null) trailingArea!,
            ],
          ),
        ],
      )
    );
  }
}