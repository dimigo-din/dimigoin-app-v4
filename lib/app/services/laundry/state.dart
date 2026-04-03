import 'model.dart';

sealed class LaundryTimelineState {
  const LaundryTimelineState();
}

final class LaundryTimelineInitial extends LaundryTimelineState {
  const LaundryTimelineInitial();
}

final class LaundryTimelineLoading extends LaundryTimelineState {
  const LaundryTimelineLoading();
}

final class LaundryTimelineSuccess extends LaundryTimelineState {
  final LaundryTimeline timeline;

  const LaundryTimelineSuccess(this.timeline);
}

final class LaundryTimelineFailure extends LaundryTimelineState {
  final Exception exception;

  const LaundryTimelineFailure(this.exception);
}

sealed class LaundryApplyState {
  const LaundryApplyState();
}

final class LaundryApplyInitial extends LaundryApplyState {
  const LaundryApplyInitial();
}

final class LaundryApplyLoading extends LaundryApplyState {
  const LaundryApplyLoading();
}

final class LaundryApplySuccess extends LaundryApplyState {
  final List<LaundryApply> applications;

  const LaundryApplySuccess(this.applications);
}

final class LaundryApplyFailure extends LaundryApplyState {
  final Exception exception;

  const LaundryApplyFailure(this.exception);
}