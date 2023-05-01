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

  static Question fromDynamic(dynamic data) {
    List<String> images = [];
    if (data["is_yoann"]) {
      images.add("/assets/photos/photo_ronde/Yoann.png");
    }
    if (data["is_ana"]) {
      images.add("/assets/photos/photo_ronde/Ana.png");
    }
    return Question(id: data["question_id"], images: images, question: data["question"], answers: data["nb_answers"]);
  }

  @override
  List<Object?> get props => [id,  images, question, answers];

  static List<Question> questions = [
    const Question(
        id: 0,
        images: ["/photos/photo_ronde/Kevin.png"],
        question: "Avec qui Yoann est parti aux Etats-Unis pendant son année à l'étranger ?",
        answers: 3,
    ),
    const Question(
      id: 1,
      images: ["/photos/photo_ronde/Kevin.png"],
      question: "Avec qui Yoann s'est trompé d'aéroport au moment de prendre un vol ?",
      answers: 1,
    ),
  ];
}
