import 'package:flutter/material.dart';
import 'package:woyaa/components/custom_appbar.dart';
import 'package:woyaa/models/models.dart';
import 'package:woyaa/screens/Swipe/components/user_card.dart';

import '../../components/base.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = User.users[0];
    return Base(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Spacer(),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.imageUrls[0]),
                  minRadius: 120,
                )
              ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(user.name, style: Theme.of(context).textTheme.displaySmall)]),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  LabeledNumber(number: 234, label: "chambre"),
                  LabeledNumber(number: 178, label: "jours avant le mariage"),
                  LabeledNumber(number: 59, label: "classement"),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                Text("20 mai 2023, 15h00"),
              ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Chateau du Bois-Guy"),
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Parigne, Bretagne"),
                ],),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Ana 06.52.32.23.27"),
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Yoann 06.09.51.46.28"),
                ],),
              const Spacer(),
            ],

          )),
    );
  }
}

class LabeledNumber extends StatelessWidget {
  final int number;
  final String label;
  const LabeledNumber({super.key, required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("$number"),
        Text(label),
      ],
    );
  }

}