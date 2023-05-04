import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:woyaa/api/api.dart';

import '../../constants.dart';
import '../../models/question.dart';
import '../../models/user.dart';
import '../authentication/authentication_bloc.dart';
import '../me/me_bloc.dart';

part 'survey_event.dart';
part 'survey_state.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  AuthenticationBloc authBloc;
  MeBloc meBloc;
  late User me;

  SurveyBloc({required this.authBloc, required this.meBloc}) : super(SurveyLoading()) {
    on<LoadQuestionEvent>(_onSurveyLoaded);
    on<QuestionAnsweredEvent>(_onSurveyAnswered);
    on<LoadingQuestion>(_onSurveyLoading);
    on<QuestionPassedEvent>(_onQuestionPassed);
    on<QuestionAnsweredResultEvent>(_onQuestionAnsweredResult);

    authBloc.stream.listen((state) {
      if (state is LoggedInState) {
        add(LoadingQuestion(token: state.token));
      }
    });
    if (authBloc.state is LoggedInState) {
      add(LoadingQuestion(token: (authBloc.state as LoggedInState).token));
    }
    meBloc.stream.listen((state) {
      if (state is MeLoaded) {
        me = state.me;
      }
    });
    if (meBloc.state is MeLoaded) {
      me = (meBloc.state as MeLoaded).me;
    }
  }

  void _onQuestionPassed(QuestionPassedEvent event, Emitter<SurveyState> emit) {
    if (state is SurveyLoaded) {
      var s = state as SurveyLoaded;
      var questions = List<Question>.from((state as SurveyLoaded).questions);
      var questionIdex = questions.indexWhere((question) => question.id == event.questionID);
      var question = questions.removeAt(questionIdex);
      questions.add(question);
      emit.call(SurveyLoaded(token: s.token, questions: questions));
    }
  }

  void _onSurveyLoading(LoadingQuestion event, Emitter<SurveyState> emit) {
    GetAllQuestions(event.token).then((value) {
      add(LoadQuestionEvent(token: event.token, questions: value));
    });
  }

  void _onSurveyLoaded(LoadQuestionEvent event, Emitter<SurveyState> emit) {
    emit.call(SurveyLoaded(token: event.token, questions: event.questions));
  }

  void _onSurveyAnswered(QuestionAnsweredEvent event, Emitter<SurveyState> emit) {
    if (state is SurveyLoaded) {
      var s = state as SurveyLoaded;
      AnswerQuestion(s.token, event.questionID, event.userID).then((value) {
        if (value.validated) {
          add(QuestionAnsweredResultEvent(questions: List.from(s.questions)..removeWhere((question) => question.id == event.questionID), token: s.token));
          meBloc.add(LoadedMe(token: s.token, me: me.copyFrom(score: me.score + value.validUserIds.length * 2)));
          _winningQuestionToast(value.validUserIds.length);
        } else {
          _losingQuestionToast();
          var questions = List<Question>.from((state as SurveyLoaded).questions);
          var idx = questions.indexWhere((question) => question.id == event.questionID);
          if (idx >= 0) {
            questions[idx].validProposal = value.validUserIds;
            questions[idx].invalidProposal = value.notValidUserIds;
          }
          add(QuestionAnsweredResultEvent(questions: questions, token: s.token));
        }
      });
    }
  }

  void _onQuestionAnsweredResult(QuestionAnsweredResultEvent event, Emitter<SurveyState> emit) {
    emit.call(SurveyLoaded(token: event.token, questions: event.questions));
  }
}


void _winningQuestionToast(int numberOfGuessedPersons) {
  final int numberOfPoints = numberOfGuessedPersons * 2;
  Fluttertoast.showToast(
    msg: "Bravo ! Bien joué, tu gagnes $numberOfPoints points !",
    toastLength: Toast.LENGTH_LONG,
    timeInSecForIosWeb: 2,
    gravity: ToastGravity.TOP,
    webPosition: "center",
    backgroundColor: kTablesBackgroundColor,
    webBgColor: "#2a4368",
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void _losingQuestionToast() {
  Fluttertoast.showToast(
    msg: "Pas de chance, c'est raté ! Essaye encore.",
    toastLength: Toast.LENGTH_LONG,
    timeInSecForIosWeb: 2,
    gravity: ToastGravity.TOP,
    webPosition: "center",
    backgroundColor: kWelcomeBackgroundColor,
    webBgColor: "#bf7366",
    textColor: Colors.white,
    fontSize: 16.0,
  );
}