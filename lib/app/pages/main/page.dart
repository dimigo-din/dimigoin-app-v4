import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:dimigoin_app_v4/app/pages/home/page.dart';
import 'package:dimigoin_app_v4/app/pages/stay/page.dart';
import 'package:dimigoin_app_v4/app/pages/wakeup/page.dart';
import 'package:dimigoin_app_v4/app/pages/laundry/page.dart';
import 'package:dimigoin_app_v4/app/pages/others/page.dart';

import 'package:dimigoin_app_v4/app/pages/home/binding.dart';
import 'package:dimigoin_app_v4/app/pages/stay/binding.dart';
import 'package:dimigoin_app_v4/app/pages/wakeup/binding.dart';
import 'package:dimigoin_app_v4/app/pages/laundry/binding.dart';
import 'package:dimigoin_app_v4/app/pages/others/binding.dart';

import 'widgets/bottom_nav_bar.dart';

class MainPageController extends GetxController {
  RxInt currentIndex = 0.obs;
  void changePage(int index) {
    HapticFeedback.lightImpact();

    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();

    HomePageBinding().dependencies();
    StayPageBinding().dependencies();
    WakeupPageBinding().dependencies();
    LaundryPageBinding().dependencies();
    OthersPageBinding().dependencies();
  }
}

class MainPage extends StatelessWidget {
  MainPage({super.key});
  final MainPageController controller = Get.put(MainPageController());

  final List<NavItemData> navItems = const [
    NavItemData('assets/icons/menu/home.svg', '홈'),
    NavItemData('assets/icons/menu/office.svg', '잔류·금귀'),
    NavItemData('assets/icons/menu/music.svg', '기상곡'),
    NavItemData('assets/icons/menu/washer.svg', '세탁'),
    NavItemData('assets/icons/menu/others.svg', '더보기'),
  ];

  final List<_PageBindingSet> pages = [
    _PageBindingSet(HomePage(), HomePageBinding()),
    _PageBindingSet(StayPage(), StayPageBinding()),
    _PageBindingSet(WakeupPage(), WakeupPageBinding()),
    _PageBindingSet(LaundryPage(), LaundryPageBinding()),
    _PageBindingSet(OthersPage(), OthersPageBinding()),
  ];

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    
    return Container(
      decoration: BoxDecoration(
        color: colorTheme.backgroundStandardPrimary,
      ),
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
                  Image.asset(
                    'assets/images/dimigoin_icon.png',
                    height: 35,
                  )
                ],
              ),
            ),
          ),
          body: Obx(
            () => IndexedStack(
              index: controller.currentIndex.value,
              children: pages.map((set) => set.page).toList(),
            ),
          ),
          bottomNavigationBar: Obx(
            () => BottomNavBar(
              items: navItems,
              currentIndex: controller.currentIndex.value,
              onTap: controller.changePage,
            ),
          ),
        )
      ),
    );
  }
}

class _PageBindingSet {
  final Widget page;
  final Bindings binding;
  _PageBindingSet(this.page, this.binding);
}

class NavItemData {
  final String iconUrl;
  final String label;
  const NavItemData(this.iconUrl, this.label);
}
