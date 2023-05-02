import 'package:equatable/equatable.dart';
import 'package:woyaa/models/room.dart';
import 'package:woyaa/models/table.dart';

class User extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final int score;
  final Room room;
  final String tableName;
  final String team;
  final String fullPicture;
  final String roundPicture;

  const User({required this.id, required this.firstName, required this.lastName, required this.email, required this.score, required this.room, required this.tableName, required this.fullPicture, required this.roundPicture, required this.team});

   User copyFrom({int? id, String? firstName, String? lastName, String? email, int? score, Room? room, String? tableName, String? fullPicture, String? roundPicture, String? team}) {
     final user = User(
         id: id ?? this.id,
         firstName: firstName ?? this.firstName,
         lastName: lastName ?? this.lastName,
         email: email ?? this.email,
         score: score ?? this.score,
         room: room ?? this.room,
         tableName: tableName ?? this.tableName,
         fullPicture: fullPicture ?? this.fullPicture,
         roundPicture: roundPicture ?? this.roundPicture,
         team: team ?? this.team,
     );
     print("avant: ${this.score}, apres ${user.score}");
     return user;
   }


  static User fromDynamic(dynamic data) {
    return User(id: data["id"],team: "N/A", firstName: data["first_name"], lastName: data["last_name"], email: data["email"], score: data["score"], room: Room(number: data["room"]), tableName: data["wedding_table"], fullPicture: "/assets${data["full_picture_path"]}", roundPicture: "/assets${data["round_picture_path"]}");
  }

  static User get unknown {
    return const User(id: 0, team: "N/A", firstName: "Mystère", lastName: "", email: "", score: 0, room: Room(number: -1), tableName: "", fullPicture: "", roundPicture: "/assests/photos/photo_ronde/Unknown.png");
  }



  @override
  List<Object?> get props => [id];

  static List<User> users = [];

  String get name => "$firstName $lastName";

  @override
  String toString() {
    return name;
  }
}