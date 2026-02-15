import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../provider/api_interface.dart';
import '../../provider/model/response.dart';
import 'model.dart';

class MealRepository {
  final ApiProvider api;

  MealRepository({ApiProvider? api}) : api = api ?? Get.find<ApiProvider>();

  Future<Meal> getMeal({String? date}) async {
    const String url = '/student/meal';

    try {
      final queryParameters = <String, dynamic>{
        if (date != null && date.isNotEmpty) 'date': date,
      };

      DFHttpResponse response = await api.get(
        url,
        queryParameters: queryParameters,
      );

      return Meal.fromJson(response.data['data']);
    } on DioException {
      rethrow;
    }
  }
}
