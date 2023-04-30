import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:woyaa/models/models.dart';

import '../../blocs/me/me_bloc.dart';
import '../../blocs/users/user_bloc.dart';
import '../../components/base.dart';
import '../../constants.dart';

class LeaderBoardScreen extends StatelessWidget {
  const LeaderBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Base(
      child: Stack(children: [
        Positioned(top: -100, right: -100, child: SizedBox(width: 300, height: 300, child: Image.asset("images/leaf_2.png", fit: BoxFit.scaleDown))),
        Positioned(bottom: -100, right: -100, child: SizedBox(width: 300, height: 300, child: Image.asset("images/leaf_left_corner.png", fit: BoxFit.scaleDown))),
        Positioned(top: 50, left: -150, child: Container(transformAlignment: Alignment.center,
            transform: Matrix4.rotationZ(
              3.1415926535897932 * 1.8 / 2, // here
            ), child: SizedBox(width: 300, height: 300, child: Image.asset("images/leaf_1.png", fit: BoxFit.scaleDown)))),
        LeaderBoard(),
      ]),
    );
  }
}

class LeaderBoard extends StatelessWidget {
  const LeaderBoard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeBloc, MeState>(
      builder: (context, meState) {
        return BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is! UserInitialized) {
              return const Base(child: Text("loading..."));
            }
            if (meState is! MeLoaded) {
              return const Base(child: Text("loading..."));
            }
            final users = List<User>.from(state.users.values)
              ..sort((a, b) => b.score - a.score);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Gagnerez vous \nle 1er prix ?",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: const Color(0xFF293D84)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    children: [
                      Spacer(),
                      Expanded(
                        flex: 5,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.black),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      const Color(0xFFE8D1C5)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.0),
                                      side: const BorderSide(
                                        color: Color(0xFFE8D1C5),
                                        width: 5,
                                      )))),
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                        NetworkImage(meState.me.roundPicture),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      meState.me.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      "${meState.me.score} points",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        height: 180.0,
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const Divider(
                            color: kPrimaryColor,
                          ),
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            return LeaderBoardItem(
                                highlight: index < 3,
                                user: users[index],
                                index: index,
                                points: users[index].score);
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class LeaderBoardItem extends StatelessWidget {
  final User user;
  final int index;
  final int points;
  final bool highlight;

  const LeaderBoardItem(
      {super.key,
      required this.user,
      required this.index,
      required this.points,
      required this.highlight});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("$index.",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: const Color(0xFF293D84),
                fontWeight: highlight ? FontWeight.bold : FontWeight.normal),
            textAlign: TextAlign.center),
        Expanded(
            child: Text(
          user.name,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: const Color(0xFF293D84),
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal),
          textAlign: TextAlign.center,
        )),
        Text("$points points",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: const Color(0xFF293D84),
                fontWeight: highlight ? FontWeight.bold : FontWeight.normal),
            textAlign: TextAlign.center),
      ],
    );
  }
}
