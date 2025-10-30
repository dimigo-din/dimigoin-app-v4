// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
