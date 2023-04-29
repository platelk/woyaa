part of 'swipe_bloc.dart';

abstract class SwipeEvent extends Equatable {
  const SwipeEvent();

  @override
  List<Object> get props => [];
}

class LoadSwipeListEvent extends SwipeEvent {
  final String token;

  const LoadSwipeListEvent({required this.token});

  @override
  List<Object> get props => [token];
}

class LoadingUserEvent extends SwipeEvent {
  final String token;
  final List<int> userIds;

  const LoadingUserEvent({required this.token, required this.userIds});

  @override
  List<Object> get props => [token, userIds];
}

class SwipeUserRetrievedEvent extends SwipeEvent {
  final String token;
  final User user;

  const SwipeUserRetrievedEvent({required this.token, required this.user});

  @override
  List<Object> get props => [token, user];
}

class UserLoadedEvent extends SwipeEvent {
  final String token;
  final List<User> users;

  const UserLoadedEvent({required this.token, required this.users});

  @override
  List<Object> get props => [token, users];
}

class SwipeLeftEvent extends SwipeEvent {
  final String token;
  final User user;

  const SwipeLeftEvent({required this.token, required this.user});

  @override
  List<Object> get props => [token, user];
}

class SwipeRightEvent extends SwipeEvent {
  final String token;
  final User user;

  const SwipeRightEvent({required this.token, required this.user});

  @override
  List<Object> get props => [token, user];
}