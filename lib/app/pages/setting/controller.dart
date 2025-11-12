import 'package:dimigoin_app_v4/app/routes/routes.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/services/push/service.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackBar.dart';
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

  RxBool noti_laundry = false.obs;
  RxBool noti_stay = false.obs;
  RxBool noti_wakeup = false.obs;
  RxBool noti_general = false.obs;

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
    try {
      final subscribedTopics = await pushService.getSubscribedTopics();

      noti_laundry.value = subscribedTopics.contains('laundry');
      noti_stay.value = subscribedTopics.contains('stay');
      noti_wakeup.value = subscribedTopics.contains('wakeup');
      noti_general.value = subscribedTopics.contains('general');

      isLoadNotiSetting.value = true;
    } catch (e) {
      isLoadNotiSetting.value = false;
      DFSnackBar.error("알림 설정을 불러오는데 실패했습니다. 네트워크에 연결되어 있는지 확인하세요.");
    }
  }

  Future<void> updateNotificationSettings() async {
    List<String> topics = [];

    if (noti_laundry.value) topics.add('laundry');
    if (noti_stay.value) topics.add('stay');
    if (noti_wakeup.value) topics.add('wakeup');
    if (noti_general.value) topics.add('general');

    try {
      await pushService.updateSubscribedTopics(topics);
    } catch (e) {
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
