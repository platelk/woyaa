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
    const User(id: 1, name: "PLATEL Kevin", age: 29, imageUrls: ["assets/images/profiles/profile_pic_kevin.jpg"], bio: "bio", jobTitle: "jobTitle"),
    const User(id: 2, name: "Zulgar", age: 31, imageUrls: ["assets/images/profiles/profile_pic_zulgar.jpg"], bio: "bio", jobTitle: "jobTitle"),
  ];
}