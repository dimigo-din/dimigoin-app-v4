import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable(explicitToJson: true)
class Meal {
  final MealBreakfast breakfast;
  final MealLunch lunch;
  final MealDinner dinner;

  Meal({required this.breakfast, required this.lunch, required this.dinner});

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
  Map<String, dynamic> toJson() => _$MealToJson(this);
}

@JsonSerializable()
class MealBreakfast {
  @JsonKey(defaultValue: <String>[])
  final List<String> regular;
  @JsonKey(defaultValue: <String>[])
  final List<String> simple;
  @JsonKey(defaultValue: '')
  final String image;

  MealBreakfast({
    required this.regular,
    required this.simple,
    required this.image,
  });

  factory MealBreakfast.fromJson(Map<String, dynamic> json) =>
      _$MealBreakfastFromJson(json);
  Map<String, dynamic> toJson() => _$MealBreakfastToJson(this);
}

@JsonSerializable()
class MealLunch {
  @JsonKey(defaultValue: <String>[])
  final List<String> regular;
  @JsonKey(defaultValue: '')
  final String image;
  @JsonKey(defaultValue: '')
  final String time;

  MealLunch({required this.regular, required this.image, required this.time});

  factory MealLunch.fromJson(Map<String, dynamic> json) =>
      _$MealLunchFromJson(json);
  Map<String, dynamic> toJson() => _$MealLunchToJson(this);
}

@JsonSerializable()
class MealDinner {
  @JsonKey(defaultValue: <String>[])
  final List<String> regular;
  @JsonKey(defaultValue: <String>[])
  final List<String> simple;
  @JsonKey(defaultValue: '')
  final String image;
  @JsonKey(defaultValue: '')
  final String time;

  MealDinner({
    required this.regular,
    required this.simple,
    required this.image,
    required this.time,
  });

  factory MealDinner.fromJson(Map<String, dynamic> json) =>
      _$MealDinnerFromJson(json);
  Map<String, dynamic> toJson() => _$MealDinnerToJson(this);
}

enum MealType { breakfast, lunch, dinner }

class MealMenuData {
  final MealType type;
  final String title;
  final String time;
  final List<String> regular;
  final List<String> simple;
  final String image;

  const MealMenuData({
    required this.type,
    required this.title,
    required this.time,
    required this.regular,
    required this.simple,
    required this.image,
  });

  List<String> get allItems => [...regular, ...simple];
  String get content => allItems.join(', ');
}

class MealDayData {
  final DateTime date;
  final String dayLabel;
  final List<MealMenuData> menus;

  const MealDayData({
    required this.date,
    required this.dayLabel,
    required this.menus,
  });
}
