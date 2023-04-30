import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:woyaa/blocs/survey/survey_bloc.dart';

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
                  Positioned(top: -100, right: -100, child: SizedBox(width: 300, height: 300, child: Image.asset("images/leaf_2.png", fit: BoxFit.scaleDown))),
                  Positioned(bottom: -100, right: -100, child: SizedBox(width: 300, height: 300, child: Image.asset("images/leaf_left_corner.png", fit: BoxFit.scaleDown))),
                  Positioned(top: 50, left: -150, child: Container(transformAlignment: Alignment.center,
                      transform: Matrix4.rotationZ(
                        3.1415926535897932 * 1.8 / 2, // here
                      ), child: SizedBox(width: 300, height: 300, child: Image.asset("images/leaf_1.png", fit: BoxFit.scaleDown)))),
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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                            decoration:
                            BoxDecoration(color: Colors.white, border: Border.all(color: kPrimaryColor, width: 2), borderRadius: BorderRadius.circular(10.0),),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(question.question,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(color: const Color(0xFF293D84)),
                                  textAlign: TextAlign.center),
                            )),
                      ),
                      for (var i = 0; i < question.answers; i++) UserAutoComplete(
                          users: userState.users.values.toList()),
                      Spacer(),
                      Row(
                        children: [
                          Spacer(),
                          ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                                foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                                backgroundColor:
                                MaterialStateProperty.all<Color>(Color(0xFFE8D1C5)),
                                shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        side:
                                        const BorderSide(color: Color(0xFFE8D1C5))))),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                "Valider la reponse",
                                style:  Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
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

class UserAutoComplete extends StatelessWidget {
  final List<User> users;

  const UserAutoComplete({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Autocomplete<User>(
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        return
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(filled: true, fillColor: Color(0xFFF9F9F9), enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.black38))),
                controller: fieldTextEditingController,
                focusNode: fieldFocusNode,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
      },
      displayStringForOption: (option) => option.name,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<User>.empty();
        }
        return users.where((User user) {
          return user.name
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (User selection) {
        debugPrint('You just selected $selection');
      },
      optionsViewBuilder: (
          BuildContext context,
          AutocompleteOnSelected<User> onSelected,
          Iterable<User> options
          )  {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            child: Container(
              width: 300,
              height: 50.0 * options.length,
              color: Color(0xFFF7F3F0),
              child: ListView.builder(
                padding: const EdgeInsets.all(10.0),
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
                            child: Text(option.name, style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold, color: kTablesBackgroundColor), textAlign: TextAlign.center,),
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
}
