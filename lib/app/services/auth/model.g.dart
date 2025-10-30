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

Map<String, dynamic> _$PersonalInformationToJson(
  PersonalInformation instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'number': instance.number,
  'userGrade': instance.userGrade,
  'userClass': instance.userClass,
  'userNumber': instance.userNumber,
  'gender': instance.gender,
  'profileUrl': instance.profileUrl,
};
