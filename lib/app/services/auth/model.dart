import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

// g.dart 파일 생성 : dart run build_runner build

@JsonSerializable()
class Pong {
  String message;

  Pong({required this.message});

  factory Pong.fromJson(Map<String, dynamic> json) => _$PongFromJson(json);

  Map<String, dynamic> toJson() => _$PongToJson(this);
}

@JsonSerializable()
class LoginToken {
  String? accessToken;
  String? refreshToken;

  LoginToken({this.accessToken, this.refreshToken});

  factory LoginToken.fromJson(Map<String, dynamic> json) {
    return _$LoginTokenFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$LoginTokenToJson(this);
  }
}

@JsonSerializable()
class PersonalInformation {
  String id;
  String name;
  int? userGrade;
  int? userClass;
  String? gender;
  String? profileUrl;

  PersonalInformation({
    required this.id,
    required this.name,
    this.userGrade,
    this.userClass,
    this.gender,
    this.profileUrl,
  });

  factory PersonalInformation.fromJson(Map<String, dynamic> json) =>
      _$PersonalInformationFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalInformationToJson(this);
}
