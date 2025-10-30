import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class OthersPageController extends GetxController {
  final AuthService authService = Get.find<AuthService>();

  Future<void> logout() async {
    await authService.logout();
    Get.offAllNamed('/login');
  }

  Future<void> launchMenuUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
