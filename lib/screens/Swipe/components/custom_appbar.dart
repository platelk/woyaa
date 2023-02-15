import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          Expanded(
              child: Image.asset(
                "assets/images/mastercard-2.png",
                height: 50,
              )),
          Expanded(
              flex: 2,
              child: Text(
                "WeddingApp",
                style: Theme.of(context).textTheme.headlineLarge,
              )),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.person, color: Theme.of(context).primaryColor))
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(56.0);
}
