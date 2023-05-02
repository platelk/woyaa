part of 'me_bloc.dart';

abstract class MeState extends Equatable {
  const MeState();

  @override
  List<Object> get props => [];
}

class MeInitial extends MeState {
}

class MeLoading extends MeState {
  final String token;

  const MeLoading({required this.token});

  @override
  List<Object> get props => [token];
}

class MeLoaded extends MeState {
  final User me;

  const MeLoaded({required this.me});

  @override
  List<Object> get props => [me, me.score];
}