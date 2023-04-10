import 'package:flutter/material.dart';
import 'package:woyaa/components/base.dart';

import '../../models/user.dart';

class TableScreen extends StatelessWidget {
  const TableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Base(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text("Les invitees", style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black),),
          ),
          // Text("Amsterdam" style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: Colors.black)),
          // Text("Voyage de nos 1an de relation", style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              crossAxisSpacing: 2.0,
              mainAxisSpacing: 2.0,
              scrollDirection: Axis.vertical,
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 4,
              // Generate 100 widgets that display their index in the List.
              children: List.generate(100, (index) {
                return TableGuest(user: User.users[0]);
              }),
            ),
          ),
        ],
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
          backgroundImage: NetworkImage(user.imageUrls[0]),
        ),
        Center(child: Text(user.name, textAlign: TextAlign.center,)),
      ],
    );
  }
}
