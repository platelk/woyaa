import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:woyaa/api/api.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<LogInStartEvent>(_onLogInStartEvent);
    on<LoggingEvent>(_onLoggingEvent);
    on<LoggedInEvent>(_onLoggedInEvent);
  }

  void _onLogInStartEvent(LogInStartEvent event, Emitter<AuthenticationState> emit) {
    emit.call(LogInStartingState(email: event.email));
  }

  void _onLoggingEvent(LoggingEvent event, Emitter<AuthenticationState> emit) {
      final email = event.email;
      emit.call(LoggedProcessing(email: email));
      LogIn(email).then((value) {
        add(LoggedInEvent(token: value));
      });
  }

  void _onLoggedInEvent(LoggedInEvent event, Emitter<AuthenticationState> emit) {
    print("loaded state");
    emit.call(LoggedInState(token: event.token));
  }
}
