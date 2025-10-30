import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFAvatar.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFIconButton.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFList.dart';
import 'package:dimigoin_app_v4/app/widgets/gestureDetector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



import '../../core/theme/colors.dart';
import '../../core/theme/static.dart';
import 'controller.dart';

// ignore: must_be_immutable
class OthersPage extends GetView<OthersPageController> {
  OthersPage({super.key});
  AuthService authService = Get.find<AuthService>();

  Widget _othersPageItem({required String title, required VoidCallback onTap}) {
    return DFGestureDetectorWithOpacityInteraction(
      onTap: () => {},
      child: DFGestureDetectorWithScaleInteraction(
        onTap: onTap,
        child: DFValueList(
          type: DFValueListType.horizontal,
          theme: DFValueListTheme.outlined,
          title: title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return SafeArea(
      child: Padding(
        padding:
          const EdgeInsets.symmetric(horizontal: DFSpacing.spacing400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: DFSpacing.spacing400, horizontal: DFSpacing.spacing300),
              decoration: BoxDecoration(
                color: colorTheme.componentsFillStandardPrimary,
                borderRadius: BorderRadius.circular(DFRadius.radius800),
                border: Border.all(
                  color: colorTheme.lineOutline,
                  width: 1,
                ),
              ),
              child: Obx(() => DFItemList(
                title: authService.user?.name,
                subTitle: "${authService.user!.number.substring(0, 1)}학년 ${authService.user!.number.substring(1, 2)}반 ${int.parse(authService.user!.number.substring(2, 4)).toString()}번",
                leading: DFAvatar(
                  type: DFAvatarType.person,
                  size: DFAvatarSize.large,
                  fill: DFAvatarFill.image,
                  image: Image.network(authService.user?.profileUrl ?? ''),
                ),
                trailing: DFIconButton(
                  theme: DFIconButtonTheme.grayscale,
                  icon: const Icon(Icons.logout),
                  onPressed: controller.logout,
                ),
              )),
            ),
            SizedBox(height: 20),
            _othersPageItem(
              title: "DIN에 문의하기",
              onTap: () => controller.launchMenuUrl("https://pf.kakao.com/_fxhZen/chat"),
            ),      
            const SizedBox(height: 5),
            _othersPageItem(
              title: "개인정보 처리방침",
              onTap: () => controller.launchMenuUrl("https://dimigo-din.notion.site/25f98f8027c680a79e3ecf1e0cb6c6ff?source=copy_link"),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(bottom: DFSpacing.spacing400),
              child: Text(
                "Copyright 2025. DIN Org. All rights reserved.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}