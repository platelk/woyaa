import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(children: [
        OverflowBox(
          child: Row(
            children: [
              const Spacer(flex: 3),
              Expanded(
                flex: 14,
                child: SizedOverflowBox(
                  size: const Size(800, 1200),
                  child: Image.asset(
                    "images/login_welcome_background.png",
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Image.asset("images/login_text.png", fit: BoxFit.contain)),
          ],
        )
      ]),
    );
  }
}
