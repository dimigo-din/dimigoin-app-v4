// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LostfoundReportCWProxy {
  LostfoundReport id(String id);

  LostfoundReport status(LostfoundStatus status);

  LostfoundReport isConcluded(bool isConcluded);

  LostfoundReport objectName(String objectName);

  LostfoundReport lastSeenPlace(String lastSeenPlace);

  LostfoundReport body(String body);

  LostfoundReport createdAt(String createdAt);

  LostfoundReport img(List<LostfoundImg> img);

  LostfoundReport comment(List<LostfoundComment>? comment);

  LostfoundReport userId(String userId);

  LostfoundReport user(LostfoundUser? user);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `LostfoundReport(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// LostfoundReport(...).copyWith(id: 12, name: "My name")
  /// ```
  LostfoundReport call({
    String id,
    LostfoundStatus status,
    bool isConcluded,
    String objectName,
    String lastSeenPlace,
    String body,
    String createdAt,
    List<LostfoundImg> img,
    List<LostfoundComment>? comment,
    String userId,
    LostfoundUser? user,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfLostfoundReport.copyWith(...)` or call `instanceOfLostfoundReport.copyWith.fieldName(value)` for a single field.
class _$LostfoundReportCWProxyImpl implements _$LostfoundReportCWProxy {
  const _$LostfoundReportCWProxyImpl(this._value);

  final LostfoundReport _value;

  @override
  LostfoundReport id(String id) => call(id: id);

  @override
  LostfoundReport status(LostfoundStatus status) => call(status: status);

  @override
  LostfoundReport isConcluded(bool isConcluded) =>
      call(isConcluded: isConcluded);

  @override
  LostfoundReport objectName(String objectName) => call(objectName: objectName);

  @override
  LostfoundReport lastSeenPlace(String lastSeenPlace) =>
      call(lastSeenPlace: lastSeenPlace);

  @override
  LostfoundReport body(String body) => call(body: body);

  @override
  LostfoundReport createdAt(String createdAt) => call(createdAt: createdAt);

  @override
  LostfoundReport img(List<LostfoundImg> img) => call(img: img);

  @override
  LostfoundReport comment(List<LostfoundComment>? comment) =>
      call(comment: comment);

  @override
  LostfoundReport userId(String userId) => call(userId: userId);

  @override
  LostfoundReport user(LostfoundUser? user) => call(user: user);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `LostfoundReport(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// LostfoundReport(...).copyWith(id: 12, name: "My name")
  /// ```
  LostfoundReport call({
    Object? id = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? isConcluded = const $CopyWithPlaceholder(),
    Object? objectName = const $CopyWithPlaceholder(),
    Object? lastSeenPlace = const $CopyWithPlaceholder(),
    Object? body = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? img = const $CopyWithPlaceholder(),
    Object? comment = const $CopyWithPlaceholder(),
    Object? userId = const $CopyWithPlaceholder(),
    Object? user = const $CopyWithPlaceholder(),
  }) {
    return LostfoundReport(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as LostfoundStatus,
      isConcluded:
          isConcluded == const $CopyWithPlaceholder() || isConcluded == null
          ? _value.isConcluded
          // ignore: cast_nullable_to_non_nullable
          : isConcluded as bool,
      objectName:
          objectName == const $CopyWithPlaceholder() || objectName == null
          ? _value.objectName
          // ignore: cast_nullable_to_non_nullable
          : objectName as String,
      lastSeenPlace:
          lastSeenPlace == const $CopyWithPlaceholder() || lastSeenPlace == null
          ? _value.lastSeenPlace
          // ignore: cast_nullable_to_non_nullable
          : lastSeenPlace as String,
      body: body == const $CopyWithPlaceholder() || body == null
          ? _value.body
          // ignore: cast_nullable_to_non_nullable
          : body as String,
      createdAt: createdAt == const $CopyWithPlaceholder() || createdAt == null
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as String,
      img: img == const $CopyWithPlaceholder() || img == null
          ? _value.img
          // ignore: cast_nullable_to_non_nullable
          : img as List<LostfoundImg>,
      comment: comment == const $CopyWithPlaceholder()
          ? _value.comment
          // ignore: cast_nullable_to_non_nullable
          : comment as List<LostfoundComment>?,
      userId: userId == const $CopyWithPlaceholder() || userId == null
          ? _value.userId
          // ignore: cast_nullable_to_non_nullable
          : userId as String,
      user: user == const $CopyWithPlaceholder()
          ? _value.user
          // ignore: cast_nullable_to_non_nullable
          : user as LostfoundUser?,
    );
  }
}

extension $LostfoundReportCopyWith on LostfoundReport {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfLostfoundReport.copyWith(...)` or `instanceOfLostfoundReport.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LostfoundReportCWProxy get copyWith => _$LostfoundReportCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LostfoundUser _$LostfoundUserFromJson(Map<String, dynamic> json) =>
    LostfoundUser(id: json['id'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$LostfoundUserToJson(LostfoundUser instance) =>
    <String, dynamic>{'id': ?instance.id, 'name': ?instance.name};

LostfoundImg _$LostfoundImgFromJson(Map<String, dynamic> json) => LostfoundImg(
  id: json['id'] as String,
  name: json['name'] as String,
  url: json['url'] as String,
);

Map<String, dynamic> _$LostfoundImgToJson(LostfoundImg instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
    };

LostfoundComment _$LostfoundCommentFromJson(Map<String, dynamic> json) =>
    LostfoundComment(
      id: json['id'] as String,
      parentId: json['parent_id'] as String,
      text: json['text'] as String,
      createdAt: json['created_at'] as String,
      userId: json['user_id'] as String,
      user: json['user'] == null
          ? null
          : LostfoundUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LostfoundCommentToJson(LostfoundComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parentId,
      'text': instance.text,
      'created_at': instance.createdAt,
      'user_id': instance.userId,
      'user': instance.user,
    };

LostfoundReport _$LostfoundReportFromJson(Map<String, dynamic> json) =>
    LostfoundReport(
      id: json['id'] as String,
      status: $enumDecode(_$LostfoundStatusEnumMap, json['status']),
      isConcluded: json['is_concluded'] as bool? ?? false,
      objectName: json['object_name'] as String,
      lastSeenPlace: json['last_seen_place'] as String,
      body: json['body'] as String,
      createdAt: json['created_at'] as String,
      img:
          (json['img'] as List<dynamic>?)
              ?.map((e) => LostfoundImg.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      comment:
          (json['comment'] as List<dynamic>?)
              ?.map((e) => LostfoundComment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      userId: json['user_id'] as String,
      user: json['user'] == null
          ? null
          : LostfoundUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LostfoundReportToJson(LostfoundReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$LostfoundStatusEnumMap[instance.status]!,
      'is_concluded': instance.isConcluded,
      'object_name': instance.objectName,
      'last_seen_place': instance.lastSeenPlace,
      'body': instance.body,
      'created_at': instance.createdAt,
      'img': instance.img,
      'comment': instance.comment,
      'user_id': instance.userId,
      'user': instance.user,
    };

const _$LostfoundStatusEnumMap = {
  LostfoundStatus.lost: 'lost',
  LostfoundStatus.pickup: 'pickup',
};
