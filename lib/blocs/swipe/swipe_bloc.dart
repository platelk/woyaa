import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';

import '../../models/user.dart';
import '../../../constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


part 'swipe_event.dart';

part 'swipe_state.dart';

class SwipeBloc extends Bloc<SwipeEvent, SwipeState> {
  SwipeBloc() : super(SwipeLoading()) {
    on<LoadUsersEvent>(_onLoadUsersEvent);
    on<SwipeLeftEvent>(_onSwipeLeftEvent);
    on<SwipeRightEvent>(_onSwipeRightEvent);
  }

  void _onLoadUsersEvent(LoadUsersEvent event, Emitter<SwipeState> emit) {
    emit.call(SwipeLoaded(users: event.users));
  }

  void _onSwipeLeftEvent(SwipeLeftEvent event, Emitter<SwipeState> emit) {
    if (state is SwipeLoaded) {
      try {
        emit.call(SwipeLoaded(users: List.from((state as SwipeLoaded).users)..remove(event.user)));
      } catch (_) {}
    }
    _losingSwipeToast();
  }

  void _onSwipeRightEvent(SwipeRightEvent event, Emitter<SwipeState> emit) {
    if (state is SwipeLoaded) {
      try {
        emit.call(SwipeLoaded(users: List.from((state as SwipeLoaded).users)..remove(event.user)));
      } catch (_) {}
    }
    _winningSwipeToast();
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

void _losingSwipeToast(){
  Fluttertoast.showToast(
    msg: "Pas chance, c'est raté ! Tu perds 1 point !",
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

/*
 FToast fToast;

 @override
 void initState(){
  super.initState();
  fToast = FToast();
  fToast.init(navigatorKey.current); //je veux récupérer un context
 }
*/
