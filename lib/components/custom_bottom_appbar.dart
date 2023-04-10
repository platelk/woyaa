import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:woyaa/screens/Anecdoctes/anecdoctes_screen.dart';
import 'package:woyaa/screens/Leadboard/leadboard_screen.dart';
import 'package:woyaa/screens/Swipe/swipe_screens.dart';
import 'package:woyaa/screens/Table/table_screen.dart';

import '../screens/Home/home_screen.dart';
import '../screens/MyTable/my_table_screen.dart';

class CustomBottomAppBar extends StatefulWidget {
  const CustomBottomAppBar({Key? key}) : super(key: key);

  @override
  State<CustomBottomAppBar> createState() => _CustomBottomAppBar();

  Size get preferredSize => _CustomBottomAppBar.preferredSize;
}

class _CustomBottomAppBar extends State<CustomBottomAppBar> {
  int selectedIndex = 0;

  _CustomBottomAppBar({this.selectedIndex = 0});

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  static Size get preferredSize => const Size.fromHeight(70.0);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height,
      child: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        iconSize: 10,
        elevation: 2,
        backgroundColor: const Color(0xFFE8D1C5),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 30,
              icon: Image.asset("images/swipe.png"),
              onPressed: () {
                _onItemTapped(1);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const SwipeScreen();
                    },
                  ),
                );
              },
            ),
            label: 'Swipe',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 30,
              icon: Image.asset("images/resto.png"),
              onPressed: () {
                _onItemTapped(3);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const MyTableScreen();
                    },
                  ),
                );
              },
            ),
            label: 'Ma Table',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 30,
              icon: Image.asset("images/trombii.png"),
              onPressed: () {
                _onItemTapped(3);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const TableScreen();
                    },
                  ),
                );
              },
            ),
            label: 'Table',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 30,
              icon: Image.asset("images/questions.png"),
              onPressed: () {
                _onItemTapped(3);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const AnecdotesScreen();
                    },
                  ),
                );
              },
            ),
            label: 'Question',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 30,
              icon: Image.asset("images/popodium.png"),
              onPressed: () {
                _onItemTapped(2);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LeaderBoardScreen();
                    },
                  ),
                );
              },
            ),
            label: 'Leader',
          ),
          BottomNavigationBarItem(
            backgroundColor: const Color(0xFFF2E7E2),
            icon: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 30,
              icon: Image.asset("images/user.png"),
              onPressed: () {
                _onItemTapped(0);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const HomeScreen();
                    },
                  ),
                );
              },
            ),
            label: 'Home',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: const Color(0xFFBF7366),
      ),
    );
  }
}
