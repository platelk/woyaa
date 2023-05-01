import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:woyaa/components/custom_appbar.dart';
import 'package:woyaa/components/custom_bottom_appbar.dart';
import 'package:woyaa/responsive.dart';

class Base extends StatelessWidget {
  final Widget child;
  final bool showAppBar;
  final int appBarIndex;

  const Base({
    Key? key,
    required this.child,
    this.showAppBar = true,
    this.appBarIndex = 0,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    const appBar = CustomBottomAppBar();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: Responsive.isDesktop(context) ? 800 : double.infinity,
              height: MediaQuery.of(context).size.height - (showAppBar ? appBar.preferredSize.height : 0),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SafeArea(child: child),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: showAppBar ? appBar : null,
    );
  }
}