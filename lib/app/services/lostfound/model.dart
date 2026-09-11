import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

enum LostfoundStatus { lost, pickup }

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class LostfoundUser {
  final String? id;
  final String? name;

  LostfoundUser({this.id, this.name});

  factory LostfoundUser.fromJson(Map<String, dynamic> json) =>
      _$LostfoundUserFromJson(json);
  Map<String, dynamic> toJson() => _$LostfoundUserToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LostfoundImg {
  final String id;
  final String name;
  final String url;

  LostfoundImg({required this.id, required this.name, required this.url});

  factory LostfoundImg.fromJson(Map<String, dynamic> json) =>
      _$LostfoundImgFromJson(json);
  Map<String, dynamic> toJson() => _$LostfoundImgToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LostfoundComment {
  final String id;
  final String parentId;
  final String text;
  final String createdAt;
  final String userId;
  final LostfoundUser? user;

  LostfoundComment({
    required this.id,
    required this.parentId,
    required this.text,
    required this.createdAt,
    required this.userId,
    this.user,
  });

  factory LostfoundComment.fromJson(Map<String, dynamic> json) =>
      _$LostfoundCommentFromJson(json);
  Map<String, dynamic> toJson() => _$LostfoundCommentToJson(this);
}

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class LostfoundReport {
  final String id;
  final LostfoundStatus status;
  @JsonKey(defaultValue: false)
  final bool isConcluded;
  final String objectName;
  final String lastSeenPlace;
  final String body;
  final String createdAt;
  final List<LostfoundImg> img;
  final List<LostfoundComment>? comment;
  final String userId;
  final LostfoundUser? user;

  LostfoundReport({
    required this.id,
    required this.status,
    required this.isConcluded,
    required this.objectName,
    required this.lastSeenPlace,
    required this.body,
    required this.createdAt,
    this.img = const [],
    this.comment = const [],
    required this.userId,
    this.user,
  });

  factory LostfoundReport.fromJson(Map<String, dynamic> json) =>
      _$LostfoundReportFromJson(json);
  Map<String, dynamic> toJson() => _$LostfoundReportToJson(this);
}
