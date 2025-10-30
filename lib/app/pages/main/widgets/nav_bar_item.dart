import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../page.dart';

class NavBarItem extends StatelessWidget {
  final NavItemData item;
  final bool isSelected;
  final VoidCallback onTap;

  const NavBarItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                item.iconUrl,
                width: 28,
                height: 28,
                colorFilter: ColorFilter.mode(
                  isSelected
                      ? colorTheme.coreBrandPrimary
                      : colorTheme.coreBrandSecondary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: textTheme.footnote.copyWith(
                  color: isSelected
                      ? colorTheme.coreBrandPrimary
                      : colorTheme.coreBrandSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
