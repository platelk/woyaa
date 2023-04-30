import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:woyaa/responsive.dart';

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
              (Responsive.isMobile(context))? const Spacer(flex: 3) : const Spacer(flex: 2),
              Expanded(
                flex: 14,
                  child: Image.asset("images/login_welcome_background.png"),
                ),
              const Spacer(flex: 1),
            ],
          ),
        ),
          Column(
             children: [
              const Spacer(flex: 5),
              Center(child: Image.asset("images/bienvenue_au.png", scale: 4)),
              const Spacer(),
              Center(child: Image.asset("images/ana_et_yoann.png", scale: 5)),
              const Spacer(flex: 3),
            ],
          ),
      ]),
    );
  }
}
