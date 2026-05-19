import 'dart:developer';

import 'package:dimigoin_app_v4/app/services/meal/model.dart';
import 'package:dimigoin_app_v4/app/services/meal/service.dart';
import 'package:dimigoin_app_v4/app/services/meal/state.dart';
import 'package:get/get.dart';

class MealPageController extends GetxController {
  final MealService _mealService;

  MealPageController({MealService? mealService})
    : _mealService = mealService ?? MealService();

  final RxInt selectedDayIndex = 0.obs;
  static const List<String> dayLabels = ['월', '화', '수', '목', '금', '토', '일'];

  MealService get mealService => _mealService;
  DateTime get selectedDate => _dateByDayIndex(selectedDayIndex.value);

  List<MealMenuData> get meals {
    final state = _mealService.mealState;
    if (state is MealSuccess) return state.meal;
    return const [];
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    selectedDayIndex.value = _todayIndexByKst();
    await fetchSelectedDayMeals();
  }

  MealType getCurrentMealType() {
    final nowKst = DateTime.now().toUtc().add(const Duration(hours: 9));
    final currentHour = nowKst.hour;

    if (currentHour >= 14) {
      return MealType.dinner;
    } else if (currentHour >= 8) {
      return MealType.lunch;
    } else {
      return MealType.breakfast;
    }
  }

  bool isHighlightedMeal(MealType mealType, DateTime dayDate) {
    final currentMealType = getCurrentMealType();
    return mealType == currentMealType && _isTodayKst(dayDate);
  }

  Future<void> fetchSelectedDayMeals() async {
    try {
      await _mealService.getMeal(selectedDate);
    } catch (e, stackTrace) {
      log(
        'Error fetching meals for day index ${selectedDayIndex.value}: $e',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> selectDay(int index) async {
    if (index < 0 || index >= dayLabels.length) return;
    selectedDayIndex.value = index;
    await fetchSelectedDayMeals();
  }

  int _todayIndexByKst() {
    final nowKst = DateTime.now().toUtc().add(const Duration(hours: 9));
    return nowKst.weekday - DateTime.monday;
  }

  DateTime _weekStartByKst() {
    final nowKst = DateTime.now().toUtc().add(const Duration(hours: 9));
    final normalizedNow = DateTime(nowKst.year, nowKst.month, nowKst.day);
    return normalizedNow.subtract(
      Duration(days: normalizedNow.weekday - DateTime.monday),
    );
  }

  DateTime _dateByDayIndex(int dayIndex) {
    return _weekStartByKst().add(Duration(days: dayIndex));
  }

  bool _isTodayKst(DateTime date) {
    final nowKst = DateTime.now().toUtc().add(const Duration(hours: 9));
    return date.year == nowKst.year &&
        date.month == nowKst.month &&
        date.day == nowKst.day;
  }
}
