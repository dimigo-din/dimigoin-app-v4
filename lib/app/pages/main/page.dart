import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/pages/meal/binding.dart';
import 'package:dimigoin_app_v4/app/pages/meal/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:dimigoin_app_v4/app/pages/home/page.dart';
import 'package:dimigoin_app_v4/app/pages/dorm/page.dart';
import 'package:dimigoin_app_v4/app/pages/calendar/page.dart';
import 'package:dimigoin_app_v4/app/pages/others/page.dart';
import 'package:dimigoin_app_v4/app/pages/home/binding.dart';
import 'package:dimigoin_app_v4/app/pages/dorm/binding.dart';
import 'package:dimigoin_app_v4/app/pages/calendar/binding.dart';
import 'package:dimigoin_app_v4/app/pages/others/binding.dart';
import 'package:vector_graphics/vector_graphics.dart';

import 'widgets/bottom_nav_bar.dart';

class MainPageController extends GetxController {
  RxInt currentIndex = 0.obs;
  final Set<int> _initializedTabs = <int>{};

  bool isTabInitialized(int index) => _initializedTabs.contains(index);

  void _ensureTabInitialized(int index) {
    if (_initializedTabs.contains(index)) return;
    _initializedTabs.add(index);

    switch (index) {
      case 0:
        HomePageBinding().dependencies();
        break;
      case 1:
        MealPageBinding().dependencies();
        break;
      case 2:
        DormPageBinding().dependencies();
        break;
      case 3:
        CalendarPageBinding().dependencies();
        break;
      case 4:
        OthersPageBinding().dependencies();
        break;
    }
  }

  void changePage(int index) {
    HapticFeedback.lightImpact();

    _ensureTabInitialized(index);
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    _ensureTabInitialized(0);
  }
}

class MainPage extends StatelessWidget {
  MainPage({super.key});
  final MainPageController controller = Get.put(MainPageController());

  final List<NavItemData> navItems = const [
    NavItemData(
      AssetBytesLoader('assets/icons/menu/home.svg.vec'),
      AssetBytesLoader('assets/icons/menu/fill/home.svg.vec'),
      '홈',
    ),
    NavItemData(
      AssetBytesLoader('assets/icons/menu/meal.svg.vec'),
      AssetBytesLoader('assets/icons/menu/fill/meal.svg.vec'),
      '급식',
    ),
    NavItemData(
      AssetBytesLoader('assets/icons/menu/office.svg.vec'),
      AssetBytesLoader('assets/icons/menu/fill/office.svg.vec'),
      '생활관',
    ),
    NavItemData(
      AssetBytesLoader('assets/icons/menu/calendar.svg.vec'),
      AssetBytesLoader('assets/icons/menu/fill/calendar.svg.vec'),
      '일정',
    ),
    NavItemData(
      AssetBytesLoader('assets/icons/menu/my.svg.vec'),
      AssetBytesLoader('assets/icons/menu/fill/my.svg.vec'),
      '내 정보',
    ),
  ];

  final List<Widget Function()> pageBuilders = [
    () => HomePage(),
    () => MealPage(),
    () => DormPage(),
    () => CalendarPage(),
    () => OthersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return Container(
      decoration: BoxDecoration(color: colorTheme.backgroundStandardPrimary),
      child: SafeArea(
        top: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            toolbarHeight: 80,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DFSpacing.spacing550,
                vertical: DFSpacing.spacing400,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/dimigoin_icon.png', height: 35),
                ],
              ),
            ),
          ),
          body: Obx(
            () => IndexedStack(
              index: controller.currentIndex.value,
              children: List.generate(pageBuilders.length, (i) {
                if (!controller.isTabInitialized(i)) {
                  return const SizedBox.shrink();
                }
                return pageBuilders[i]();
              }),
            ),
          ),
          bottomNavigationBar: Obx(
            () => BottomNavBar(
              items: navItems,
              currentIndex: controller.currentIndex.value,
              onTap: controller.changePage,
            ),
          ),
        ),
      ),
    );
  }
}

class NavItemData {
  final AssetBytesLoader icon;
  final AssetBytesLoader filledIcon;
  final String label;
  const NavItemData(this.icon, this.filledIcon, this.label);
}
