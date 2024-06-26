part of 'me_bloc.dart';

abstract class MeEvent extends Equatable {
  const MeEvent();

  @override
  List<Object> get props => [];
}

class LoadingMe extends MeEvent {
  final String token;

  const LoadingMe({required this.token});
}

class LoadedMe extends MeEvent {
  final String token;
  final User me;

  const LoadedMe({required this.me, required this.token});

  @override
  List<Object> get props => [me, me.score];
}