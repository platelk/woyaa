import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/question.dart';

part 'survey_event.dart';
part 'survey_state.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  SurveyBloc() : super(SurveyLoading()) {
    on<LoadQuestionEvent>(_onSurveyLoaded);
    on<QuestionAnsweredEvent>(_onSurveyAnswered);
  }

  void _onSurveyLoaded(LoadQuestionEvent event, Emitter<SurveyState> emit) {
    emit.call(SurveyLoaded(questions: event.questions));
  }

  void _onSurveyAnswered(QuestionAnsweredEvent event, Emitter<SurveyState> emit) {

  }
}
