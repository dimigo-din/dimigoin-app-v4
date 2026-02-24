import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

enum FrigoTiming {
  @JsonValue('afterschool')
  afterschool,
  @JsonValue('dinner')
  dinner,
  @JsonValue('after_1st_study')
  afterFirstStudy,
  @JsonValue('after_2nd_study')
  afterSecondStudy,
}

@JsonSerializable(fieldRename: FieldRename.snake)
class FrigoUser {
  final String id;
  final String email;
  final String name;

  FrigoUser({
    required this.id,
    required this.email,
    required this.name,
  });

  factory FrigoUser.fromJson(Map<String, dynamic> json) =>
      _$FrigoUserFromJson(json);

  Map<String, dynamic> toJson() => _$FrigoUserToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Frigo {
  final String id;
  final String week;
  final FrigoTiming timing;
  final String reason;
  final String? auditReason;
  final bool? approved;
  final String userId;

  Frigo({
    required this.id,
    required this.week,
    required this.timing,
    required this.reason,
    this.auditReason,
    this.approved,
    required this.userId,
  });

  factory Frigo.fromJson(Map<String, dynamic> json) => _$FrigoFromJson(json);

  Map<String, dynamic> toJson() => _$FrigoToJson(this);
}