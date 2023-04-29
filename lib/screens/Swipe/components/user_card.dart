import 'package:flutter/material.dart';
import 'package:woyaa/models/models.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 320,
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: NetworkImage(user.fullPicture),
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              user.name,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: const Color(0xFF293D84), fontWeight: FontWeight.bold),
            ),
          ),
        ]),
      ),
    );
  }
}
