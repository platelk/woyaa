import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:woyaa/api/api.dart';

import '../../models/question.dart';
import '../authentication/authentication_bloc.dart';

part 'survey_event.dart';
part 'survey_state.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  AuthenticationBloc authBloc;

  SurveyBloc({required this.authBloc}) : super(SurveyLoading()) {
    on<LoadQuestionEvent>(_onSurveyLoaded);
    on<QuestionAnsweredEvent>(_onSurveyAnswered);
    on<LoadingQuestion>(_onSurveyLoading);
    on<QuestionPassedEvent>(_onQuestionPassed);

    authBloc.stream.listen((state) {
      if (state is LoggedInState) {
        add(LoadingQuestion(token: state.token));
      }
    });
    if (authBloc.state is LoggedInState) {
      add(LoadingQuestion(token: (authBloc.state as LoggedInState).token));
    }
  }

  void _onQuestionPassed(QuestionPassedEvent event, Emitter<SurveyState> emit) {
    if (state is SurveyLoaded) {
      var questions = List<Question>.from((state as SurveyLoaded).questions);
      var questionIdex = questions.indexWhere((question) => question.id == event.questionID);
      var question = questions.removeAt(questionIdex);
      questions.add(question);
      emit.call(SurveyLoaded(questions: questions));
    }
  }

  void _onSurveyLoading(LoadingQuestion event, Emitter<SurveyState> emit) {
    GetAllQuestions(event.token).then((value) {
      add(LoadQuestionEvent(token: event.token, questions: value));
    });
  }

  void _onSurveyLoaded(LoadQuestionEvent event, Emitter<SurveyState> emit) {
    emit.call(SurveyLoaded(questions: event.questions));
  }

  void _onSurveyAnswered(QuestionAnsweredEvent event, Emitter<SurveyState> emit) {
    if (state is SurveyLoaded) {
      print((state as SurveyLoaded).questions);
      emit.call(SurveyLoaded(questions: List.from((state as SurveyLoaded).questions)..removeWhere((question) => question.id == event.questionID)));
    }
  }
}
