import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'model.dart';
import 'repository.dart';

class MealService extends GetxController {
  final MealRepository repository;

  MealService({MealRepository? repository})
    : repository = repository ?? MealRepository();

  @override
  Future<void> onInit() async {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {}

  Future<Meal> getMeal({DateTime? date}) async {
    try {
      final response = await repository.getMeal(date: _toApiDate(date));
      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<MealMenuData>> getMealMenus({DateTime? date}) async {
    final meal = await getMeal(date: date);
    return convertToMenus(meal);
  }

  Future<List<MealDayData>> getWeeklyMealMenus({DateTime? baseDate}) async {
    final normalizedBaseDate = _normalizeKstDate(baseDate ?? DateTime.now());
    final weekStart = normalizedBaseDate.subtract(
      Duration(days: normalizedBaseDate.weekday - DateTime.monday),
    );
    final dates = List.generate(
      7,
      (index) => weekStart.add(Duration(days: index)),
      growable: false,
    );

    try {
      final meals = await Future.wait<Meal?>(
        dates
            .map((date) async {
              try {
                return await repository.getMeal(date: _toApiDate(date));
              } on DioException catch (e) {
                if (e.response?.statusCode == 404) {
                  return null;
                }
                rethrow;
              }
            })
            .toList(growable: false),
      );

      return List.generate(
        dates.length,
        (index) => MealDayData(
          date: dates[index],
          dayLabel: _weekdayToKorean(dates[index].weekday),
          menus: meals[index] == null
              ? const []
              : convertToMenus(meals[index]!),
        ),
        growable: false,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  List<MealMenuData> convertToMenus(Meal meal) {
    return [
      MealMenuData(
        type: MealType.breakfast,
        title: '아침',
        time: '',
        regular: _normalizeItems(meal.breakfast.regular),
        simple: _normalizeItems(meal.breakfast.simple),
        image: meal.breakfast.image.trim(),
      ),
      MealMenuData(
        type: MealType.lunch,
        title: '점심',
        time: meal.lunch.time.trim(),
        regular: _normalizeItems(meal.lunch.regular),
        simple: const [],
        image: meal.lunch.image.trim(),
      ),
      MealMenuData(
        type: MealType.dinner,
        title: '저녁',
        time: meal.dinner.time.trim(),
        regular: _normalizeItems(meal.dinner.regular),
        simple: _normalizeItems(meal.dinner.simple),
        image: meal.dinner.image.trim(),
      ),
    ];
  }

  List<String> _normalizeItems(List<String> items) {
    return items
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  DateTime _normalizeKstDate(DateTime dateTime) {
    final kstDate = dateTime.toUtc().add(const Duration(hours: 9));
    return DateTime(kstDate.year, kstDate.month, kstDate.day);
  }

  String? _toApiDate(DateTime? dateTime) {
    if (dateTime == null) return null;

    final normalized = _normalizeKstDate(dateTime);
    final year = normalized.year.toString().padLeft(4, '0');
    final month = normalized.month.toString().padLeft(2, '0');
    final day = normalized.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String _weekdayToKorean(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return '월';
      case DateTime.tuesday:
        return '화';
      case DateTime.wednesday:
        return '수';
      case DateTime.thursday:
        return '목';
      case DateTime.friday:
        return '금';
      case DateTime.saturday:
        return '토';
      case DateTime.sunday:
        return '일';
      default:
        return '';
    }
  }
}
