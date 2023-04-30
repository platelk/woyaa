import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';
import 'package:woyaa/api/api.dart';

import '../../models/user.dart';
import '../../../constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../authentication/authentication_bloc.dart';
import '../users/user_bloc.dart';


part 'swipe_event.dart';

part 'swipe_state.dart';

class SwipeBloc extends Bloc<SwipeEvent, SwipeState> {
  AuthenticationBloc authBloc;
  UserBloc userBloc;

  SwipeBloc({required this.authBloc, required this.userBloc}) : super(SwipeInitial()) {
    on<LoadSwipeListEvent>(_onLoadSwipeListEvent);
    on<LoadingUserEvent>(_onLoadingUserEvent);
    on<UserLoadedEvent>(_onLoadUsersEvent);
    on<SwipeUserRetrievedEvent>(_onSwipeUserRetrievedEvent);
    on<SwipeLeftEvent>(_onSwipeLeftEvent);
    on<SwipeRightEvent>(_onSwipeRightEvent);

    authBloc.stream.listen((state) {
      if (state is LoggedInState) {
        add(LoadSwipeListEvent(token: state.token));
      }
    });
    if (authBloc.state is LoggedInState) {
      add(LoadSwipeListEvent(token: (authBloc.state as LoggedInState).token));
    }

    userBloc.stream.listen((state) {
      if (state is UserInitialized) {
        for (var user in state.users.values) {
          add(SwipeUserRetrievedEvent(token: state.token, user: user));
        }
      }
    });

    if (userBloc.state is UserInitialized) {
        for (var user in (userBloc.state as UserInitialized).users.values) {
          add(SwipeUserRetrievedEvent(token: (userBloc.state as UserInitialized).token, user: user));
        }
    }
  }

  void _onLoadSwipeListEvent(LoadSwipeListEvent event, Emitter<SwipeState> emit) {
    emit.call(SwipeLoading(token: event.token));
    GetSwipeList(event.token).then((value) {
      add(LoadingUserEvent(token: event.token, swipeList: value));
    });
  }

  void _onLoadingUserEvent(LoadingUserEvent event, Emitter<SwipeState> emit) {
    for (var userID in event.swipeList.toSwipe) {
      userBloc.add(UserRequested(token: event.token, requestedUser: userID));
    }
  }

  void _onSwipeUserRetrievedEvent(SwipeUserRetrievedEvent event, Emitter<SwipeState> emit) {
    if (state is SwipeLoaded) {
      var s = state as SwipeLoaded;
      emit.call(SwipeLoaded(token: event.token, users: Set.from(s.users)..add(event.user)));
    } else {
      emit.call(SwipeLoaded(token: event.token, users: {event.user}));
    }
  }

  void _onLoadUsersEvent(UserLoadedEvent event, Emitter<SwipeState> emit) {
    emit.call(SwipeLoaded(token: event.token, users: Set.from(event.users)));
  }

  void _onSwipeLeftEvent(SwipeLeftEvent event, Emitter<SwipeState> emit) {
    if (state is SwipeLoaded) {
      try {
        emit.call(SwipeLoaded(token: event.token, users: Set.from((state as SwipeLoaded).users)..remove(event.user)));
      } catch (_) {}
      if ((state as SwipeLoaded).users.length <= 1) {
        add(LoadSwipeListEvent(token: event.token));
      }
    }
    Swipe(event.token, event.user.id, false).then(_onSwipeResult);
  }

  void _onSwipeRightEvent(SwipeRightEvent event, Emitter<SwipeState> emit) {
    if (state is SwipeLoaded) {
      try {
        emit.call(SwipeLoaded(token: event.token, users: Set.from((state as SwipeLoaded).users)..remove(event.user)));
      } catch (_) {}
    }
    Swipe(event.token, event.user.id, true).then(_onSwipeResult);
  }

  void _onSwipeResult(SwipeResult res) {
    if (res.foundMyTable) {
      _winningSwipeSameTableToast();
    }
    if (res.foundNotMyTable) {
      _winningSwipeToast();
    }
    if (res.notFoundMyTable) {
      _losingSwipeSameTableToast();
    }
    if (res.notFoundNotMyTable) {
      _losingSwipeToast();
    }
  }
}

void _winningSwipeToast(){
  Fluttertoast.showToast(
    msg: "Bien joué ! Tu gagnes 2 points !",
    toastLength: Toast.LENGTH_SHORT,
    timeInSecForIosWeb: 1,
    gravity: ToastGravity.TOP,
    webPosition: "center",
    backgroundColor: kTablesBackgroundColor,
    webBgColor: "#2a4368",
    textColor: Colors.white,
    fontSize: 16.0,
    );
 } 

 void _winningSwipeSameTableToast(){
  Fluttertoast.showToast(
    msg: "Bien joué il est effectivement à ta table ! Tu gagnes 5 points !",
    toastLength: Toast.LENGTH_SHORT,
    timeInSecForIosWeb: 1,
    gravity: ToastGravity.TOP,
    webPosition: "center",
    backgroundColor: kTablesBackgroundColor,
    webBgColor: "#2a4368",
    textColor: Colors.white,
    fontSize: 16.0,
    );
 } 

void _losingSwipeToast(){
  Fluttertoast.showToast(
    msg: "Pas de chance, c'est raté ! Tu perds 1 point !",
    toastLength: Toast.LENGTH_SHORT,
    timeInSecForIosWeb: 1,
    gravity: ToastGravity.TOP,
    webPosition: "center",
    backgroundColor: kWelcomeBackgroundColor,
    webBgColor: "#bf7366",
    textColor: Colors.white,
    fontSize: 16.0,
    );
 } 

 void _losingSwipeSameTableToast(){
  Fluttertoast.showToast(
    msg: "C'est raté il ou elle est à ta table ! Tu perds 2 points !",
    toastLength: Toast.LENGTH_SHORT,
    timeInSecForIosWeb: 1,
    gravity: ToastGravity.TOP,
    webPosition: "center",
    backgroundColor: kWelcomeBackgroundColor,
    webBgColor: "#bf7366",
    textColor: Colors.white,
    fontSize: 16.0,
    );
 }
