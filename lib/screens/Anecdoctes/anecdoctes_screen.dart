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
            if (state.questions.isEmpty) {
              return const Base(child: Text('No More !'));
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
                  CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 1.5,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    for (var image in question.images)
                                      CircleAvatar(
                                        radius: 35,
                                        backgroundImage: NetworkImage(image),
                                      ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: kPrimaryColor, width: 2),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(question.question,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                color: const Color(0xFF293D84)),
                                        textAlign: TextAlign.center),
                                  )),
                              const Padding(padding: EdgeInsets.all(12.0)),
                              AnswersForm(
                                  key: Key(question.question),
                                  question: question,
                                  users: userState.users.values.toList()),
                            ]),
                          ),
                        ),
                      ),
                    ],
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
  late List<UserAutoComplete> autoCompleteField;
  late List<GlobalKey<_UserAutoCompleteState>> values;

  @override
  void initState() {
    super.initState();
    values = [
      for (var i = 0; i < widget.question.answers; i++)
        GlobalKey<_UserAutoCompleteState>()
    ];
    autoCompleteField = [
      for (var key in values)
        UserAutoComplete(
          users: widget.users,
          key: key,
          onChanged: onChange,
        )
    ];
  }

  void onChange() {
    final areDefined = values.every((element) =>
        element.currentState?.selectUser?.name.isNotEmpty ?? false);
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
            onChanged: onChange,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...autoCompleteField,
                Padding(
                  padding: const EdgeInsets.only(top :8.0),
                  child: Row(
                    children: [
                      PassButton(widget: widget),
                      const Spacer(),
                      ValidateButton(
                          isDisable: isDisable, widget: widget, values: values),
                    ],
                  ),
                ),
              ],
            ));
      },
    );
  }
}

class PassButton extends StatelessWidget {
  const PassButton({
    super.key,
    required this.widget,
  });

  final AnswersForm widget;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Validate returns true if the form is valid, or false otherwise.
        context
            .read<SurveyBloc>()
            .add(QuestionPassedEvent(questionID: widget.question.id));
      },
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFFE8D1C5),
          textStyle: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: kTablesBackgroundColor))),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          "Passer",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ValidateButton extends StatelessWidget {
  const ValidateButton({
    super.key,
    required this.isDisable,
    required this.widget,
    required this.values,
  });

  final bool isDisable;
  final AnswersForm widget;
  final List<GlobalKey<_UserAutoCompleteState>> values;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisable
          ? null
          : () {
              // Validate returns true if the form is valid, or false otherwise.
              context.read<SurveyBloc>().add(QuestionAnsweredEvent(
                      questionID: widget.question.id,
                      answerID: 0,
                      userID: [
                        for (var k in values) k.currentState!.selectUser!.id
                      ]));
            },
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor:
              isDisable ? const Color(0xFFE8D1C5) : kTrombiBackgroundColor,
          textStyle: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(
                  color: isDisable
                      ? kTrombiBackgroundColor
                      : const Color(0xFFE8D1C5)))),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          "Valider la réponse",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class UserAutoComplete extends StatefulWidget {
  final List<User> users;
  final Function onChanged;

  const UserAutoComplete(
      {super.key, required this.users, required this.onChanged});

  @override
  State<UserAutoComplete> createState() => _UserAutoCompleteState();
}

class _UserAutoCompleteState extends State<UserAutoComplete> {
  User? selectUser;
  late Autocomplete<User> autocompleteField;
  var selected = false;

  @override
  void initState() {
    super.initState();
    autocompleteField = Autocomplete<User>(
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        var field = Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: TextFormField(
            validator: (value) {
              return null;
            },
            onChanged: (value) {
              if (value != selectUser?.name) {
                setState(() {
                  selectUser = null;
                });
              }
            },
            onTap: () {
              setState(() {
                selected = true;
              });
            },
            onTapOutside: (_) {
              setState(() {
                selected = false;
              });
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
        return field;
      },
      displayStringForOption: (option) => option.name,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return widget.users;
        }
        return widget.users.where((User user) {
          return user.name
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (User selection) {
        selectUser = selection;
        widget.onChanged();
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<User> onSelected, Iterable<User> options) {
        if (options.isEmpty) {
          return Text("no");
        }
        return Align(
          alignment: Alignment.topLeft,
          child:
              AutoCompleteSuggestion(onSelected: onSelected, options: options),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return autocompleteField;
  }
}

class AutoCompleteSuggestion extends StatelessWidget {
  AutocompleteOnSelected<User> onSelected;
  Iterable<User> options;

  AutoCompleteSuggestion(
      {super.key, required this.onSelected, required this.options});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: min(500, MediaQuery.of(context).size.width),
        height: max(50.0 * options.length, MediaQuery.of(context).size.height),
        color: const Color(0xFFF7F3F0),
        child: ListView.builder(
          padding: const EdgeInsets.all(5.0),
          shrinkWrap: true,
          itemCount: options.length,
          itemBuilder: (BuildContext context, int index) {
            final User option = options.elementAt(index);

            return GestureDetector(
              onTap: () {
                onSelected(option);
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
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
    );
  }
}
