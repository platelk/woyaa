import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final int id;
  final String question;
  final List<String> images;
  final int answers;

  const Question({
    required this.id,
    required this.images,
    required this.question,
    required this.answers
  });

  @override
  List<Object?> get props => [id,  images, question, answers];

  static List<Question> questions = [
    const Question(
        id: 0,
        images: [""],
        question: "Avec qui Yoann est parti aux Etats-Unis pendant son année à l'étranger ?",
        answers: 5,
    ),
    const Question(
      id: 1,
      images: [""],
      question: "Avec qui Yoann s'est trompé d'aéroport au moment de prendre un vol ?",
      answers: 1,
    ),
  ];
}
