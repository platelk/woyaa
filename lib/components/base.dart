import 'package:flutter/material.dart';
import 'package:woyaa/components/custom_appbar.dart';
import 'package:woyaa/components/custom_bottom_appbar.dart';
import 'package:woyaa/responsive.dart';

class Base extends StatelessWidget {
  final Widget child;

  const Base({
    Key? key,
    required this.child,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    final appBar = CustomBottomAppBar();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: Responsive.isDesktop(context) ? 800 : double.infinity,
              height: MediaQuery.of(context).size.height - appBar.preferredSize.height,
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
      bottomNavigationBar: appBar,
    );
  }
}