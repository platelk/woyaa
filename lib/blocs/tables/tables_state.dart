part of 'tables_bloc.dart';

abstract class TablesState extends Equatable {
  const TablesState();
  @override
  List<Object> get props => [];
}

class TablesInitial extends TablesState {
  final Set<User> users;
  const TablesInitial({required this.users});

  @override
  List<Object> get props => [users];
}

class TablesInitialized extends TablesState {
  final String token;
  final Map<String, Table> tables;

  const TablesInitialized({required this.token, required this.tables});

  @override
  List<Object> get props => [token, tables];
}
