import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:flutter/material.dart';
import '../page.dart';
import 'nav_bar_item.dart';

class BottomNavBar extends StatelessWidget {
  final List<NavItemData> items;
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DFSpacing.spacing600,
        vertical: DFSpacing.spacing200,
      ),
      decoration: BoxDecoration(
        color: colorTheme.backgroundStandardPrimary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(DFRadius.radius800),
          topRight: Radius.circular(DFRadius.radius800),
        ),
        boxShadow: [
          BoxShadow(
            color: colorTheme.lineOutline,
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          items.length,
          (index) => NavBarItem(
            item: items[index],
            isSelected: currentIndex == index,
            onTap: () => onTap(index),
          ),
        ),
      ),
    );
  }
}
