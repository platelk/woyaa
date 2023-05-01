import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final int id;
  final String question;
  final List<String> images;
  final int answers;
  List<int> validProposal = [];
  List<int> invalidProposal = [];

  Question({
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
}

class QuestionAnswerResult {
  final int id;
  final bool validated;
  final List<int> validUserIds;
  final List<int> notValidUserIds;

  QuestionAnswerResult({required this.id, required this.validated, required this.validUserIds, required this.notValidUserIds});

  static QuestionAnswerResult fromDynamic(dynamic data) {
    return QuestionAnswerResult(id: data["question_id"], validated: data["validated"], validUserIds: List.from((data["valid_user_ids"] as List<dynamic>).map((e) => e as int)), notValidUserIds: List.from((data["not_valid_user_ids"] as List<dynamic>).map((e) => e as int)));
  }
}