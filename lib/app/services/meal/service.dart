import 'dart:developer';

import 'package:get/get.dart';

import 'model.dart';
import 'repository.dart';
import 'state.dart';

class MealService extends GetxController {
  final MealRepository repository;
  final Map<String, List<MealMenuData>> _mealCache = {};

  final Rx<MealState> _mealState = Rx<MealState>(
    const MealInitial(),
  );
  MealState get mealState => _mealState.value;
  Rx<MealState> get mealStateRx => _mealState;

  MealService({MealRepository? repository})
    : repository = repository ?? MealRepository();

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {}

  Future<void> getMeal(DateTime date) async {
    final dateKey = _toDateKeyString(date);
    
    if (_mealCache.containsKey(dateKey)) {
      _mealState.value = MealSuccess(_mealCache[dateKey]!);
      return;
    }

    _mealState.value = const MealLoading();
    try {
      final meal = await repository.getMeal(date: _toApiDate(date));
      final menus = convertToMenus(meal);
      _mealCache[dateKey] = menus;
      _mealState.value = MealSuccess(menus);
    } catch (e) {
      log(e.toString());
      _mealState.value = MealFailure(Exception(e.toString()));
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

  String _toDateKeyString(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
