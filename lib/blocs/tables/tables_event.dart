part of 'tables_bloc.dart';

abstract class TablesEvent extends Equatable {
  const TablesEvent();

  @override
  List<Object> get props => [];
}

class LoadingTableEvent extends TablesEvent {
  final String token;

  const LoadingTableEvent({required this.token});

  @override
  List<Object> get props => [token];
}

class TableLoadedEvent extends TablesEvent {
  final String token;
  final Map<String, Table> tables;

  const TableLoadedEvent({required this.token, required this.tables});

  @override
  List<Object> get props => [token, tables];
}

class UserInTableEvent extends TablesEvent {
  final String token;
  final User user;

  const UserInTableEvent({required this.token, required this.user});

  @override
  List<Object> get props => [token, user];
}