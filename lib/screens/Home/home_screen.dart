import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:woyaa/models/models.dart';
import 'package:woyaa/welcome_theme.dart';
import 'dart:html' as html;
import '../../blocs/me/me_bloc.dart';
import '../../components/base.dart';
import '../../models/room.dart';
import '../../models/table.dart' as wTable;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeBloc, MeState>(
  builder: (context, state) {
    var user = const User(id: 0, firstName: "firstName", lastName: "lastName", email: "email", score: 0, room: Room(number: 0), tableName: "", fullPicture: "fullPicture", roundPicture: "roundPicture");
    if (state is MeLoaded) {
      user = state.me;
    } else {
      return Theme(data: welcomeTheme(), child: const Text("loading..."));
    }
    return Theme(
      data: welcomeTheme(),
      child: Base(
        child: Stack(
          children: [
            Positioned(bottom: -100, right: -100, child: SizedBox(width: 300, height: 300, child: Image.asset("images/leaf_left_corner.png", fit: BoxFit.scaleDown))),
            Positioned(top: 50, left: -150, child: Container(transformAlignment: Alignment.center,
                transform: Matrix4.rotationZ(
                  3.1415926535897932 * 1.8 / 2, // here
                ), child: SizedBox(width: 300, height: 300, child: Image.asset("images/leaf_1.png", fit: BoxFit.scaleDown)))),
            Positioned(top: -100, right: -100, child: Container(transformAlignment: Alignment.center,
                transform: Matrix4.rotationZ(
                  3.1415926535897932 * 2.1 / 2, // here
                ), child: SizedBox(width: 300, height: 300, child: Image.asset("images/leaf_1.png", fit: BoxFit.scaleDown)))),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Spacer(),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user.roundPicture),
                        minRadius: 120,
                      )
                    ]),
                    // Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [Text(user.name, style: Theme.of(context).textTheme.displaySmall)]),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        LabeledNumber(number: user.room.number, label: "chambre"),
                        LabeledNumber(number: DateTime.parse("2023-05-20").difference(DateTime.now()).inDays, label: "jours avant le mariage"),
                        LabeledNumber(number: 59, label: "classement"),
                      ],
                    ),
                    const Spacer(flex: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Samedi 20 mai 2023 à 14h",
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
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child:
                                        Image.asset("images/gift.png",
                                          width: 50,
                                          height: 50,),
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
          ],
        ),
      ),
    );
  },
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
