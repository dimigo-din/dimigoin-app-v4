import 'dart:async';
import 'dart:developer';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:get/get.dart';

import 'repository.dart';
import 'state.dart';

class UserService extends GetxController {
  final UserRepository repository;

  AuthService authService = Get.find<AuthService>();

  final Rx<UserApplyState> _userApplyState = Rx<UserApplyState>(
    const UserApplyInitial(),
  );
  UserApplyState get userApplyState => _userApplyState.value;

  final Rx<UserTimelineState> _timelineState = Rx<UserTimelineState>(
    const UserTimelineInitial(),
  );
  UserTimelineState get timelineState => _timelineState.value;

  UserService({UserRepository? repository})
    : repository = repository ?? UserRepository();

  @override
  Future<void> onInit() async {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {}

  Future<void> getTimeline(int userGrade, int userClass) async {
    _timelineState.value = UserTimelineLoading();
    try {
      final response = await repository.getTimeline(userGrade, userClass);

      _timelineState.value = UserTimelineSuccess(response);
    } catch (e) {
      log(e.toString());
      _timelineState.value = UserTimelineFailure(e.toString());
      rethrow;
    }
  }

  Future<void> getUserApply() async {
    _userApplyState.value = UserApplyLoading();
    try {
      final response = await repository.getUserApply();

      _userApplyState.value = UserApplySuccess(response);
    } catch (e) {
      _userApplyState.value = UserApplyFailure(e.toString());
      log(e.toString());
      rethrow;
    }
  }
}
