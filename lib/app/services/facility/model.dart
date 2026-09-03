import 'dart:typed_data';

import 'package:dimigoin_app_v4/app/services/user/model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

enum FacilityReportType {
  @JsonValue('suggest')
  suggest,
  @JsonValue('broken')
  broken,
  @JsonValue('danger')
  danger,
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ReportFacility {
  final String? id;
  final String? status;
  final FacilityReportType reportType;
  final String subject;
  final String body;
  final List<File>? file;

  final DateTime? createdAt;
  final User? user;

  ReportFacility({
    required this.reportType,
    required this.subject,
    required this.body,
    this.file,
    this.createdAt,
    this.user,
    this.id,
    this.status,
  });

  factory ReportFacility.fromJson(Map<String, dynamic> json) =>
      _$ReportFacilityFromJson(json);

  Map<String, dynamic> toJson() => _$ReportFacilityToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PostComment {
  final String post;
  final String? parentComment;
  final String text;

  PostComment({required this.post, this.parentComment, required this.text});

  factory PostComment.fromJson(Map<String, dynamic> json) =>
      _$PostCommentFromJson(json);

  Map<String, dynamic> toJson() => _$PostCommentToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class File {
  final String fieldname;
  final String originalname;
  final String encoding;
  final String mimetype;

  @JsonKey(fromJson: _bufferFromJson, toJson: _bufferToJson)
  final Uint8List? buffer;

  final int size;
  final String? filename;

  File({
    required this.fieldname,
    required this.originalname,
    required this.encoding,
    required this.mimetype,
    this.buffer,
    required this.size,
    this.filename,
  });

  factory File.fromJson(Map<String, dynamic> json) => _$FileFromJson(json);

  Map<String, dynamic> toJson() => _$FileToJson(this);
}

Uint8List? _bufferFromJson(dynamic json) {
  if (json == null) return null;

  if (json is List) {
    return Uint8List.fromList(json.map((e) => (e as num).toInt()).toList());
  }

  if (json is Map && json['data'] is List) {
    return Uint8List.fromList(
      (json['data'] as List).map((e) => (e as num).toInt()).toList(),
    );
  }

  return null;
}

dynamic _bufferToJson(Uint8List? buffer) {
  return buffer?.toList();
}
