// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportFacility _$ReportFacilityFromJson(Map<String, dynamic> json) =>
    ReportFacility(
      reportType: $enumDecode(_$FacilityReportTypeEnumMap, json['report_type']),
      subject: json['subject'] as String,
      body: json['body'] as String,
      file: (json['file'] as List<dynamic>?)
          ?.map((e) => File.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      id: json['id'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$ReportFacilityToJson(ReportFacility instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'report_type': _$FacilityReportTypeEnumMap[instance.reportType]!,
      'subject': instance.subject,
      'body': instance.body,
      'file': instance.file,
      'created_at': instance.createdAt?.toIso8601String(),
      'user': instance.user,
    };

const _$FacilityReportTypeEnumMap = {
  FacilityReportType.suggest: 'suggest',
  FacilityReportType.broken: 'broken',
  FacilityReportType.danger: 'danger',
};

PostComment _$PostCommentFromJson(Map<String, dynamic> json) => PostComment(
  post: json['post'] as String,
  parentComment: json['parent_comment'] as String?,
  text: json['text'] as String,
);

Map<String, dynamic> _$PostCommentToJson(PostComment instance) =>
    <String, dynamic>{
      'post': instance.post,
      'parent_comment': instance.parentComment,
      'text': instance.text,
    };

File _$FileFromJson(Map<String, dynamic> json) => File(
  fieldname: json['fieldname'] as String,
  originalname: json['originalname'] as String,
  encoding: json['encoding'] as String,
  mimetype: json['mimetype'] as String,
  buffer: _bufferFromJson(json['buffer']),
  size: (json['size'] as num).toInt(),
  filename: json['filename'] as String?,
);

Map<String, dynamic> _$FileToJson(File instance) => <String, dynamic>{
  'fieldname': instance.fieldname,
  'originalname': instance.originalname,
  'encoding': instance.encoding,
  'mimetype': instance.mimetype,
  'buffer': _bufferToJson(instance.buffer),
  'size': instance.size,
  'filename': instance.filename,
};
