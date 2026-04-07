import 'dart:async';
import 'dart:developer';
import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/services/wakeup/state.dart';
import 'package:get/get.dart';

import 'model.dart';
import 'repository.dart';

class WakeupService extends GetxController {
  final WakeupRepository repository;

  AuthService authService = Get.find<AuthService>();

  final Rx<WakeupState> _wakeupState = Rx<WakeupState>(
    const WakeupInitial(),
  );
  WakeupState get wakeupState => _wakeupState.value;

  final Rx<WakeupVoteState> _wakeupVoteState = Rx<WakeupVoteState>(
    const WakeupVoteInitial(),
  );
  WakeupVoteState get wakeupVoteState => _wakeupVoteState.value;

  WakeupService({WakeupRepository? repository})
    : repository = repository ?? WakeupRepository();

  @override
  Future<void> onInit() async {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {}

  Future<void> getWakeupApplications() async {
    _wakeupState.value = const WakeupLoading();
    try {
      final response = await repository.getWakeupApplications();

      _wakeupState.value = WakeupSuccess(response);
    } catch (e) {
      log(e.toString());
      _wakeupState.value = WakeupFailure(e.toString());
      rethrow;
    }
  }

  Future<void> getWakeupApplicationVotes() async {
    _wakeupVoteState.value = const WakeupVoteLoading();
    try {
      final response = await repository.getWakeupApplicationVotes();

      _wakeupVoteState.value = WakeupVoteSuccess(response);
    } catch (e) {
      log(e.toString());
      _wakeupVoteState.value = WakeupVoteFailure(e.toString());
      rethrow;
    }
  }

  Future<void> voteWakeupApplication(
    String applicationId,
    bool isUpvote,
  ) async {
    try {
      await repository.voteWakeupApplication(applicationId, isUpvote);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> deleteVoteWakeupApplication(String voteId) async {
    try {
      await repository.deleteVoteWakeupApplication(voteId);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<YoutubeSearchResult> searchYoutube(String query) async {
    try {
      final response = await repository.searchYoutube(query);

      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> applyWakeupSong(String videoId) async {
    try {
      await repository.applyWakeupSong(videoId);
    } on ResourceAlreadyExists {
      rethrow;
    } on ResourceNotFoundException {
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<WakeupApplicationWithVote?> getWakeupHistory() async {
    try {
      return await repository.getWakeupHistory();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
