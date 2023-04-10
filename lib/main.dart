import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:woyaa/blocs/survey/survey_bloc.dart';
import 'package:woyaa/blocs/swipe/swipe_bloc.dart';
import 'package:woyaa/models/models.dart';
import 'package:woyaa/models/question.dart';
import 'package:woyaa/screens/Login/login_screen.dart';
import 'package:woyaa/screens/Welcome/welcome_screen.dart';
import 'package:woyaa/constants.dart';
import 'package:woyaa/main_theme.dart';
import 'package:woyaa/welcome_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (_) => SwipeBloc()..add(LoadUsersEvent(users: User.users))),
      BlocProvider(create: (_) => SurveyBloc()..add(LoadQuestionEvent(questions: Question.questions))),
    ], child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'W.O.Y.A.A',
      theme: theme(),
      home: const LoginScreen(),
    ));
  }
}
