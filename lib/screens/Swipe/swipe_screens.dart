import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:woyaa/screens/Swipe/components/user_card.dart';

import '../../blocs/swipe/swipe_bloc.dart';
import '../../components/base.dart';
import 'components/choice_button.dart';

class SwipeScreen extends StatelessWidget {
  static const String routeName = '/';

  const SwipeScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const SwipeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwipeBloc, SwipeState>(
      builder: (context, state) {
        if (state is SwipeLoading) {
          return const Base(child: Center(child: CircularProgressIndicator()));
        }
        if (state is! SwipeLoaded) {
          return const Base(child: Text('Something went wrong'));
        }
        if (state.users.isEmpty) {
          return const Base(child: Text('No more !'));
        }
        return Base(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Spacer(flex: 2),
                Draggable(
                    feedback: UserCard(user: state.users[0]),
                    childWhenDragging: state.users.length > 1
                        ? UserCard(user: state.users[1])
                        : null,
                    child: UserCard(user: state.users[0]),
                    onDragEnd: (drag) {
                      if (drag.velocity.pixelsPerSecond.dx < 0) {
                        context
                            .read<SwipeBloc>()
                            .add(SwipeLeftEvent(user: state.users[0]));
                      } else {
                        context
                            .read<SwipeBloc>()
                            .add(SwipeRightEvent(user: state.users[0]));
                      }
                    }),
                const Spacer(),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      InkWell(
                        onTap: () {},
                        child: const ChoiceButton(
                            width: 90,
                            height: 90,
                            size: 35,
                            color: Colors.white,
                            icon: Icons.clear_rounded),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {},
                        child: const ChoiceButton(
                            width: 90,
                            height: 90,
                            size: 35,
                            color: Colors.white,
                            icon: Icons.favorite),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        );
      },
    );
  }
}
