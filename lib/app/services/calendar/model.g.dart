// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarEvent _$CalendarEventFromJson(Map<String, dynamic> json) =>
    CalendarEvent(
      title: json['title'] as String,
      type: $enumDecode(_$CalendarEventTypeEnumMap, json['type']),
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CalendarEventToJson(CalendarEvent instance) =>
    <String, dynamic>{
      'title': instance.title,
      'type': _$CalendarEventTypeEnumMap[instance.type]!,
      'date': instance.date.toIso8601String(),
      'description': instance.description,
    };

const _$CalendarEventTypeEnumMap = {
  CalendarEventType.exam: 'exam',
  CalendarEventType.home: 'home',
  CalendarEventType.vacation: 'vacation',
  CalendarEventType.event: 'event',
  CalendarEventType.stay: 'stay',
};
