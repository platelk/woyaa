import 'package:flutter/material.dart';
import 'package:woyaa/components/base.dart';

import '../../models/user.dart';

class MyTableScreen extends StatelessWidget {
  const MyTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Base(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          // Generate 100 widgets that display their index in the List.
            itemCount: 9,
          itemBuilder: (context, index) {
            return TableGuest(user: User.users[0]);
          }),
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
        Text(user.name),
      ],
    );
  }
}
