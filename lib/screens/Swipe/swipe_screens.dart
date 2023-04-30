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
          return noMoreImage(context);
          /*Base(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              
              Image.asset("images/swipe_no_more.png"),
            ));*/
        }
        return Base(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, left: 16.0, right: 16.0, bottom: 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Pensez vous être\nà table avec ..?",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                    color: const Color(0xFFBF7366),
                                    height: 1.8,
                                    fontFamily: 'Adelia')),
                      ]),
                ),
                Draggable(
                    feedback: UserCard(user: state.users.first),
                    childWhenDragging: state.users.length > 1
                        ? UserCard(user: state.users.elementAt(1))
                        : null,
                    child: UserCard(user: state.users.first),
                    onDragEnd: (drag) {
                      if (drag.velocity.pixelsPerSecond.dx < 0) {
                        context
                            .read<SwipeBloc>()
                            .add(SwipeLeftEvent(token: state.token, user: state.users.first));
                      } else {
                        context
                            .read<SwipeBloc>()
                            .add(SwipeRightEvent(token: state.token, user: state.users.first));
                      }
                    }),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(
                        flex: 2,
                      ),
                      InkWell(
                        onTap: () {
                          context
                            .read<SwipeBloc>()
                            .add(SwipeLeftEvent(token: state.token, user: state.users.first));
                        },
                        child: const ChoiceButton(
                            width: 80,
                            height: 80,
                            size: 50,
                            color: Colors.white,
                            icon: "images/pouce2.png"),
                      ),
                      const Spacer(),
                      InkWell(
                        highlightColor: Colors.black,
                        onTap: () {
                          context
                            .read<SwipeBloc>()
                            .add(SwipeRightEvent(token: state.token, user: state.users.first));
                        },
                        child: const ChoiceButton(
                            width: 80,
                            height: 80,
                            size: 50,
                            color: Colors.red,
                            icon: "images/pouce1.png"),
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget noMoreImage(BuildContext context) {
  return Base(
      child: Padding(
      padding: const EdgeInsets.only(
        top: 24.0, left: 16.0, right: 16.0, bottom: 8.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Text("Pensez vous être\nà table avec ..?",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: const Color(0xFFBF7366),
              height: 1.8,
              fontFamily: 'Adelia')),
      SizedBox(
        height: MediaQuery.of(context).size.height - 320,
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                image: const DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage("images/swipe_no_more.png"),
                ),
              ),
            ),
          ),
        ]),
      )
    ]),
  ));
}
