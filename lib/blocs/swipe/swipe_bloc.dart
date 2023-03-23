import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/user.dart';

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
  }

  void _onSwipeRightEvent(SwipeRightEvent event, Emitter<SwipeState> emit) {
    if (state is SwipeLoaded) {
      try {
        emit.call(SwipeLoaded(users: List.from((state as SwipeLoaded).users)..remove(event.user)));
      } catch (_) {}
    }
  }
}
