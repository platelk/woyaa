import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final int id;
  final String title;
  final String body;
  final String image;
  final int answers;

  const Question({
    required this.id,
    required this.image,
    required this.title,
    required this.body,
    required this.answers
  });

  @override
  List<Object?> get props => [id, title, image, body, answers];

  static List<Question> questions = [
    const Question(
        id: 0,
        image: "",
        title: "Yoann a Epitech",
        body: "Quelle est le pseudo donner a Yoann par les personnes d'epitech",
        answers: 2,
    ),
    const Question(
      id: 1,
      image: "",
      title: "Ana",
      body: "Quelle est la nationnalite d'origine d'Ana",
      answers: 1,
    ),
  ];
}
