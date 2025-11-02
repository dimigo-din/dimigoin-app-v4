// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// UserApply _$UserApplyFromJson(Map<String, dynamic> json) => UserApply(
//   stayApply: json['stayApply'] == null
//       ? null
//       : StayApply.fromJson(json['stayApply'] as Map<String, dynamic>),
//   laundryApply: json['laundryApply'] == null
//       ? null
//       : LaundryApply.fromJson(json['laundryApply'] as Map<String, dynamic>),
// );

Map<String, dynamic> _$UserApplyToJson(UserApply instance) => <String, dynamic>{
  'stayApply': instance.stayApply,
  'laundryApply': instance.laundryApply,
};

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  email: json['email'] as String?,
  name: json['name'] as String?,
  permission: json['permission'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
  'permission': instance.permission,
};
