import 'package:get/get.dart';

import '../../provider/api_interface.dart';

class CalendarRepository {
  final ApiProvider api;

  CalendarRepository({ApiProvider? api}) : api = api ?? Get.find<ApiProvider>();
}
