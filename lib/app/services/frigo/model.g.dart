// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrigoUser _$FrigoUserFromJson(Map<String, dynamic> json) => FrigoUser(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$FrigoUserToJson(FrigoUser instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
};

Frigo _$FrigoFromJson(Map<String, dynamic> json) => Frigo(
  id: json['id'] as String,
  week: json['week'] as String,
  timing: $enumDecode(_$FrigoTimingEnumMap, json['timing']),
  reason: json['reason'] as String,
  auditReason: json['audit_reason'] as String,
  approved: json['approved'] as bool,
  user: FrigoUser.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FrigoToJson(Frigo instance) => <String, dynamic>{
  'id': instance.id,
  'week': instance.week,
  'timing': _$FrigoTimingEnumMap[instance.timing]!,
  'reason': instance.reason,
  'audit_reason': instance.auditReason,
  'approved': instance.approved,
  'user': instance.user,
};

const _$FrigoTimingEnumMap = {
  FrigoTiming.afterschool: 'afterschool',
  FrigoTiming.dinner: 'dinner',
  FrigoTiming.afterFirstStudy: 'after_1st_study',
  FrigoTiming.afterSecondStudy: 'after_2nd_study',
};
