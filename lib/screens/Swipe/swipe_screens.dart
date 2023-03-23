import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:woyaa/models/models.dart';
import 'package:woyaa/components/custom_appbar.dart';
import 'package:woyaa/screens/Swipe/components/user_card.dart';

import '../../blocs/swipe/swipe_bloc.dart';
import 'components/choice_button.dart';

class SwipeScreen extends StatelessWidget {
  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => SwipeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: BlocBuilder<SwipeBloc, SwipeState>(
        builder: (context, state) {
          if (state is SwipeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is! SwipeLoaded) {
            return const Text('Something went wrong');
          }
          if (state is SwipeLoaded && state.users.isEmpty) {
            return const Text('No more !');
          }
          return Column(
            children: [
              Draggable(
                  feedback: UserCard(user: state.users[0]),
                  childWhenDragging: state.users.length > 1 ? UserCard(user: state.users[1]) : null,
                  child: UserCard(user: state.users[0]),
                  onDragEnd: (drag) {
                    if (drag.velocity.pixelsPerSecond.dx < 0) {
                      context.read<SwipeBloc>().add(
                          SwipeLeftEvent(user: state.users[0]));
                    } else {
                      context.read<SwipeBloc>().add(
                          SwipeRightEvent(user: state.users[0]));
                    }
                  }
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: ChoiceButton(
                              width: 60,
                              height: 60,
                              size: 25,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .secondary,
                              icon: Icons.clear_rounded),
                        ),
                        InkWell(
                          onTap: () {},
                          child: ChoiceButton(
                              width: 80,
                              height: 80,
                              size: 30,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .secondary,
                              icon: Icons.favorite),
                        ),
                        InkWell(
                          onTap: () {},
                          child: ChoiceButton(
                              width: 60,
                              height: 60,
                              size: 25,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .secondary,
                              icon: Icons.watch_later),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
