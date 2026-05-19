import 'model.dart';

sealed class MealState {
  const MealState();
}

final class MealInitial extends MealState {
  const MealInitial();
}

final class MealLoading extends MealState {
  const MealLoading();
}

final class MealSuccess extends MealState {
  final List<MealMenuData> meal;

  const MealSuccess(this.meal);
}

final class MealFailure extends MealState {
  final Exception exception;

  const MealFailure(this.exception);
}