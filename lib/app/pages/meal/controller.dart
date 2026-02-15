import 'dart:developer';

import 'package:dimigoin_app_v4/app/services/meal/model.dart';
import 'package:dimigoin_app_v4/app/services/meal/service.dart';
import 'package:get/get.dart';

class MealMenu {
  final String title;
  final String time;
  final List<String> items;
  final bool highlighted;

  const MealMenu({
    required this.title,
    required this.time,
    required this.items,
    this.highlighted = false,
  });
}

class MealDay {
  final String dayLabel;
  final List<MealMenu> meals;

  const MealDay({required this.dayLabel, required this.meals});

  String? get label => null;
}

class MealPageController extends GetxController {
  final MealService _mealService;

  MealPageController({MealService? mealService})
    : _mealService = mealService ?? MealService();

  final RxInt selectedDayIndex = 0.obs;
  final RxList<MealDay> mealDays = RxList<MealDay>(_defaultMealDays());
  final RxBool isLoading = true.obs;
  final RxBool hasLoadError = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    selectedDayIndex.value = _todayIndexByKst();
    await fetchWeeklyMeals();
  }

  List<MealMenu> get meals {
    if (mealDays.isEmpty) return const [];

    final index = selectedDayIndex.value;
    final safeIndex = (index < 0 || index >= mealDays.length) ? 0 : index;
    return mealDays[safeIndex].meals;
  }

  Future<void> fetchWeeklyMeals() async {
    isLoading.value = true;
    hasLoadError.value = false;

    try {
      final weeklyMealMenus = await _mealService.getWeeklyMealMenus();
      mealDays.value = weeklyMealMenus
          .map(
            (dayData) => MealDay(
              dayLabel: dayData.dayLabel,
              meals: dayData.menus
                  .map(
                    (menuData) => MealMenu(
                      title: menuData.title,
                      time: menuData.time,
                      items: menuData.allItems,
                      highlighted: menuData.type == MealType.lunch,
                    ),
                  )
                  .toList(growable: false),
            ),
          )
          .toList(growable: false);
    } catch (e, stackTrace) {
      hasLoadError.value = true;
      mealDays.value = _defaultMealDays();
      log('Error fetching weekly meals: $e', stackTrace: stackTrace);
    } finally {
      isLoading.value = false;
    }
  }

  void selectDay(int index) {
    if (index < 0 || index >= mealDays.length) return;
    selectedDayIndex.value = index;
  }

  static List<MealDay> _defaultMealDays() {
    return const [
      MealDay(dayLabel: '월', meals: []),
      MealDay(dayLabel: '화', meals: []),
      MealDay(dayLabel: '수', meals: []),
      MealDay(dayLabel: '목', meals: []),
      MealDay(dayLabel: '금', meals: []),
      MealDay(dayLabel: '토', meals: []),
      MealDay(dayLabel: '일', meals: []),
    ];
  }

  int _todayIndexByKst() {
    final nowKst = DateTime.now().toUtc().add(const Duration(hours: 9));
    return nowKst.weekday - DateTime.monday;
  }
}
