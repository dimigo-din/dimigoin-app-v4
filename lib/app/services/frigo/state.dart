import 'model.dart';

sealed class FrigoState {
  const FrigoState();
}

final class FrigoInitial extends FrigoState {
  const FrigoInitial();
}

final class FrigoLoading extends FrigoState {
  const FrigoLoading();
}

final class FrigoSuccess extends FrigoState {
  final Frigo? frigo;

  const FrigoSuccess(this.frigo);
}

final class FrigoFailure extends FrigoState {
  final String error;

  const FrigoFailure(this.error);
}