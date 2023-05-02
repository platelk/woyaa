import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:woyaa/blocs/authentication/authentication_bloc.dart';
import 'package:woyaa/blocs/me/me_bloc.dart';
import 'package:woyaa/blocs/survey/survey_bloc.dart';
import 'package:woyaa/blocs/swipe/swipe_bloc.dart';
import 'package:woyaa/blocs/users/user_bloc.dart';
import 'package:woyaa/main_theme.dart';
import 'package:woyaa/models/question.dart';
import 'package:woyaa/screens/Login/login_screen.dart';

import 'api/api.dart';
import 'blocs/tables/tables_bloc.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    configureDio();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthenticationBloc()),
          BlocProvider(
              create: (context) => MeBloc(
                  authBloc: BlocProvider.of<AuthenticationBloc>(context))),
          BlocProvider(
              create: (context) => UserBloc(
                  authBloc: BlocProvider.of<AuthenticationBloc>(context))),
          BlocProvider(
              create: (context) => SurveyBloc(
                authBloc: BlocProvider.of<AuthenticationBloc>(context),
                meBloc: BlocProvider.of<MeBloc>(context),
              )),
          BlocProvider(
              create: (context) => SwipeBloc(
                  authBloc: BlocProvider.of<AuthenticationBloc>(context),
                  userBloc: BlocProvider.of<UserBloc>(context),
                  meBloc: BlocProvider.of<MeBloc>(context),
              )),
          BlocProvider(
              create: (context) => TablesBloc(
                  authBloc: BlocProvider.of<AuthenticationBloc>(context),
                  userBloc: BlocProvider.of<UserBloc>(context)))
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ana x Yoann',
          theme: theme(),
          home: const LoginScreen(),
        ));
  }
}
