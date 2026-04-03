import 'model.dart';

sealed class WakeupState {
  const WakeupState();
}

final class WakeupInitial extends WakeupState {
  const WakeupInitial();
}

final class WakeupLoading extends WakeupState {
  const WakeupLoading();
}

final class WakeupSuccess extends WakeupState {
  final List<WakeupApplicationWithVote> wakeups;

  const WakeupSuccess(this.wakeups);
}

final class WakeupFailure extends WakeupState {
  final String error;

  const WakeupFailure(this.error);
}

sealed class WakeupVoteState {
  const WakeupVoteState();
}

final class WakeupVoteInitial extends WakeupVoteState {
  const WakeupVoteInitial();
}

final class WakeupVoteLoading extends WakeupVoteState {
  const WakeupVoteLoading();
}

final class WakeupVoteSuccess extends WakeupVoteState {
  final List<WakeupApplicationVotes> votes;

  const WakeupVoteSuccess(this.votes);
}

final class WakeupVoteFailure extends WakeupVoteState {
  final String error;

  const WakeupVoteFailure(this.error);
}