// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationSubject _$NotificationSubjectFromJson(Map<String, dynamic> json) =>
    NotificationSubject(
      id: json['id'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$NotificationSubjectToJson(
  NotificationSubject instance,
) => <String, dynamic>{'id': instance.id, 'description': instance.description};

SubscribedNotificationSubject _$SubscribedNotificationSubjectFromJson(
  Map<String, dynamic> json,
) => SubscribedNotificationSubject(
  id: json['id'] as String,
  name: json['name'] as String,
  identifier: json['identifier'] as String,
);

Map<String, dynamic> _$SubscribedNotificationSubjectToJson(
  SubscribedNotificationSubject instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'identifier': instance.identifier,
};
