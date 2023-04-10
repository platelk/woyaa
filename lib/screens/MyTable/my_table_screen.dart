import 'package:flutter/material.dart';
import 'package:woyaa/components/base.dart';
import 'package:woyaa/constants.dart';
import 'package:woyaa/tables_theme.dart';

import '../../models/user.dart';

class MyTableScreen extends StatelessWidget {
  const MyTableScreen({super.key});

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
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Table",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: kBackgroundColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Amsterdam",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(color: kBackgroundColor, fontFamily: 'Adelia')),
                  ),
                  Text("Voyage de nos 1an de relation",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: kBackgroundColor)),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 180.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      // Generate 100 widgets that display their index in the List.
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TableGuest(user: User.users[0]),
                        );
                      }),
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
    return Row(
      children: [
        const Spacer(
          flex: 2,
        ),
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(user.imageUrls[0]),
        ),
        const Spacer(),
        Text(
          user.name,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const Spacer(
          flex: 2,
        ),
      ],
    );
  }
}
