import 'package:dimigoin_app_v4/app/services/user/model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class StayApplyPeriod {
  final String id;
  final int grade;
  final String applyStart;
  final String applyEnd;

  StayApplyPeriod({
    required this.id,
    required this.grade,
    required this.applyStart,
    required this.applyEnd,
  });

  factory StayApplyPeriod.fromJson(Map<String, dynamic> json) =>
      _$StayApplyPeriodFromJson(json);
  Map<String, dynamic> toJson() => _$StayApplyPeriodToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class StaySeat {
  final String id;
  final String target;
  final String range;

  StaySeat({
    required this.id,
    required this.target,
    required this.range,
  });

  factory StaySeat.fromJson(Map<String, dynamic> json) =>
      _$StaySeatFromJson(json);
  Map<String, dynamic> toJson() => _$StaySeatToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class StaySeatPreset {
  final String id;
  final String name;
  final bool onlyReadingRoom;
  final List<StaySeat>? staySeat;

  StaySeatPreset({
    required this.id,
    required this.name,
    required this.onlyReadingRoom,
    this.staySeat,
  });

  factory StaySeatPreset.fromJson(Map<String, dynamic> json) =>
      _$StaySeatPresetFromJson(json);
  Map<String, dynamic> toJson() => _$StaySeatPresetToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class StayApplyUser {
  final String id;
  final String name;

  StayApplyUser({
    required this.id,
    required this.name,
  });

  factory StayApplyUser.fromJson(Map<String, dynamic> json) =>
      _$StayApplyUserFromJson(json);
  Map<String, dynamic> toJson() => _$StayApplyUserToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class StayApplyItem {
  final String? id;
  final String staySeat;
  final StayApplyUser user;

  StayApplyItem({
    this.id,
    required this.staySeat,
    required this.user,
  });

  factory StayApplyItem.fromJson(Map<String, dynamic> json) =>
      _$StayApplyItemFromJson(json);
  Map<String, dynamic> toJson() => _$StayApplyItemToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Stay {
  final String id;
  final String name;
  final String stayFrom;
  final String stayTo;
  final List<String>? outingDay;
  final List<StayApplyPeriod>? stayApplyPeriod;
  final StaySeatPreset? staySeatPreset;
  final List<StayApplyItem>? stayApply;

  Stay({
    required this.id,
    required this.name,
    required this.stayFrom,
    required this.stayTo,
    this.outingDay,
    this.stayApplyPeriod,
    this.staySeatPreset,
    this.stayApply,
  });

  factory Stay.fromJson(Map<String, dynamic> json) => _$StayFromJson(json);
  Map<String, dynamic> toJson() => _$StayToJson(this);
}

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class Outing {
  final String? id;
  final String? reason;
  final bool? breakfastCancel;
  final bool? lunchCancel;
  final bool? dinnerCancel;
  final String? from;
  final String? to;
  final bool? approved;
  final String? auditReason;

  Outing({
    this.id,
    this.reason,
    this.breakfastCancel,
    this.lunchCancel,
    this.dinnerCancel,
    this.from,
    this.to,
    this.approved,
    this.auditReason,
  });

  factory Outing.fromJson(Map<String, dynamic> json) =>
      _$OutingFromJson(json);
  Map<String, dynamic> toJson() => _$OutingToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class StayApply {
  final String id;
  final String staySeat;
  final Stay? stay;
  final List<Outing> outing;
  final User? user;

  StayApply({
    required this.id,
    required this.staySeat,
    this.stay,
    required this.outing,
    this.user,
  });

  factory StayApply.fromJson(Map<String, dynamic> json) =>
      _$StayApplyFromJson(json);
  Map<String, dynamic> toJson() => _$StayApplyToJson(this);
}