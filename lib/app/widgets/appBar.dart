import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../widgets/gestureDetector.dart';

class DFAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool hasBackButton;
  final VoidCallback? onBackPressed;
  final double height;

  const DFAppBar({
    super.key,
    this.title,
    this.actions,
    this.hasBackButton = true,
    this.onBackPressed,
    this.height = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return AppBar(
      leading: hasBackButton
          ? DFGestureDetectorWithOpacityInteraction(
              onTap: onBackPressed ?? Get.back,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: colorTheme.contentStandardTertiary,
              ),
            )
          : null,
      title: Text(
        title ?? '',
        style: textTheme.headline.copyWith(
          color: colorTheme.contentStandardPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
