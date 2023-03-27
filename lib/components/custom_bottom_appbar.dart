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
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static Size get preferredSize => const Size.fromHeight(86.0);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          backgroundColor: Color(0xFFBF7366),
          icon: IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
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
        BottomNavigationBarItem(
          icon: IconButton(
            icon: const Icon(Icons.account_box_outlined, color: Colors.white),
            onPressed: () {
              _onItemTapped(1);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SwipeScreen();
                  },
                ),
              );
            },
          ),
          label: 'Swipe',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: const Icon(Icons.list, color: Colors.white),
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
          icon: IconButton(
            icon: const Icon(Icons.table_bar, color: Colors.white),
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
            icon: const Icon(Icons.table_bar, color: Colors.white),
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
            icon: const Icon(Icons.question_mark_outlined, color: Colors.white),
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
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
    );
  }
}
