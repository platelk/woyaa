import 'package:flutter/material.dart';
import 'package:woyaa/models/models.dart';

import '../../components/base.dart';

class LeaderBoardScreen extends StatelessWidget {
  const LeaderBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = User.users[0];
    const points = 100;
    const index = 1;

    return Base(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text("Gagnerez vous le 1er prix ?"),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.imageUrls[0]),
                ),
                Column(children: [
                  Text(user.name),
                  Text("Points: ${points}"),
                  Text("Classement: ${index}")
                ],)
              ],
            ),
            Expanded(
              child: SizedBox(
                height: 200.0,
                child: ListView.builder(
                    itemCount: 100,
                    itemBuilder: (context, index) {
                      return LeaderBoardItem(user: User.users[0], index: index, points: 0);
                    },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LeaderBoardItem extends StatelessWidget {
  final User user;
  final int index;
  final int points;
  const LeaderBoardItem({super.key, required this.user, required this.index, required this.points});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("${index}"),
        Spacer(),
        Text("${user.name}"),
        Spacer(),
        Text("${points}pts"),
      ],
    );
  }

}