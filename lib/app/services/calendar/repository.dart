import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../provider/api_interface.dart';
import '../../provider/model/response.dart';
import 'model.dart';

class CalendarRepository {
  final ApiProvider api;

  CalendarRepository({ApiProvider? api}) : api = api ?? Get.find<ApiProvider>();

}
