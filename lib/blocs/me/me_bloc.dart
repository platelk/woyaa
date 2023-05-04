import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../api/api.dart';
import '../../models/user.dart';
import '../authentication/authentication_bloc.dart';
import '../users/user_bloc.dart';

part 'me_event.dart';

part 'me_state.dart';

class MeBloc extends Bloc<MeEvent, MeState> {
  AuthenticationBloc authBloc;
  UserBloc userBloc;

  MeBloc({required this.authBloc, required this.userBloc}) : super(MeInitial()) {
    on<LoadingMe>(_onLoadingMe);
    on<LoadedMe>(_onLoadedMe);
    authBloc.stream.listen((state) {
      if (state is LoggedInState) {
        add(LoadingMe(token: state.token));
      }
    });
    if (authBloc.state is LoggedInState) {
      add(LoadingMe(token: (authBloc.state as LoggedInState).token));
    }
  }

  void _onLoadingMe(LoadingMe event, Emitter<MeState> emit) {
    emit.call(MeLoading(token: event.token));
    GetMe(event.token).then((value) {
      add(LoadedMe(me: value, token: event.token));
    });
  }

  void _onLoadedMe(LoadedMe event, Emitter<MeState> emit) {
    emit.call(MeLoaded(me: event.me));
    userBloc.add(UserLoaded(user: event.me, token: event.token));
  }
}
