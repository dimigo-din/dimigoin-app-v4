// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pong _$PongFromJson(Map<String, dynamic> json) =>
    Pong(message: json['message'] as String);

Map<String, dynamic> _$PongToJson(Pong instance) => <String, dynamic>{
  'message': instance.message,
};

LoginToken _$LoginTokenFromJson(Map<String, dynamic> json) => LoginToken(
  accessToken: json['accessToken'] as String?,
  refreshToken: json['refreshToken'] as String?,
);

Map<String, dynamic> _$LoginTokenToJson(LoginToken instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };

PersonalInformation _$PersonalInformationFromJson(Map<String, dynamic> json) =>
    PersonalInformation(
      id: json['id'] as String,
      name: json['name'] as String,
      userGrade: (json['userGrade'] as num?)?.toInt(),
      userClass: (json['userClass'] as num?)?.toInt(),
      gender: json['gender'] as String?,
      profileUrl: json['profileUrl'] as String?,
    );

Map<String, dynamic> _$PersonalInformationToJson(
  PersonalInformation instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'userGrade': instance.userGrade,
  'userClass': instance.userClass,
  'gender': instance.gender,
  'profileUrl': instance.profileUrl,
};
