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
  final Set<int> userIds;
  final Set<int> swipedUserIds;

  const SwipeRetrieved({required this.token, required this.userIds, required this.swipedUserIds});

  @override
  List<Object> get props => [token, userIds, swipedUserIds];
}

class SwipeLoaded extends SwipeState {
  final String token;
  final Set<int> userIds;
  final Set<int> swipedUserIds;
  final Set<User> users;
  final Set<User> swipedUsers;

  const SwipeLoaded({required this.token, required this.userIds, required this.swipedUserIds, required this.users, required this.swipedUsers});

  @override
  List<Object> get props => [token, users, swipedUsers];
}

class SwipeError extends SwipeState {}
