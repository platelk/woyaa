part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserTokenProvided extends UserEvent {
  final String token;

  const UserTokenProvided({required this.token});
}

class UserRequested extends UserEvent {
  final String token;
  final int requestedUser;

  const UserRequested({required this.token, required this.requestedUser});
}

class UserLoaded extends UserEvent {
  final String token;
  final User user;

  const UserLoaded({required this.token, required this.user});
}