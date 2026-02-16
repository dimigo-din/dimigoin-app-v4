import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:flutter/material.dart';

import '../core/theme/colors.dart';
import '../core/theme/typography.dart';

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
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return AppBar(
      toolbarHeight: 80,
      elevation: 0,
      leading: hasBackButton
        ? IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: colorTheme.contentStandardTertiary,
            ),
            onPressed: onBackPressed ?? () {
              Navigator.of(context).maybePop();
            },
          )
        : null,
      title: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: DFSpacing.spacing400,
        ),
        child: title != null
          ? Text(
              title!,
              style: textTheme.title.copyWith(
                color: colorTheme.contentStandardPrimary,
                fontWeight: FontWeight.w700,
              ),
            )
          : Image.asset(
            'assets/images/dimigoin_icon.png',
            height: 35,
          ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
