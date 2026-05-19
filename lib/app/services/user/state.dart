import './model.dart';

sealed class UserApplyState {
  const UserApplyState();
}

final class UserApplyInitial extends UserApplyState {
  const UserApplyInitial();
}

final class UserApplyLoading extends UserApplyState {
  const UserApplyLoading();
}

final class UserApplySuccess extends UserApplyState {
  final UserApply userApply;

  const UserApplySuccess(this.userApply);
}

final class UserApplyFailure extends UserApplyState {
  final String error;

  const UserApplyFailure(this.error);
}

sealed class UserTimelineState {
  const UserTimelineState();
}

final class UserTimelineInitial extends UserTimelineState {
  const UserTimelineInitial();
}

final class UserTimelineLoading extends UserTimelineState {
  const UserTimelineLoading();
}

final class UserTimelineSuccess extends UserTimelineState {
  final Timetable timetable;

  const UserTimelineSuccess(this.timetable);
}

final class UserTimelineFailure extends UserTimelineState {
  final String error;

  const UserTimelineFailure(this.error);
}