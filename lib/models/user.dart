import 'package:equatable/equatable.dart';
import 'package:woyaa/models/room.dart';
import 'package:woyaa/models/table.dart';

class User extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final Room room;
  final Table table;
  final String fullPicture;
  final String roundPicture;

  const User({required this.id, required this.firstName, required this.lastName, required this.email, required this.room, required this.table, required this.fullPicture, required this.roundPicture});

  static User fromDynamic(dynamic data) {
    return User(id: data["id"], firstName: data["first_name"], lastName: data["last_name"], email: data["email"], room: Room(number: data["room"]), table: Table(name: data["wedding_table"]), fullPicture: "/assets${data["full_picture_path"]}", roundPicture: "/assets${data["round_picture_path"]}");
  }

  @override
  List<Object?> get props => [id];

  static List<User> users = [];

  String get name => "$firstName $lastName";
}