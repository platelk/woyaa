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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ChoiceButton(
                    width: 60,
                    height: 60,
                    size: 25,
                    color: Theme.of(context).colorScheme.secondary,
                    icon: Icons.clear_rounded),
                ChoiceButton(
                    width: 60,
                    height: 60,
                    size: 30,
                    color: Theme.of(context).colorScheme.secondary,
                    icon: Icons.favorite),
                ChoiceButton(
                    width: 60,
                    height: 60,
                    size: 25,
                    color: Theme.of(context).colorScheme.secondary,
                    icon: Icons.watch_later),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChoiceButton extends StatelessWidget {
  final double width;
  final double height;
  final double size;
  final Color color;
  final IconData icon;

  const ChoiceButton({
    Key? key,
    required this.width,
    required this.height,
    required this.size,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(50),
            spreadRadius: 4,
            blurRadius: 4,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: Icon(icon, color: color),
    );
  }
}
