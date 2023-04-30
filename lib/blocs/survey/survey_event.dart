part of 'survey_bloc.dart';

abstract class SurveyEvent extends Equatable {
  const SurveyEvent();

  @override
  List<Object> get props => [];
}

class LoadQuestionEvent extends SurveyEvent {
  final List<Question> questions;

  const LoadQuestionEvent({required this.questions});

  @override
  List<Object> get props => [questions];
}

class QuestionAnsweredEvent extends SurveyEvent {
  final int questionID;
  final int answerID;
  final List<int> userID;

  const QuestionAnsweredEvent({required this.questionID, required this.answerID, required this.userID});

  @override
  List<Object> get props => [questionID, answerID, userID];
}