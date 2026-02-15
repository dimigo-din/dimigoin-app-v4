// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meal _$MealFromJson(Map<String, dynamic> json) => Meal(
  breakfast: MealBreakfast.fromJson(json['breakfast'] as Map<String, dynamic>),
  lunch: MealLunch.fromJson(json['lunch'] as Map<String, dynamic>),
  dinner: MealDinner.fromJson(json['dinner'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MealToJson(Meal instance) => <String, dynamic>{
  'breakfast': instance.breakfast.toJson(),
  'lunch': instance.lunch.toJson(),
  'dinner': instance.dinner.toJson(),
};

MealBreakfast _$MealBreakfastFromJson(
  Map<String, dynamic> json,
) => MealBreakfast(
  regular:
      (json['regular'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  simple:
      (json['simple'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  image: json['image'] as String? ?? '',
);

Map<String, dynamic> _$MealBreakfastToJson(MealBreakfast instance) =>
    <String, dynamic>{
      'regular': instance.regular,
      'simple': instance.simple,
      'image': instance.image,
    };

MealLunch _$MealLunchFromJson(Map<String, dynamic> json) => MealLunch(
  regular:
      (json['regular'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  image: json['image'] as String? ?? '',
  time: json['time'] as String? ?? '',
);

Map<String, dynamic> _$MealLunchToJson(MealLunch instance) => <String, dynamic>{
  'regular': instance.regular,
  'image': instance.image,
  'time': instance.time,
};

MealDinner _$MealDinnerFromJson(Map<String, dynamic> json) => MealDinner(
  regular:
      (json['regular'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  simple:
      (json['simple'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  image: json['image'] as String? ?? '',
  time: json['time'] as String? ?? '',
);

Map<String, dynamic> _$MealDinnerToJson(MealDinner instance) =>
    <String, dynamic>{
      'regular': instance.regular,
      'simple': instance.simple,
      'image': instance.image,
      'time': instance.time,
    };
