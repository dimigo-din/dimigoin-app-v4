import 'model.dart';

sealed class LostfoundState {
  const LostfoundState();
}

final class LostfoundInitial extends LostfoundState {
  const LostfoundInitial();
}

final class LostfoundLoading extends LostfoundState {
  const LostfoundLoading();
}

final class LostfoundSuccess extends LostfoundState {
  final List<LostfoundReport> reports;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;
  final Exception? loadMoreException;

  const LostfoundSuccess(
    this.reports, {
    required this.page,
    required this.hasMore,
    this.isLoadingMore = false,
    this.loadMoreException,
  });
}

final class LostfoundFailure extends LostfoundState {
  final Exception exception;

  const LostfoundFailure(this.exception);
}

sealed class LostfoundDetailState {
  const LostfoundDetailState();
}

final class LostfoundDetailInitial extends LostfoundDetailState {
  const LostfoundDetailInitial();
}

final class LostfoundDetailLoading extends LostfoundDetailState {
  const LostfoundDetailLoading();
}

final class LostfoundDetailSuccess extends LostfoundDetailState {
  final LostfoundReport report;

  const LostfoundDetailSuccess(this.report);
}

final class LostfoundDetailFailure extends LostfoundDetailState {
  final Exception exception;

  const LostfoundDetailFailure(this.exception);
}
