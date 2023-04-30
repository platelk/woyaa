import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:woyaa/blocs/survey/survey_bloc.dart';
import 'package:woyaa/models/question.dart';

import '../../blocs/users/user_bloc.dart';
import '../../components/base.dart';
import '../../constants.dart';
import '../../models/user.dart';

class AnecdotesScreen extends StatelessWidget {
  const AnecdotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        return BlocBuilder<SurveyBloc, SurveyState>(
          builder: (context, state) {
            if (state is SurveyLoading || userState is! UserInitialized) {
              return const Base(
                  child: Center(child: CircularProgressIndicator()));
            }
            if (state is! SurveyLoaded) {
              return const Base(child: Text('Something went wrong'));
            }
            final question = state.questions.first;
            return Base(
              child: Stack(
                children: [
                  Positioned(
                      top: -100,
                      right: -100,
                      child: SizedBox(
                          width: 300,
                          height: 300,
                          child: Image.asset("images/leaf_2.png",
                              fit: BoxFit.scaleDown))),
                  Positioned(
                      bottom: -100,
                      right: -100,
                      child: SizedBox(
                          width: 300,
                          height: 300,
                          child: Image.asset("images/leaf_left_corner.png",
                              fit: BoxFit.scaleDown))),
                  Positioned(
                      top: 50,
                      left: -150,
                      child: Container(
                          transformAlignment: Alignment.center,
                          transform: Matrix4.rotationZ(
                            3.1415926535897932 * 1.8 / 2, // here
                          ),
                          child: SizedBox(
                              width: 300,
                              height: 300,
                              child: Image.asset("images/leaf_1.png",
                                  fit: BoxFit.scaleDown)))),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Spacer(),
                            for (var image in question.images)
                              CircleAvatar(
                                radius: 35,
                                backgroundImage: NetworkImage(image),
                              ),
                            Spacer(),
                          ],
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: kPrimaryColor, width: 2),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(question.question,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(color: const Color(0xFF293D84)),
                                textAlign: TextAlign.center),
                          )),
                      Expanded(
                        child: SingleChildScrollView(child: AnswersForm(key: Key(question.question), question: question, users: userState.users.values.toList())),
                      ),
                    ]),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class AnswersForm extends StatefulWidget {
  final List<User> users;

  const AnswersForm({
    super.key,
    required this.question,
    required this.users,
  });

  final Question question;

  @override
  State<AnswersForm> createState() => _AnswersFormState();
}

class _AnswersFormState extends State<AnswersForm> {
  bool isDisable = true;
  final _formKey = GlobalKey<FormState>();
  late List<UserAutoComplete> autoCompleteField;
  late List<GlobalKey<_UserAutoCompleteState>> values;

  @override
  void initState() {
    super.initState();
    values = [
      for (var i = 0; i < widget.question.answers; i++)
        GlobalKey<_UserAutoCompleteState>()
    ];
    autoCompleteField = [for (var key in values)
      UserAutoComplete(users: widget.users, key: key, formKey: _formKey, onChanged: onChange,)];
  }

  void onChange() {
      final areDefined = values.every((element) => element.currentState?.selectUser?.name.isNotEmpty ?? false);
      if (areDefined == isDisable) {
        setState(() {
          isDisable = !areDefined;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        if (userState is! UserInitialized) {
          return const Base(child: Center(child: CircularProgressIndicator()));
        }
        return Form(
            key: _formKey,
            onChanged: onChange,
            child: Column(
              children: [
                ...autoCompleteField,
                Row(
                  children: [
                    const Spacer(),
                    ElevatedButton(
                      onPressed: isDisable ? null : () {
                        // Validate returns true if the form is valid, or false otherwise.
                          for (var k in values) {
                            print("=> ${k.currentState?.selectUser?.name}");
                          }
                          context
                              .read<SurveyBloc>()
                              .add(QuestionAnsweredEvent(questionID: 0, answerID: 0, userID: []));
                      },
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: isDisable ? const Color(0xFFE8D1C5) : kTablesBackgroundColor,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          shape:
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(
                                          color: isDisable ? kTablesBackgroundColor : const Color(0xFFE8D1C5)))),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Valider la reponse",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ));
      },
    );
  }
}

class UserAutoComplete extends StatefulWidget {
  final List<User> users;
  final GlobalKey<FormState> formKey;
  final Function onChanged;

  const UserAutoComplete({super.key, required this.users, required this.formKey, required this.onChanged});

  @override
  State<UserAutoComplete> createState() => _UserAutoCompleteState();
}

class _UserAutoCompleteState extends State<UserAutoComplete> {
  User? selectUser;
  late Autocomplete<User> autocompleteField;

  @override
  void initState() {
    print("init state user auto complete");
    super.initState();
    autocompleteField = Autocomplete<User>(
      initialValue: TextEditingValue(text: selectUser?.name ?? ""),
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            validator: (value) {
              return null;
            },
            onChanged: (value) {
              print("on change");
              if (value != selectUser?.name) {
                setState(() {
                  selectUser = null;
                });
              }
            },
            onTap: () {
              print("on Tap user auto complete");
              widget.onChanged();
            },
            decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFF9F9F9),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.black38))),
            controller: fieldTextEditingController,
            focusNode: fieldFocusNode,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
      displayStringForOption: (option) => option.name,
      optionsBuilder: (TextEditingValue textEditingValue) {
        print("on option builder");
        if (textEditingValue.text == '') {
          print("on option builder > no option");
          return const Iterable<User>.empty();
        }
        print("on option builder > users");
        return widget.users.where((User user) {
          return user.name
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (User selection) {
        debugPrint('You just selected $selection');
        selectUser = selection;
        widget.onChanged();
        print("on selected");
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<User> onSelected, Iterable<User> options) {
        print("on option View Builder");
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            child: Container(
              width: min(300, MediaQuery.of(context).size.width),
              height: max(50.0 * options.length, MediaQuery.of(context).size.height),
              color: const Color(0xFFF7F3F0),
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(5.0),
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  print("on itemBuilder listView");
                  final User option = options.elementAt(index);

                  return GestureDetector(
                    onTap: () {
                      print("on Tap gesture detector");
                      onSelected(option);
                      print("on Tap selected gesture detector");
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(option.roundPicture),
                          ),
                          Expanded(
                            child: Text(
                              option.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: kTablesBackgroundColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("build auto complele");
    return autocompleteField;
  }
}
