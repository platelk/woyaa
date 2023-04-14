import 'package:flutter/material.dart';
import 'package:woyaa/components/custom_appbar.dart';
import 'package:woyaa/models/models.dart';
import 'package:woyaa/screens/Swipe/components/user_card.dart';
import 'package:woyaa/welcome_theme.dart';
import 'dart:async';
import 'dart:html' as html;
import '../../components/base.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = User.users[0];
    return Theme(
      data: welcomeTheme(),
      child: Base(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Spacer(),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.imageUrls[0]),
                    minRadius: 120,
                  )
                ]),
                // Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [Text(user.name, style: Theme.of(context).textTheme.displaySmall)]),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    LabeledNumber(number: 234, label: "chambre"),
                    LabeledNumber(number: 178, label: "jours avant le mariage"),
                    LabeledNumber(number: 59, label: "classement"),
                  ],
                ),
                const Spacer(flex: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Samedi 20 mai 2023 a 14h",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Château du Bois-Guy",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Parigné, Bretagne",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    const Spacer(),
                    Expanded(
                      flex: 5,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.black),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(const Color(0xFFE8D1C5)),
                              shape:
                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(40.0),
                                          side:
                                              const BorderSide(color: Color(0xFFE8D1C5))))),
                          onPressed: _openGiftslist,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Icon(
                                    Icons.card_giftcard_rounded,
                                    color: Colors.black,
                                    size: 50.0,
                                    semanticLabel:
                                        'Text to announce in accessibility modes',
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text("Faites nous plaisir",
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                                    Text("Accéder à notre liste",
                                      style: Theme.of(context).textTheme.bodyMedium!, textAlign: TextAlign.left,),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Ana 06.52.32.23.27",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.left,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("anaxyoann@gmail.com",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.left,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Yoann 06.09.51.46.28",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.left,),
                  ],
                ),
                const Spacer(),
              ],
            )),
      ),
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
        Text("$number",
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: const Color(0xFFE8D1C5))),
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: const Color(0xFFE8D1C5))),
      ],
    );
  }
}

_openGiftslist() {
    const u = 'https://www.milleetunelistes.fr/liste/mariage-ana-et-yoann';
    html.window.open(u, 'new tab');
  }
