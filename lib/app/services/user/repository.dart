import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../provider/api_interface.dart';
import '../../provider/model/response.dart';

import 'model.dart';

class UserRepository {
  final ApiProvider api;

  UserRepository({ApiProvider? api}) : api = api ?? Get.find<ApiProvider>();

  Future<Timetable> getTimeline(int userGrade, int userClass) async {
    String url = '/student/user/timeline';

    try {
      DFHttpResponse response = await api.get(url, queryParameters: {
        'grade': userGrade,
        'class': userClass,
      });

      return Timetable.fromJson(response.data['data']);
    } on DioException {
      rethrow;
    }
  }

  Future<UserApply> getUserApply() async {
    String url = '/student/user/apply';

    try {
      DFHttpResponse response = await api.get(url);

      return UserApply.fromJson(response.data['data']);
    } on DioException {
      rethrow;
    }
  }

}