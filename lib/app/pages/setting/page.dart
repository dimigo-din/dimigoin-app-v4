import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/widgets/appBar.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFControl.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFDivider.dart';
import 'package:dimigoin_app_v4/app/widgets/gestureDetector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class SettingPage extends GetView<SettingController> {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: colorTheme.backgroundStandardSecondary,
        appBar: const DFAppBar(
          title: '설정'
        ),
        body: ListView(
          physics: const ClampingScrollPhysics(),
          children: [
            const MenuHeader(
              title: "알림 설정",
            ),
            MenuItem(
              title: "학교 정보 알림",
              trailing: Obx(() => DFControl(
                type: DFControlType.toggle,
                status: controller.noti_general.value,
                onTap: () => controller.noti_general.value = !controller.noti_general.value,
                disabled: controller.isLoadNotiSetting.value == false,
              )),
            ),
            MenuItem(
              title: "세탁 알림",
              trailing: Obx(() => DFControl(
                type: DFControlType.toggle,
                status: controller.noti_laundry.value,
                onTap: () => controller.noti_laundry.value = !controller.noti_laundry.value,
                disabled: controller.isLoadNotiSetting.value == false,
              )),
            ),
            MenuItem(
              title: "잔류 신청 알림",
              trailing: Obx(() => DFControl(
                type: DFControlType.toggle,
                status: controller.noti_stay.value,
                onTap: () => controller.noti_stay.value = !controller.noti_stay.value,
                disabled: controller.isLoadNotiSetting.value == false,
              )),
            ),
            MenuItem(
              title: "오늘의 기상곡 알림",
              trailing: Obx(() => DFControl(
                type: DFControlType.toggle,
                status: controller.noti_wakeup.value,
                onTap: () => controller.noti_wakeup.value = !controller.noti_wakeup.value,
                disabled: controller.isLoadNotiSetting.value == false,
              )),
            ),
            const SizedBox(height: DFSpacing.spacing300),
            const DFDivider(size: DFDividerSize.medium),
            const MenuHeader(
              title: "앱 정보"
            ),
            MenuItem(
              title: "개인정보 처리방침",
              onTap: () => controller.openPrivacyPolicy(),
            ),
            MenuItem(
              title: "오픈소스 라이선스",
              onTap: () => controller.openOpenSourceLicenses(),
            ),
            MenuItem(
              title: "버전 정보",
              trailing: Obx(() => Text(
                "v${controller.appVersion.value}",
                style: Theme.of(context).extension<DFTypography>()!.body.copyWith(
                  color: colorTheme.contentStandardSecondary,
                  fontWeight: FontWeight.w400,
                ),
              )),
            ),
            const SizedBox(height: DFSpacing.spacing300),
            const DFDivider(size: DFDividerSize.medium),
            const MenuHeader(
              title: "계정 정보"
            ),
            MenuItem(
              title: "로그아웃",
              trailing: GestureDetector(
                onTap: () => controller.logout(),
                child: Icon(
                  Icons.logout,
                  color: colorTheme.contentStandardSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MenuItem extends StatelessWidget {
  final String? title;
  final Widget? leading;
  final Widget? trailing;
  final bool? disabled;
  final void Function()? onTap;

  const MenuItem({
    super.key,
    this.title,
    this.leading,
    this.trailing,
    this.disabled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Opacity(
      opacity: disabled! ? 0.3 : 1.0,
      child: DFGestureDetectorWithFillInteraction(
        onTap: disabled == true ? null : onTap,
        child: Container(
          padding: const EdgeInsets.only(
            left: DFSpacing.spacing500,
            right: DFSpacing.spacing500,
          ),
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title!,
                      style: textTheme.body.copyWith(
                        color: colorTheme.contentStandardPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: DFSpacing.spacing300),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class MenuHeader extends StatelessWidget {
  final String? title;

  const MenuHeader({
    super.key,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Container(
      padding: const EdgeInsets.only(
        left: DFSpacing.spacing500,
        top: DFSpacing.spacing800,
        right: DFSpacing.spacing500,
        bottom: DFSpacing.spacing400,
      ),
      child: Text(
        title!,
        style: textTheme.footnote.copyWith(
          color: colorTheme.contentStandardSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}