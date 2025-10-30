import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class Thumbnail {
  final String url;
  final int? width;
  final int? height;

  Thumbnail({
    required this.url,
    this.width,
    this.height,
  });

  factory Thumbnail.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailFromJson(json);
  Map<String, dynamic> toJson() => _$ThumbnailToJson(this);
}

@JsonSerializable()
class Thumbnails {
  @JsonKey(name: 'default')
  final Thumbnail defaultThumbnail;
  final Thumbnail medium;
  final Thumbnail high;

  Thumbnails({
    required this.defaultThumbnail,
    required this.medium,
    required this.high,
  });

  factory Thumbnails.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailsFromJson(json);
  Map<String, dynamic> toJson() => _$ThumbnailsToJson(this);
}

@JsonSerializable()
class VideoId {
  final String kind;
  final String? videoId;

  VideoId({
    required this.kind,
    this.videoId,
  });

  factory VideoId.fromJson(Map<String, dynamic> json) =>
      _$VideoIdFromJson(json);
  Map<String, dynamic> toJson() => _$VideoIdToJson(this);
}

@JsonSerializable()
class Snippet {
  final String publishedAt;
  final String channelId;
  final String title;
  final String description;
  final Thumbnails thumbnails;
  final String channelTitle;
  final String liveBroadcastContent;
  final String publishTime;

  Snippet({
    required this.publishedAt,
    required this.channelId,
    required this.title,
    required this.description,
    required this.thumbnails,
    required this.channelTitle,
    required this.liveBroadcastContent,
    required this.publishTime,
  });

  factory Snippet.fromJson(Map<String, dynamic> json) =>
      _$SnippetFromJson(json);
  Map<String, dynamic> toJson() => _$SnippetToJson(this);
}

@JsonSerializable()
class YoutubeItem {
  final String kind;
  final String etag;
  final VideoId id;
  final Snippet snippet;

  YoutubeItem({
    required this.kind,
    required this.etag,
    required this.id,
    required this.snippet,
  });

  factory YoutubeItem.fromJson(Map<String, dynamic> json) =>
      _$YoutubeItemFromJson(json);
  Map<String, dynamic> toJson() => _$YoutubeItemToJson(this);
}

@JsonSerializable()
class PageInfo {
  final int totalResults;
  final int resultsPerPage;

  PageInfo({
    required this.totalResults,
    required this.resultsPerPage,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) =>
      _$PageInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PageInfoToJson(this);
}

@JsonSerializable()
class YoutubeSearchResult {
  final String kind;
  final String etag;
  final String nextPageToken;
  final String regionCode;
  final PageInfo pageInfo;
  final List<YoutubeItem> items;

  YoutubeSearchResult({
    required this.kind,
    required this.etag,
    required this.nextPageToken,
    required this.regionCode,
    required this.pageInfo,
    required this.items,
  });

  factory YoutubeSearchResult.fromJson(Map<String, dynamic> json) =>
      _$YoutubeSearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$YoutubeSearchResultToJson(this);
}

@JsonSerializable()
class WakeupApplication {
  final String id;
  @JsonKey(name: 'video_id')
  final String videoId;
  @JsonKey(name: 'video_title')
  final String videoTitle;
  @JsonKey(name: 'video_thumbnail')
  final String videoThumbnail;
  @JsonKey(name: 'video_channel')
  final String videoChannel;
  final String week;
  final String gender;

  WakeupApplication({
    required this.id,
    required this.videoId,
    required this.videoTitle,
    required this.videoThumbnail,
    required this.videoChannel,
    required this.week,
    required this.gender,
  });

  factory WakeupApplication.fromJson(Map<String, dynamic> json) =>
      _$WakeupApplicationFromJson(json);
  Map<String, dynamic> toJson() => _$WakeupApplicationToJson(this);
}

@JsonSerializable()
class WakeupApplicationWithVote extends WakeupApplication {
  final int up;
  final int down;

  WakeupApplicationWithVote({
    required this.up,
    required this.down,
    required super.id,
    required super.videoId,
    required super.videoTitle,
    required super.videoThumbnail,
    required super.videoChannel,
    required super.week,
    required super.gender,
  });

  factory WakeupApplicationWithVote.fromJson(Map<String, dynamic> json) =>
      _$WakeupApplicationWithVoteFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$WakeupApplicationWithVoteToJson(this);
}

@JsonSerializable()
class WakeupApplicationVotes {
  final String id;
  final bool upvote;
  final WakeupApplication wakeupSongApplication;

  WakeupApplicationVotes({
    required this.id,
    required this.upvote,
    required this.wakeupSongApplication,
  });

  factory WakeupApplicationVotes.fromJson(Map<String, dynamic> json) =>
      _$WakeupApplicationVotesFromJson(json);
  Map<String, dynamic> toJson() => _$WakeupApplicationVotesToJson(this);
}

@JsonSerializable()
class WakeupHistory {
  final String id;
  @JsonKey(name: 'video_id')
  final String videoId;
  @JsonKey(name: 'video_title')
  final String videoTitle;
  final String date;
  final String gender;
  final int up;
  final int down;

  WakeupHistory({
    required this.id,
    required this.videoId,
    required this.videoTitle,
    required this.date,
    required this.gender,
    required this.up,
    required this.down,
  });

  factory WakeupHistory.fromJson(Map<String, dynamic> json) =>
      _$WakeupHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$WakeupHistoryToJson(this);
}