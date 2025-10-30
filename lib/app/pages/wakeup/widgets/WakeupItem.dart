import 'package:dimigoin_app_v4/app/widgets/marqueeText.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/static.dart';
import '../../../core/theme/typography.dart';


class WakeupItem extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? content;
  final Widget? leading;
  final Widget? trailing;

  const WakeupItem({
    super.key,
    this.title,
    this.subTitle,
    this.content,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Container(
      padding: const EdgeInsets.only(
        left: DFSpacing.spacing100,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: DFSpacing.spacing400),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (subTitle != null) ...[
                  MarqueeText(
                    text: subTitle!,
                    style: textTheme.footnote.copyWith(
                        color: colorTheme.contentStandardSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                    velocity: 30.0,
                  ),
                ],
                if (title != null) ...[
                  MarqueeText(
                    text: title!,
                    style: textTheme.body.copyWith(
                      color: colorTheme.contentStandardPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (content != null) ...[
                  MarqueeText(
                    text: content!,
                    style: textTheme.paragraphSmall.copyWith(
                      color: colorTheme.contentStandardSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: DFSpacing.spacing400),
            trailing!,
          ],
        ],
      )
    );
  }
}