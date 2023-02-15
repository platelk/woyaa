import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final int age;
  final List<String> imageUrls;
  final String bio;
  final String jobTitle;

  const User(
      {required this.id,
      required this.name,
      required this.age,
      required this.imageUrls,
      required this.bio,
      required this.jobTitle});

  @override
  List<Object?> get props => [id, name, age, imageUrls, bio, jobTitle];

  static List<User> users = [
    User(id: 1, name: "name", age: 29, imageUrls: ["https://bungareestation.com.au/wp-content/uploads/2019/10/Bungaree-Station-Weddings-Garden-Wedding-5.jpg"], bio: "bio", jobTitle: "jobTitle"),
  ];
}