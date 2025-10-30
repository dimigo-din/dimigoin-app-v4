// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Thumbnail _$ThumbnailFromJson(Map<String, dynamic> json) => Thumbnail(
  url: json['url'] as String,
  width: (json['width'] as num?)?.toInt(),
  height: (json['height'] as num?)?.toInt(),
);

Map<String, dynamic> _$ThumbnailToJson(Thumbnail instance) => <String, dynamic>{
  'url': instance.url,
  'width': instance.width,
  'height': instance.height,
};

Thumbnails _$ThumbnailsFromJson(Map<String, dynamic> json) => Thumbnails(
  defaultThumbnail: Thumbnail.fromJson(json['default'] as Map<String, dynamic>),
  medium: Thumbnail.fromJson(json['medium'] as Map<String, dynamic>),
  high: Thumbnail.fromJson(json['high'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ThumbnailsToJson(Thumbnails instance) =>
    <String, dynamic>{
      'default': instance.defaultThumbnail,
      'medium': instance.medium,
      'high': instance.high,
    };

VideoId _$VideoIdFromJson(Map<String, dynamic> json) =>
    VideoId(kind: json['kind'] as String, videoId: json['videoId'] as String?);

Map<String, dynamic> _$VideoIdToJson(VideoId instance) => <String, dynamic>{
  'kind': instance.kind,
  'videoId': instance.videoId,
};

Snippet _$SnippetFromJson(Map<String, dynamic> json) => Snippet(
  publishedAt: json['publishedAt'] as String,
  channelId: json['channelId'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  thumbnails: Thumbnails.fromJson(json['thumbnails'] as Map<String, dynamic>),
  channelTitle: json['channelTitle'] as String,
  liveBroadcastContent: json['liveBroadcastContent'] as String,
  publishTime: json['publishTime'] as String,
);

Map<String, dynamic> _$SnippetToJson(Snippet instance) => <String, dynamic>{
  'publishedAt': instance.publishedAt,
  'channelId': instance.channelId,
  'title': instance.title,
  'description': instance.description,
  'thumbnails': instance.thumbnails,
  'channelTitle': instance.channelTitle,
  'liveBroadcastContent': instance.liveBroadcastContent,
  'publishTime': instance.publishTime,
};

YoutubeItem _$YoutubeItemFromJson(Map<String, dynamic> json) => YoutubeItem(
  kind: json['kind'] as String,
  etag: json['etag'] as String,
  id: VideoId.fromJson(json['id'] as Map<String, dynamic>),
  snippet: Snippet.fromJson(json['snippet'] as Map<String, dynamic>),
);

Map<String, dynamic> _$YoutubeItemToJson(YoutubeItem instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'etag': instance.etag,
      'id': instance.id,
      'snippet': instance.snippet,
    };

PageInfo _$PageInfoFromJson(Map<String, dynamic> json) => PageInfo(
  totalResults: (json['totalResults'] as num).toInt(),
  resultsPerPage: (json['resultsPerPage'] as num).toInt(),
);

Map<String, dynamic> _$PageInfoToJson(PageInfo instance) => <String, dynamic>{
  'totalResults': instance.totalResults,
  'resultsPerPage': instance.resultsPerPage,
};

YoutubeSearchResult _$YoutubeSearchResultFromJson(Map<String, dynamic> json) =>
    YoutubeSearchResult(
      kind: json['kind'] as String,
      etag: json['etag'] as String,
      nextPageToken: json['nextPageToken'] as String,
      regionCode: json['regionCode'] as String,
      pageInfo: PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>)
          .map((e) => YoutubeItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$YoutubeSearchResultToJson(
  YoutubeSearchResult instance,
) => <String, dynamic>{
  'kind': instance.kind,
  'etag': instance.etag,
  'nextPageToken': instance.nextPageToken,
  'regionCode': instance.regionCode,
  'pageInfo': instance.pageInfo,
  'items': instance.items,
};

WakeupApplication _$WakeupApplicationFromJson(Map<String, dynamic> json) =>
    WakeupApplication(
      id: json['id'] as String,
      videoId: json['video_id'] as String,
      videoTitle: json['video_title'] as String,
      videoThumbnail: json['video_thumbnail'] as String,
      videoChannel: json['video_channel'] as String,
      week: json['week'] as String,
      gender: json['gender'] as String,
    );

Map<String, dynamic> _$WakeupApplicationToJson(WakeupApplication instance) =>
    <String, dynamic>{
      'id': instance.id,
      'video_id': instance.videoId,
      'video_title': instance.videoTitle,
      'video_thumbnail': instance.videoThumbnail,
      'video_channel': instance.videoChannel,
      'week': instance.week,
      'gender': instance.gender,
    };

WakeupApplicationWithVote _$WakeupApplicationWithVoteFromJson(
  Map<String, dynamic> json,
) => WakeupApplicationWithVote(
  up: (json['up'] as num).toInt(),
  down: (json['down'] as num).toInt(),
  id: json['id'] as String,
  videoId: json['video_id'] as String,
  videoTitle: json['video_title'] as String,
  videoThumbnail: json['video_thumbnail'] as String,
  videoChannel: json['video_channel'] as String,
  week: json['week'] as String,
  gender: json['gender'] as String,
);

Map<String, dynamic> _$WakeupApplicationWithVoteToJson(
  WakeupApplicationWithVote instance,
) => <String, dynamic>{
  'id': instance.id,
  'video_id': instance.videoId,
  'video_title': instance.videoTitle,
  'video_thumbnail': instance.videoThumbnail,
  'video_channel': instance.videoChannel,
  'week': instance.week,
  'gender': instance.gender,
  'up': instance.up,
  'down': instance.down,
};

WakeupApplicationVotes _$WakeupApplicationVotesFromJson(
  Map<String, dynamic> json,
) => WakeupApplicationVotes(
  id: json['id'] as String,
  upvote: json['upvote'] as bool,
  wakeupSongApplication: WakeupApplication.fromJson(
    json['wakeupSongApplication'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$WakeupApplicationVotesToJson(
  WakeupApplicationVotes instance,
) => <String, dynamic>{
  'id': instance.id,
  'upvote': instance.upvote,
  'wakeupSongApplication': instance.wakeupSongApplication,
};

WakeupHistory _$WakeupHistoryFromJson(Map<String, dynamic> json) =>
    WakeupHistory(
      id: json['id'] as String,
      videoId: json['video_id'] as String,
      videoTitle: json['video_title'] as String,
      date: json['date'] as String,
      gender: json['gender'] as String,
      up: (json['up'] as num).toInt(),
      down: (json['down'] as num).toInt(),
    );

Map<String, dynamic> _$WakeupHistoryToJson(WakeupHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'video_id': instance.videoId,
      'video_title': instance.videoTitle,
      'date': instance.date,
      'gender': instance.gender,
      'up': instance.up,
      'down': instance.down,
    };
