part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class LoggedInState extends AuthenticationState {
  final String token;

  const LoggedInState({required this.token});

  @override
  List<Object> get props => [token];

}

class LogInStartingState extends AuthenticationState {
  final String email;

  const LogInStartingState({required this.email});

  @override
  List<Object> get props => [email];
}

class LoggedProcessing extends AuthenticationState {
  final String email;

  const LoggedProcessing({required this.email});

  @override
  List<Object> get props => [email];
}

class LoggedOutState extends AuthenticationState {}