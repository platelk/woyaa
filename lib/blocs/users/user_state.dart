part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserInitialized extends UserState {
  final String token;
  final Map<int, User> users;

  const UserInitialized({required this.token, required this.users});

  @override
  List<Object> get props => [token, users];
}