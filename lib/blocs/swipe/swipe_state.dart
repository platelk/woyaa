part of 'swipe_bloc.dart';

abstract class SwipeState extends Equatable {
  const SwipeState();

  @override
  List<Object> get props => [];
}

class SwipeInitial extends SwipeState {}

class SwipeLoading extends SwipeState {
  final String token;

  const SwipeLoading({required this.token});
}

class SwipeRetrieved extends SwipeState {
  final String token;
  final List<int> userIds;

  const SwipeRetrieved({required this.token, required this.userIds});

  @override
  List<Object> get props => [token, userIds];
}

class SwipeLoaded extends SwipeState {
  final String token;
  final Set<User> users;

  const SwipeLoaded({required this.token, required this.users});

  @override
  List<Object> get props => [token, users];
}

class SwipeError extends SwipeState {}
