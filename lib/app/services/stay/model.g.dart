// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OutingCWProxy {
  Outing id(String? id);

  Outing reason(String? reason);

  Outing breakfastCancel(bool? breakfastCancel);

  Outing lunchCancel(bool? lunchCancel);

  Outing dinnerCancel(bool? dinnerCancel);

  Outing from(String? from);

  Outing to(String? to);

  Outing approved(bool? approved);

  Outing auditReason(String? auditReason);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Outing(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Outing(...).copyWith(id: 12, name: "My name")
  /// ```
  Outing call({
    String? id,
    String? reason,
    bool? breakfastCancel,
    bool? lunchCancel,
    bool? dinnerCancel,
    String? from,
    String? to,
    bool? approved,
    String? auditReason,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfOuting.copyWith(...)` or call `instanceOfOuting.copyWith.fieldName(value)` for a single field.
class _$OutingCWProxyImpl implements _$OutingCWProxy {
  const _$OutingCWProxyImpl(this._value);

  final Outing _value;

  @override
  Outing id(String? id) => call(id: id);

  @override
  Outing reason(String? reason) => call(reason: reason);

  @override
  Outing breakfastCancel(bool? breakfastCancel) =>
      call(breakfastCancel: breakfastCancel);

  @override
  Outing lunchCancel(bool? lunchCancel) => call(lunchCancel: lunchCancel);

  @override
  Outing dinnerCancel(bool? dinnerCancel) => call(dinnerCancel: dinnerCancel);

  @override
  Outing from(String? from) => call(from: from);

  @override
  Outing to(String? to) => call(to: to);

  @override
  Outing approved(bool? approved) => call(approved: approved);

  @override
  Outing auditReason(String? auditReason) => call(auditReason: auditReason);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Outing(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Outing(...).copyWith(id: 12, name: "My name")
  /// ```
  Outing call({
    Object? id = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
    Object? breakfastCancel = const $CopyWithPlaceholder(),
    Object? lunchCancel = const $CopyWithPlaceholder(),
    Object? dinnerCancel = const $CopyWithPlaceholder(),
    Object? from = const $CopyWithPlaceholder(),
    Object? to = const $CopyWithPlaceholder(),
    Object? approved = const $CopyWithPlaceholder(),
    Object? auditReason = const $CopyWithPlaceholder(),
  }) {
    return Outing(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String?,
      breakfastCancel: breakfastCancel == const $CopyWithPlaceholder()
          ? _value.breakfastCancel
          // ignore: cast_nullable_to_non_nullable
          : breakfastCancel as bool?,
      lunchCancel: lunchCancel == const $CopyWithPlaceholder()
          ? _value.lunchCancel
          // ignore: cast_nullable_to_non_nullable
          : lunchCancel as bool?,
      dinnerCancel: dinnerCancel == const $CopyWithPlaceholder()
          ? _value.dinnerCancel
          // ignore: cast_nullable_to_non_nullable
          : dinnerCancel as bool?,
      from: from == const $CopyWithPlaceholder()
          ? _value.from
          // ignore: cast_nullable_to_non_nullable
          : from as String?,
      to: to == const $CopyWithPlaceholder()
          ? _value.to
          // ignore: cast_nullable_to_non_nullable
          : to as String?,
      approved: approved == const $CopyWithPlaceholder()
          ? _value.approved
          // ignore: cast_nullable_to_non_nullable
          : approved as bool?,
      auditReason: auditReason == const $CopyWithPlaceholder()
          ? _value.auditReason
          // ignore: cast_nullable_to_non_nullable
          : auditReason as String?,
    );
  }
}

extension $OutingCopyWith on Outing {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfOuting.copyWith(...)` or `instanceOfOuting.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OutingCWProxy get copyWith => _$OutingCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StayApplyPeriod _$StayApplyPeriodFromJson(Map<String, dynamic> json) =>
    StayApplyPeriod(
      id: json['id'] as String,
      grade: (json['grade'] as num).toInt(),
      applyStart: json['apply_start'] as String,
      applyEnd: json['apply_end'] as String,
    );

Map<String, dynamic> _$StayApplyPeriodToJson(StayApplyPeriod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'grade': instance.grade,
      'apply_start': instance.applyStart,
      'apply_end': instance.applyEnd,
    };

StaySeat _$StaySeatFromJson(Map<String, dynamic> json) => StaySeat(
  id: json['id'] as String,
  target: json['target'] as String,
  range: json['range'] as String,
);

Map<String, dynamic> _$StaySeatToJson(StaySeat instance) => <String, dynamic>{
  'id': instance.id,
  'target': instance.target,
  'range': instance.range,
};

StaySeatPreset _$StaySeatPresetFromJson(Map<String, dynamic> json) =>
    StaySeatPreset(
      id: json['id'] as String,
      name: json['name'] as String,
      onlyReadingRoom: json['only_readingRoom'] as bool,
      staySeat: (json['stay_seat'] as List<dynamic>?)
          ?.map((e) => StaySeat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StaySeatPresetToJson(StaySeatPreset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'only_readingRoom': instance.onlyReadingRoom,
      'stay_seat': instance.staySeat,
    };

StayApplyUser _$StayApplyUserFromJson(Map<String, dynamic> json) =>
    StayApplyUser(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$StayApplyUserToJson(StayApplyUser instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

StayApplyItem _$StayApplyItemFromJson(Map<String, dynamic> json) =>
    StayApplyItem(
      id: json['id'] as String?,
      staySeat: json['stay_seat'] as String,
      user: StayApplyUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StayApplyItemToJson(StayApplyItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stay_seat': instance.staySeat,
      'user': instance.user,
    };

Stay _$StayFromJson(Map<String, dynamic> json) => Stay(
  id: json['id'] as String,
  name: json['name'] as String,
  stayFrom: json['stay_from'] as String,
  stayTo: json['stay_to'] as String,
  outingDay: (json['outing_day'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  stayApplyPeriod: (json['stay_apply_period'] as List<dynamic>?)
      ?.map((e) => StayApplyPeriod.fromJson(e as Map<String, dynamic>))
      .toList(),
  staySeatPreset: json['stay_seat_preset'] == null
      ? null
      : StaySeatPreset.fromJson(
          json['stay_seat_preset'] as Map<String, dynamic>,
        ),
  stayApply: (json['stay_apply'] as List<dynamic>?)
      ?.map((e) => StayApplyItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StayToJson(Stay instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'stay_from': instance.stayFrom,
  'stay_to': instance.stayTo,
  'outing_day': instance.outingDay,
  'stay_apply_period': instance.stayApplyPeriod,
  'stay_seat_preset': instance.staySeatPreset,
  'stay_apply': instance.stayApply,
};

Outing _$OutingFromJson(Map<String, dynamic> json) => Outing(
  id: json['id'] as String?,
  reason: json['reason'] as String?,
  breakfastCancel: json['breakfast_cancel'] as bool?,
  lunchCancel: json['lunch_cancel'] as bool?,
  dinnerCancel: json['dinner_cancel'] as bool?,
  from: json['from'] as String?,
  to: json['to'] as String?,
  approved: json['approved'] as bool?,
  auditReason: json['audit_reason'] as String?,
);

Map<String, dynamic> _$OutingToJson(Outing instance) => <String, dynamic>{
  'id': instance.id,
  'reason': instance.reason,
  'breakfast_cancel': instance.breakfastCancel,
  'lunch_cancel': instance.lunchCancel,
  'dinner_cancel': instance.dinnerCancel,
  'from': instance.from,
  'to': instance.to,
  'approved': instance.approved,
  'audit_reason': instance.auditReason,
};

StayApply _$StayApplyFromJson(Map<String, dynamic> json) => StayApply(
  id: json['id'] as String,
  staySeat: json['stay_seat'] as String,
  stay: json['stay'] == null
      ? null
      : Stay.fromJson(json['stay'] as Map<String, dynamic>),
  outing: (json['outing'] as List<dynamic>)
      .map((e) => Outing.fromJson(e as Map<String, dynamic>))
      .toList(),
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StayApplyToJson(StayApply instance) => <String, dynamic>{
  'id': instance.id,
  'stay_seat': instance.staySeat,
  'stay': instance.stay,
  'outing': instance.outing,
  'user': instance.user,
};
