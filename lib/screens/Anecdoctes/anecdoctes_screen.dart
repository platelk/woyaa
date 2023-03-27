import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:woyaa/blocs/survey/survey_bloc.dart';

import '../../components/base.dart';
import '../../models/user.dart';

class AnecdotesScreen extends StatelessWidget {
  const AnecdotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurveyBloc, SurveyState>(
      builder: (context, state) {
        if (state is SurveyLoading) {
          return const Base(child: Center(child: CircularProgressIndicator()));
        }
        if (state is! SurveyLoaded) {
          return const Base(child: Text('Something went wrong'));
        }
        final question = state.questions[0];
        return Base(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.network(question.image),
                    Text(question.body)
                  ],
                ),
                for (var i = 0; i < question.answers; i++) UserAutoComplete(users: User.users),
              ]
            ),
          ),
        );
      },
    );
  }
}

class UserAutoComplete extends StatelessWidget {
  final List<User> users;

  const UserAutoComplete({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Autocomplete<User>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<User>.empty();
        }
        return users.where((User user) {
          return user.name.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (User selection) {
        debugPrint('You just selected $selection');
      },
    );
  }
}