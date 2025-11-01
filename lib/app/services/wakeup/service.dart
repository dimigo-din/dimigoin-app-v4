import 'dart:async';
import 'dart:developer';
import 'package:dimigoin_app_v4/app/core/utils/errors.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:get/get.dart';

import 'model.dart';
import 'repository.dart';

class WakeupService extends GetxController {
  final WakeupRepository repository;

  AuthService authService = Get.find<AuthService>();

  WakeupService({WakeupRepository? repository}) : repository = repository ?? WakeupRepository();

  @override
  Future<void> onInit() async {
    super.onInit();
    initialize(); 
  }

  Future<void> initialize() async {
  }

  Future<List<WakeupApplicationWithVote>> getWakeupApplications() async {
    try {
      final response = await repository.getWakeupApplications();

      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<WakeupApplicationVotes>> getWakeupApplicationVotes() async {
    try {
      final response = await repository.getWakeupApplicationVotes();

      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> voteWakeupApplication(String applicationId, bool isUpvote) async {
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
}