import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:woyaa/api/api.dart';

import '../../models/table.dart';
import '../../models/user.dart';
import '../authentication/authentication_bloc.dart';
import '../users/user_bloc.dart';

part 'tables_event.dart';
part 'tables_state.dart';

class TablesBloc extends Bloc<TablesEvent, TablesState> {
  AuthenticationBloc authBloc;
  UserBloc userBloc;

  TablesBloc({required this.authBloc, required this.userBloc}) : super(TablesInitial()) {
    on<LoadingTableEvent>(_onLoadingTableEvent);
    on<TableLoadedEvent>(_onTableLoadedEvent);
    on<UserInTableEvent>(_onUserInTableEvent);


    authBloc.stream.listen((state) {
      if (state is LoggedInState) {
        add(LoadingTableEvent(token: state.token));
      }
    });
    if (authBloc.state is LoggedInState) {
      add(LoadingTableEvent(token: (authBloc.state as LoggedInState).token));
    }
    userBloc.stream.listen((state) {
      if (state is UserInitialized) {
        for (var user in state.users.values) {
          add(UserInTableEvent(token: state.token, user: user));
        }
      }
    });

    if (userBloc.state is UserInitialized) {
      for (var user in (userBloc.state as UserInitialized).users.values) {
        add(UserInTableEvent(token: (userBloc.state as UserInitialized).token, user: user));
      }
    }
  }

  void _onLoadingTableEvent(LoadingTableEvent event, Emitter<TablesState> emit) {
    GetTables(event.token).then((value) {
      add(TableLoadedEvent(token: event.token, tables: value));
    });
  }

  void _onTableLoadedEvent(TableLoadedEvent event, Emitter<TablesState> emit) {
    emit.call(TablesInitialized(token: event.token, tables: event.tables));
  }

  void _onUserInTableEvent(UserInTableEvent event, Emitter<TablesState> emit) {
    if (state is TablesInitialized) {
      var i = state as TablesInitialized;
      emit.call(TablesInitialized(token: i.token, tables: Map.from(i.tables)..[event.user.tableName]?.users.add(event.user)));
    }
  }
}
