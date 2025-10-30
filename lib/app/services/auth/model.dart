import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

// g.dart 파일 생성 : dart run build_runner build

@JsonSerializable()
class Pong {
  String message;

  Pong({
    required this.message,
  });

  factory Pong.fromJson(Map<String, dynamic> json) =>
      _$PongFromJson(json);

  Map<String, dynamic> toJson() => _$PongToJson(this);
}

@JsonSerializable()
class LoginToken {
  String? accessToken;
  String? refreshToken;

  LoginToken({
    this.accessToken,
    this.refreshToken,
  });

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
  String number;
  int userGrade;
  int userClass;
  int userNumber;
  String gender;
  String? profileUrl;

  PersonalInformation({
    required this.id,
    required this.name,
    required this.number,
    required this.userGrade,
    required this.userClass,
    required this.userNumber,
    required this.gender,
    this.profileUrl,
  });

  factory PersonalInformation.fromJson(Map<String, dynamic> json) {
    final number = json['number']?.toString() ?? '';

    int userGrade = 0;
    int userClass = 0;
    int userNumber = 0;
    if (number.length >= 4) {
      userGrade = int.tryParse(number[0]) ?? 0;
      userClass = int.tryParse(number[1]) ?? 0;
      userNumber = int.tryParse(number.substring(2, 4)) ?? 0;
    }

    return PersonalInformation(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      number: number,
      userGrade: userGrade,
      userClass: userClass,
      userNumber: userNumber,
      gender: json['gender']?.toString() ?? '',
      profileUrl: '',
    );
  }

  Map<String, dynamic> toJson() => _$PersonalInformationToJson(this);
}