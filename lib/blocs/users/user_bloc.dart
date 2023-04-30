import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:woyaa/api/api.dart';

import '../../models/user.dart';
import '../authentication/authentication_bloc.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  AuthenticationBloc authBloc;

  UserBloc({required this.authBloc}) : super(UserInitial()) {
    on<UserTokenProvided>(_onUserTokenProvided);
    on<UserRequested>(_onUserRequested);
    on<UserLoaded>(_onUserLoaded);
    authBloc.stream.listen((state) {
      if (state is LoggedInState) {
        add(UserTokenProvided(token: state.token));
      }
    });
    if (authBloc.state is LoggedInState) {
      add(UserTokenProvided(token: (authBloc.state as LoggedInState).token));
    }
  }

  void _onUserTokenProvided(UserTokenProvided event, Emitter<UserState> emit) {
    if (state is UserInitialized) {
      emit.call(UserInitialized(
          token: event.token, users: (state as UserInitialized).users));
    } else {
      emit.call(UserInitialized(token: event.token, users: const {}));
    }
  }

  void _onUserRequested(UserRequested event, Emitter<UserState> emit) {
    if (state is! UserInitialized) {
      return;
    }
    GetUser((state as UserInitialized).token, event.requestedUser)
        .then((value) {
      add(UserLoaded(token: event.token, user: value));
    });
  }

  void _onUserLoaded(UserLoaded event, Emitter<UserState> emit) {
    if (state is! UserInitialized) {
      return;
    }
    print("on user loaded: $event");
    var s = state as UserInitialized;
    emit.call(UserInitialized(token: s.token, users: Map.from(s.users)..[event.user.id] = event.user));
  }
}
