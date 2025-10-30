import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:flutter/material.dart';

class LaundryCancelDialog {
  static Future<bool?> show(BuildContext context) async {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: colorTheme.componentsFillStandardTertiary,
          title: Text(
            "세탁 신청 취소",
            style: textTheme.headline.copyWith(
              color: colorTheme.contentStandardPrimary,
            ),
          ),
          content: Text(
            "정말로 세탁 신청을 취소하시겠습니까?",
            style: textTheme.body.copyWith(
              color: colorTheme.contentStandardPrimary,
            ),
          ),
          actions: [
            TextButton(
              child: const Text("아니요"),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            TextButton(
              child: const Text("예"),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
