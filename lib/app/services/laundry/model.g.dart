// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LaundryMachine _$LaundryMachineFromJson(Map<String, dynamic> json) =>
    LaundryMachine(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$LaundryMachineTypeEnumMap, json['type']),
      gender: json['gender'] as String,
      enabled: json['enabled'] as bool,
    );

Map<String, dynamic> _$LaundryMachineToJson(LaundryMachine instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$LaundryMachineTypeEnumMap[instance.type]!,
      'gender': instance.gender,
      'enabled': instance.enabled,
    };

const _$LaundryMachineTypeEnumMap = {
  LaundryMachineType.washer: 'washer',
  LaundryMachineType.dryer: 'dryer',
};

LaundryTime _$LaundryTimeFromJson(Map<String, dynamic> json) => LaundryTime(
  id: json['id'] as String,
  time: json['time'] as String,
  grade: (json['grade'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  assigns: (json['assigns'] as List<dynamic>)
      .map((e) => LaundryMachine.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LaundryTimeToJson(LaundryTime instance) =>
    <String, dynamic>{
      'id': instance.id,
      'time': instance.time,
      'grade': instance.grade,
      'assigns': instance.assigns,
    };

LaundryTimeline _$LaundryTimelineFromJson(Map<String, dynamic> json) =>
    LaundryTimeline(
      id: json['id'] as String,
      name: json['name'] as String,
      triggeredOn: $enumDecode(
        _$LaundryTimelineTriggerEnumMap,
        json['triggeredOn'],
      ),
      enabled: json['enabled'] as bool,
      times: (json['times'] as List<dynamic>)
          .map((e) => LaundryTime.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LaundryTimelineToJson(LaundryTimeline instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'triggeredOn': _$LaundryTimelineTriggerEnumMap[instance.triggeredOn]!,
      'enabled': instance.enabled,
      'times': instance.times,
    };

const _$LaundryTimelineTriggerEnumMap = {
  LaundryTimelineTrigger.primary: 'primary',
  LaundryTimelineTrigger.stay: 'stay',
};

LaundryApply _$LaundryApplyFromJson(Map<String, dynamic> json) => LaundryApply(
  id: json['id'] as String,
  date: json['date'] as String,
  created_at: json['created_at'] as String,
  laundryTime: LaundryTime.fromJson(
    json['laundryTime'] as Map<String, dynamic>,
  ),
  laundryMachine: LaundryMachine.fromJson(
    json['laundryMachine'] as Map<String, dynamic>,
  ),
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LaundryApplyToJson(LaundryApply instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'created_at': instance.created_at,
      'laundryTime': instance.laundryTime,
      'laundryMachine': instance.laundryMachine,
      'user': instance.user,
    };
