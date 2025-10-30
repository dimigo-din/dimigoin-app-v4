import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../provider/api_interface.dart';
import '../../provider/model/response.dart';

import 'model.dart';

class WakeupRepository {
  final ApiProvider api;
  AuthService authService = Get.find<AuthService>();

  WakeupRepository({ApiProvider? api}) : api = api ?? Get.find<ApiProvider>();

  Future<List<WakeupApplicationWithVote>> getWakeupApplications() async {
    String url = '/student/wakeup';

    try {
      DFHttpResponse response = await api.get(url);

      return (response.data['data'] as List)
          .map((e) => WakeupApplicationWithVote.fromJson(e))
          .toList();
    } on DioException {
      rethrow;
    }
  }

  Future<List<WakeupApplicationVotes>> getWakeupApplicationVotes() async {
    String url = '/student/wakeup/vote';

    try {
      DFHttpResponse response = await api.get(url);

      return (response.data['data'] as List)
          .map((e) => WakeupApplicationVotes.fromJson(e))
          .toList();
    } on DioException {
      rethrow;
    }
  }

  Future<void> voteWakeupApplication(String applicationId, bool isUpvote) async {
    String url = '/student/wakeup/vote';

    try {
      await api.post(url, data: {
        'songId': applicationId,
        'upvote': isUpvote,
      });
    } on DioException {
      rethrow;
    }
  }

  Future<void> deleteVoteWakeupApplication(String voteId) async {
    String url = '/student/wakeup/vote';

    try {
      await api.delete(url, queryParameters: {
        'id': voteId,
      });
    } on DioException {
      rethrow;
    }
  }

  Future<YoutubeSearchResult> searchYoutube(String query) async {
    String url = '/student/wakeup/search';

    try {
      DFHttpResponse response = await api.get(url, queryParameters: {
        'query': query,
      });
      return YoutubeSearchResult.fromJson(response.data['data']);
    } on DioException {
      rethrow;
    }
  }

  Future<void> applyWakeupSong(String youtubeVideoId) async {
    String url = '/student/wakeup';

    try {
      await api.post(url, data: {
        'videoId': youtubeVideoId,
      });
    } on DioException {
      rethrow;
    }
  }
}