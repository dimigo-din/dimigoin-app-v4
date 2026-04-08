import 'package:json_annotation/json_annotation.dart';
import '../user/model.dart';

part 'model.g.dart';

enum LaundryMachineType { washer, dryer }

enum LaundryTimelineTrigger { primary, stay, etc }

@JsonSerializable(fieldRename: FieldRename.snake)
class LaundryMachine {
  final String id;
  final String name;
  final LaundryMachineType type;
  final String gender;
  final bool enabled;

  LaundryMachine({
    required this.id,
    required this.name,
    required this.type,
    required this.gender,
    required this.enabled,
  });

  factory LaundryMachine.fromJson(Map<String, dynamic> json) =>
      _$LaundryMachineFromJson(json);

  Map<String, dynamic> toJson() => _$LaundryMachineToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LaundryTime {
  final String id;
  final String time;
  final List<int> grade;
  @JsonKey(defaultValue: <LaundryMachine>[])
  final List<LaundryMachine> assigns;

  LaundryTime({
    required this.id,
    required this.time,
    required this.grade,
    this.assigns = const [],
  });

  factory LaundryTime.fromJson(Map<String, dynamic> json) =>
      _$LaundryTimeFromJson(json);

  Map<String, dynamic> toJson() => _$LaundryTimeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LaundryTimeline {
  final String id;
  final String name;
  @JsonKey(name: 'scheduler', unknownEnumValue: LaundryTimelineTrigger.etc)
  final LaundryTimelineTrigger triggeredOn;
  final bool enabled;
  final List<LaundryTime> times;

  LaundryTimeline({
    required this.id,
    required this.name,
    required this.triggeredOn,
    required this.enabled,
    required this.times,
  });

  factory LaundryTimeline.fromJson(Map<String, dynamic> json) =>
      _$LaundryTimelineFromJson(json);

  Map<String, dynamic> toJson() => _$LaundryTimelineToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LaundryApply {
  final String id;
  final String date;
  final String createdAt;
  final LaundryTime laundryTime;
  final LaundryMachine laundryMachine;
  final User? user;

  LaundryApply({
    required this.id,
    required this.date,
    required this.createdAt,
    required this.laundryTime,
    required this.laundryMachine,
    this.user,
  });

  factory LaundryApply.fromJson(Map<String, dynamic> json) =>
      _$LaundryApplyFromJson(json);

  Map<String, dynamic> toJson() => _$LaundryApplyToJson(this);
}
