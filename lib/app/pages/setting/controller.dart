import 'package:dimigoin_app_v4/app/routes/routes.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/services/push/model.dart';
import 'package:dimigoin_app_v4/app/services/push/service.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackBar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum NotificationType {
  laundry,
  stay,
  wakeup,
  general,
}

class SettingController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final PushService pushService = Get.find<PushService>();

  RxString appVersion = "".obs;

  RxList<NotificationSubject> notificationSubjects = RxList<NotificationSubject>([]);
  RxList<String> notificationSubscribedSubject = RxList<String>([]);

  RxBool isLoadNotiSetting = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAppVersion();
    loadNotificationSettings();
  }

  Future<void> _loadAppVersion() async {
    try { 
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion.value = packageInfo.version;
    } catch (e) {
      appVersion.value = "";
    }
  }

  Future<void> loadNotificationSettings() async {
    if(kIsWeb) {
      return;
    }

    try {
      notificationSubjects.value = await pushService.getSubjects();
      notificationSubscribedSubject.value = await pushService.getSubscribedSubjects();

      isLoadNotiSetting.value = true;
    } catch (e) {
      isLoadNotiSetting.value = false;
      DFSnackBar.error("알림 설정을 불러오는데 실패했습니다. 네트워크에 연결되어 있는지 확인하세요.");
    }
  }

  Future<void> updateNotificationSettings(NotificationSubject subject) async {
    final hasPermission = await pushService.hasNotificationPermission;

    if (!hasPermission) {
      DFSnackBar.error("알림 권한이 없습니다. 권한을 허용해주세요.");
      await pushService.requestPushPermission();
      return;
    }

    final previousState = List<String>.from(notificationSubscribedSubject);

    try {
      if (notificationSubscribedSubject.contains(subject.id)) {
        notificationSubscribedSubject.remove(subject.id);
      } else {
        notificationSubscribedSubject.add(subject.id);
      }

      await pushService.updateSubscribedSubjects(notificationSubscribedSubject);

      DFSnackBar.success("알림 설정이 변경되었습니다.");
    } catch (e) {
      notificationSubscribedSubject.value = previousState;
      DFSnackBar.error("설정 변경에 실패했습니다. 네트워크에 연결되어 있는지 확인하세요.");
    }
  }

  Future<void> openPrivacyPolicy() async {
    await launchUrl(
      Uri.parse("https://dimigo-din.notion.site/25f98f8027c680a79e3ecf1e0cb6c6ff?source=copy_link"),
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> openOpenSourceLicenses() async {
    Get.toNamed(Routes.LICENSE);
  }
  
  Future<void> logout() async {
    await authService.logout();
    Get.offAllNamed('/login');
  }
}
