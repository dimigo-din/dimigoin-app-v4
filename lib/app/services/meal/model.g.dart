// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meal _$MealFromJson(Map<String, dynamic> json) => Meal(
  breakfast: MealMenu.fromJson(json['breakfast'] as Map<String, dynamic>),
  lunch: MealMenu.fromJson(json['lunch'] as Map<String, dynamic>),
  dinner: MealMenu.fromJson(json['dinner'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MealToJson(Meal instance) => <String, dynamic>{
  'breakfast': instance.breakfast.toJson(),
  'lunch': instance.lunch.toJson(),
  'dinner': instance.dinner.toJson(),
};

MealMenu _$MealMenuFromJson(Map<String, dynamic> json) => MealMenu(
  regular:
      (json['regular'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  simple:
      (json['simple'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  image: json['image'] as String? ?? '',
  time: json['time'] as String? ?? '',
);

Map<String, dynamic> _$MealMenuToJson(MealMenu instance) => <String, dynamic>{
  'regular': instance.regular,
  'simple': instance.simple,
  'image': instance.image,
  'time': instance.time,
};
