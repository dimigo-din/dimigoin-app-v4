import 'model.dart';

sealed class StayState {
  const StayState();
}

final class StayInitial extends StayState {
  const StayInitial();
}

final class StayLoading extends StayState {
  const StayLoading();
}

final class StaySuccess extends StayState {
  final List<Stay> stays;

  const StaySuccess(this.stays);
}

final class StayFailure extends StayState {
  final String error;

  const StayFailure(this.error);
}

sealed class StayApplyState {
  const StayApplyState();
}

final class StayApplyInitial extends StayApplyState {
  const StayApplyInitial();
}

final class StayApplyLoading extends StayApplyState {
  const StayApplyLoading();
}

final class StayApplySuccess extends StayApplyState {
  final List<StayApply> stayApplies;

  const StayApplySuccess(this.stayApplies);
}

final class StayApplyFailure extends StayApplyState {
  final String error;

  const StayApplyFailure(this.error);
}

sealed class StayOutingState {
  const StayOutingState();
}

final class StayOutingInitial extends StayOutingState {
  const StayOutingInitial();
}

final class StayOutingLoading extends StayOutingState {
  const StayOutingLoading();
}

final class StayOutingSuccess extends StayOutingState {
  final List<Outing> outings;

  const StayOutingSuccess(this.outings);
}

final class StayOutingFailure extends StayOutingState {
  final String error;

  const StayOutingFailure(this.error);
}