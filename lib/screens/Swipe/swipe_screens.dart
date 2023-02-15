import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:woyaa/models/models.dart';
import 'package:woyaa/screens/Swipe/components/custom_appbar.dart';
import 'package:woyaa/screens/Swipe/components/user_card.dart';

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
      body: Column(
        children: [
          UserCard(user: User.users[0]),
          ChoiceButton(),
        ],
      ),
    );
  }
}

class ChoiceButton extends StatelessWidget {
  const ChoiceButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}