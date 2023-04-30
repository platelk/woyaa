import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:woyaa/api/api.dart';

import '../../models/user.dart';
import '../authentication/authentication_bloc.dart';

part 'me_event.dart';

part 'me_state.dart';

class MeBloc extends Bloc<MeEvent, MeState> {
  AuthenticationBloc authBloc;

  MeBloc({required this.authBloc}) : super(MeInitial()) {
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
      add(LoadedMe(me: value));
    });
  }

  void _onLoadedMe(LoadedMe event, Emitter<MeState> emit) {
    emit.call(MeLoaded(me: event.me));
  }
}
