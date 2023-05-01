import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:woyaa/components/base.dart';
import 'package:woyaa/constants.dart';
import 'package:woyaa/tables_theme.dart';


import '../../blocs/users/user_bloc.dart';
import '../../models/user.dart';

class TableScreen extends StatelessWidget {
  const TableScreen({super.key});

  @override
  Widget build(BuildContext context) {
return BlocBuilder<UserBloc, UserState>(
  builder: (context, state) {
    if (state is! UserInitialized) {
      return Theme(
          data: trombiTheme(),
          child: const Base(child: Text("loading.."),));
    }
    return Theme(
      data: trombiTheme(),
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
                      childAspectRatio: (1 / 1.2),
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 3,
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      // Generate 100 widgets that display their index in the List.
                      children: List.generate(state.users.length, (index) {
                      return TableGuest(user: state.users.values.elementAt(index));
                   })),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  },
);
  }
}

class TableGuest extends StatelessWidget {
  final User user;

  const TableGuest({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 150,
        width: 100,
        child: Column(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(user.roundPicture),
            ),
            Center(child: Text(user.name, textAlign: TextAlign.center,)),
          ],
        ),
      ),
    );
  }
}
