part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class LogInStartEvent extends AuthenticationEvent {
  final String email;

  const LogInStartEvent({required this.email});
}

class LoggingEvent extends AuthenticationEvent {
  final String email;

  const LoggingEvent({required this.email});
}

class LoggedInEvent extends AuthenticationEvent {
  final String token;

  const LoggedInEvent({required this.token});
}

class LogoutEvent extends AuthenticationEvent {}
