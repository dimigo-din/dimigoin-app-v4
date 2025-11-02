import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:flutter/material.dart';

class WakeupVoteButton extends StatelessWidget {
  final int count;
  final bool isUpvote;
  final bool isVoted;
  final VoidCallback? onPressed;

  const WakeupVoteButton({
    super.key,
    required this.count,
    required this.isUpvote,
    required this.isVoted,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        padding: const EdgeInsets.symmetric(
          horizontal: DFSpacing.spacing200,
          vertical: DFSpacing.spacing50,
        ),
        decoration: BoxDecoration(
          color: colorTheme.componentsFillStandardPrimary,
          borderRadius: BorderRadius.circular(DFRadius.radius400),
          border: Border.all(
            color: isVoted ? colorTheme.coreBrandPrimary : colorTheme.lineOutline,
            width: isVoted ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "$count",
              style: textTheme.callout.copyWith(
                color: colorTheme.contentStandardPrimary,
              ),
            ),
            const SizedBox(width: DFSpacing.spacing200),
            Icon(
              isUpvote ? Icons.thumb_up : Icons.thumb_down,
              size: 16,
              color: colorTheme.contentStandardPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
