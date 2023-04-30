import 'package:woyaa/models/user.dart';

class Table {
  final String name;
  final int size;
  Set<User> users = {};

  Table({required this.name, required this.size});

  static Table fromDynamic(dynamic data) {
    return Table(name: data["name"], size: data["total"]);
  }
}