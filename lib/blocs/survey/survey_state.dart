part of 'survey_bloc.dart';

abstract class SurveyState extends Equatable {
  const SurveyState();

  @override
  List<Object> get props => [];
}

class SurveyLoading extends SurveyState {}

class SurveyLoaded extends SurveyState {
  final String token;
  final List<Question> questions;

  const SurveyLoaded({required this.questions, required this.token});

  @override
  List<Object> get props => [questions];
}

class SurveyError extends SurveyState {}