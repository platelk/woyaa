import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';

import '../../api/api.dart';
import '../../models/user.dart';
import '../../../constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../authentication/authentication_bloc.dart';
import '../me/me_bloc.dart';
import '../users/user_bloc.dart';

part 'swipe_event.dart';

part 'swipe_state.dart';

class SwipeBloc extends Bloc<SwipeEvent, SwipeState> {
  AuthenticationBloc authBloc;
  UserBloc userBloc;
  MeBloc meBloc;
  late User me;

  SwipeBloc({required this.authBloc, required this.userBloc, required this.meBloc})
      : super(SwipeInitial()) {
    on<LoadSwipeListEvent>(_onLoadSwipeListEvent);
    on<LoadingUserEvent>(_onLoadingUserEvent);
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
        add(SwipeUserRetrievedEvent(
            token: (userBloc.state as UserInitialized).token, user: user));
      }
    }
    meBloc.stream.listen((state) {
      if (state is MeLoaded) {
        me = state.me;
      }
    });
    if (meBloc.state is MeLoaded) {
      me = (meBloc.state as MeLoaded).me;
    }
  }

  void _onLoadSwipeListEvent(
      LoadSwipeListEvent event, Emitter<SwipeState> emit) {
    emit.call(SwipeLoading(token: event.token));
    GetSwipeList(event.token).then((value) {
      add(LoadingUserEvent(token: event.token, swipeList: value));
    });
  }

  void _onLoadingUserEvent(LoadingUserEvent event, Emitter<SwipeState> emit) {
    if (state is! SwipeLoaded) {
      emit.call(SwipeRetrieved(token: event.token, userIds: Set.from(event.swipeList.toSwipe), swipedUserIds: Set.from(event.swipeList.swiped)));
    }
    for (var userID in event.swipeList.toSwipe) {
      userBloc.add(UserRequested(token: event.token, requestedUser: userID));
    }
    for (var userID in event.swipeList.swiped) {
      userBloc.add(UserRequested(token: event.token, requestedUser: userID));
    }
  }

  void _onSwipeUserRetrievedEvent(
      SwipeUserRetrievedEvent event, Emitter<SwipeState> emit) {
    if (state is SwipeLoaded) {
      var s = state as SwipeLoaded;
      emit.call(SwipeLoaded(
        token: event.token,
        users: {...s.users, if (s.userIds.contains(event.user.id)) event.user},
        swipedUsers: {...s.swipedUsers, if (s.swipedUserIds.contains(event.user.id)) event.user},
        userIds: Set.from(s.userIds),
        swipedUserIds: Set.from(s.swipedUserIds),
      ));
    } else if (state is SwipeRetrieved) {
      var s = state as SwipeRetrieved;
      emit.call(SwipeLoaded(
          token: event.token,
          userIds: s.userIds,
          swipedUserIds: s.swipedUserIds,
          users: {
            if (s.userIds.contains(event.user.id)) event.user
          },
          swipedUsers: {
            if (s.swipedUserIds.contains(event.user.id)) event.user
          }));
    }
  }

  void _onSwipeLeftEvent(SwipeLeftEvent event, Emitter<SwipeState> emit) {
    if (state is SwipeLoaded) {
      try {
        var s = state as SwipeLoaded;
        emit.call(SwipeLoaded(
          token: event.token,
          users: Set.from(s.users)..remove(event.user),
          swipedUsers: Set.from(s.swipedUsers)..add(event.user),
          userIds: Set.from(s.userIds)..remove(event.user.id),
          swipedUserIds: Set.from(s.swipedUserIds)..add(event.user.id),
        ));
      } catch (_) {}
      // if ((state as SwipeLoaded).users.length <= 1) {
      //   add(LoadSwipeListEvent(token: event.token));
      // }
    }
    Swipe(event.token, event.user.id, false).then(_onSwipeResult);
  }

  void _onSwipeRightEvent(SwipeRightEvent event, Emitter<SwipeState> emit) {
    if (state is SwipeLoaded) {
      try {
        var s = state as SwipeLoaded;
        emit.call(SwipeLoaded(
          token: event.token,
          users: Set.from(s.users)..remove(event.user),
          swipedUsers: Set.from(s.swipedUsers)..add(event.user),
          userIds: Set.from(s.userIds)..remove(event.user.id),
          swipedUserIds: Set.from(s.swipedUserIds)..add(event.user.id),
        ));
      } catch (_) {}
    }
    Swipe(event.token, event.user.id, true).then(_onSwipeResult);
  }

  void _onSwipeResult(SwipeResult res) {
    if (res.foundMyTable) {
      _winningSwipeSameTableToast();
      meBloc.add(LoadedMe(me: me.copyFrom(score: me.score + 5)));
    }
    if (res.foundNotMyTable) {
      _winningSwipeToast();
      meBloc.add(LoadedMe(me: me.copyFrom(score: me.score + 2)));
    }
    if (res.notFoundMyTable) {
      _losingSwipeSameTableToast();
      meBloc.add(LoadedMe(me: me.copyFrom(score: me.score - 2)));
    }
    if (res.notFoundNotMyTable) {
      _losingSwipeToast();
      meBloc.add(LoadedMe(me: me.copyFrom(score: me.score - 1)));

    }
  }
}

void _winningSwipeToast() {
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

void _winningSwipeSameTableToast() {
  Fluttertoast.showToast(
    msg: "Bien joué il ou elle est bien à ta table ! Tu gagnes 5 points !",
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

void _losingSwipeToast() {
  Fluttertoast.showToast(
    msg: "Pas de chance, c'est raté ! Tu perds 1 point !",
    toastLength: Toast.LENGTH_LONG,
    timeInSecForIosWeb: 2,
    gravity: ToastGravity.TOP,
    webPosition: "center",
    backgroundColor: kWelcomeBackgroundColor,
    webBgColor: "#bf7366",
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void _losingSwipeSameTableToast() {
  Fluttertoast.showToast(
    msg: "C'est raté il ou elle est à ta table ! Tu perds 2 points !",
    toastLength: Toast.LENGTH_LONG,
    timeInSecForIosWeb: 2,
    gravity: ToastGravity.TOP,
    webPosition: "center",
    backgroundColor: kWelcomeBackgroundColor,
    webBgColor: "#bf7366",
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
