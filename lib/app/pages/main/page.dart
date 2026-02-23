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
    NavItemData('assets/icons/menu/home.svg', '홈'),
    NavItemData('assets/icons/menu/meal.svg', '급식'),
    NavItemData('assets/icons/menu/office.svg', '생활관'),
    NavItemData('assets/icons/menu/washer.svg', '일정'),
    NavItemData('assets/icons/menu/others.svg', '더보기'),
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
  final String iconUrl;
  final String label;
  const NavItemData(this.iconUrl, this.label);
}
