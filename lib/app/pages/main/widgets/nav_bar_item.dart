import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:vector_graphics/vector_graphics.dart';
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
              IndexedStack(
                index: isSelected ? 1 : 0,
                children: [
                  VectorGraphic(
                    loader: item.icon,
                    width: 28,
                    height: 28,
                    colorFilter: ColorFilter.mode(
                      colorTheme.coreBrandSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                  VectorGraphic(
                    loader: item.filledIcon,
                    width: 28,
                    height: 28,
                    colorFilter: ColorFilter.mode(
                      colorTheme.coreBrandPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
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
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
