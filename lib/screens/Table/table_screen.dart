import 'package:flutter/material.dart';
import 'package:woyaa/components/base.dart';
import 'package:woyaa/constants.dart';
import 'package:woyaa/tables_theme.dart';


import '../../models/user.dart';

class TableScreen extends StatelessWidget {
  const TableScreen({super.key});

  @override
  Widget build(BuildContext context) {
return Theme(
      data: tablesTheme(),
      child: Base(
        child: Stack(
          children: [
            Positioned(bottom: -20, right: -120, child: SizedBox(width: 300, height: 300, child: Image.asset("images/leaf_1.png", fit: BoxFit.scaleDown))),
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Text(
                      "Les invités",
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(color: kBackgroundColor, fontFamily: 'Adelia'),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  width: MediaQuery.of(context).size.width,
                  child: GridView.count(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 4,
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      // Generate 100 widgets that display their index in the List.
                      children: List.generate(100, (index) {
                      return TableGuest(user: User.users[0]);
                   })),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TableGuest extends StatelessWidget {
  final User user;

  const TableGuest({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(user.roundPicture),
        ),
        Center(child: Text(user.name, textAlign: TextAlign.center,)),
      ],
    );
  }
}
