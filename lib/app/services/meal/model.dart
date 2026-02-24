import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Meal {
  final MealMenu breakfast;
  final MealMenu lunch;
  final MealMenu dinner;

  Meal({required this.breakfast, required this.lunch, required this.dinner});

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
  Map<String, dynamic> toJson() => _$MealToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MealMenu {
  @JsonKey(defaultValue: <String>[])
  final List<String> regular;
  @JsonKey(defaultValue: <String>[])
  final List<String> simple;
  @JsonKey(defaultValue: '')
  final String image;
  @JsonKey(defaultValue: '')
  final String time;

  MealMenu({
    required this.regular,
    required this.simple,
    required this.image,
    required this.time,
  });

  factory MealMenu.fromJson(Map<String, dynamic> json) =>
      _$MealMenuFromJson(json);
  Map<String, dynamic> toJson() => _$MealMenuToJson(this);
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
