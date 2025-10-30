import '../stay/model.dart';
import '../laundry/model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

// g.dart 파일 생성 : dart run build_runner build

// @JsonSerializable()

class Timetable {
  final List<List<TimetableItem>> schedule;

    Timetable({required this.schedule});

    factory Timetable.fromJson(List<dynamic> json) {
      return Timetable(
        schedule: (json)
            .map((week) => (week as List)
                .map((item) => TimetableItem.fromJson(item))
                .toList())
            .toList(),
      );
    }

    List<dynamic> toJson() {
      return schedule
          .map((week) => week.map((item) => item.toJson()).toList())
          .toList();
    }
  }

class TimetableItem {
  final String content;
  final bool temp;

  TimetableItem({required this.content, required this.temp});

  factory TimetableItem.fromJson(Map<String, dynamic> json) {
    return TimetableItem(
      content: json['content'] as String,
      temp: json['temp'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'temp': temp,
    };
  }
}

@JsonSerializable()
class UserApply {
  final StayApply? stayApply;
  final LaundryApply? laundryApply;

  UserApply({
    this.stayApply,
    this.laundryApply,
  });

  factory UserApply.fromJson(Map<String, dynamic> json) {
    return UserApply(
      stayApply: json['stayApply'] == null
          ? null
          : StayApply.fromJson(json['stayApply'] as Map<String, dynamic>),
      laundryApply: json['laundryApply'] == null
          ? null
          : LaundryApply.fromJson(json['laundryApply'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => _$UserApplyToJson(this);
}

@JsonSerializable()
class User {
  final String id;
  final String? email;
  final String? name;
  final String? permission;

  User({
    required this.id,
    this.email,
    this.name,
    this.permission,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}