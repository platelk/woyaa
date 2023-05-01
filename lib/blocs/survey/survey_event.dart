part of 'survey_bloc.dart';

abstract class SurveyEvent extends Equatable {
  const SurveyEvent();

  @override
  List<Object> get props => [];
}

class LoadingQuestion extends SurveyEvent {
  final String token;

  const LoadingQuestion({required this.token});

  @override
  List<Object> get props => [token];
}

class LoadQuestionEvent extends SurveyEvent {
  final String token;
  final List<Question> questions;

  const LoadQuestionEvent({required this.token, required this.questions});

  @override
  List<Object> get props => [token, questions];
}

class QuestionPassedEvent extends SurveyEvent {
  final int questionID;

  const QuestionPassedEvent({required this.questionID});

  @override
  List<Object> get props => [questionID];
}

class QuestionAnsweredEvent extends SurveyEvent {
  final int questionID;
  final int answerID;
  final List<int> userID;

  const QuestionAnsweredEvent({required this.questionID, required this.answerID, required this.userID});

  @override
  List<Object> get props => [questionID, answerID, userID];
}