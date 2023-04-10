import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:woyaa/screens/Home/home_screen.dart';
import 'package:woyaa/screens/Swipe/swipe_screens.dart';
import 'package:woyaa/welcome_theme.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: welcomeTheme(),
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(top: -100, right: -100, child: SizedBox(width: 300, height: 300, child: Image.asset("images/leaf_right_top_corner.png", fit: BoxFit.scaleDown))),
            Positioned(bottom: -100, right: -100, child: SizedBox(width: 300, height: 300, child: Image.asset("images/leaf_left_corner.png", fit: BoxFit.scaleDown))),
            SafeArea(
              minimum: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                        itemCount: data.length,
                        controller: _pageController,
                        itemBuilder: (context, index) {
                          final d = data[index];
                          return OnBoardContent(
                            image: d.image,
                            title: d.title,
                            description: d.description,
                          );
                        }),
                  ),
                  SizedBox(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_pageController.page?.ceil() == data.length - 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const HomeScreen();
                                },
                              ),
                            );
                          }
                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease);
                        },
                          style: ButtonStyle(
                              foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                              backgroundColor:
                              MaterialStateProperty.all<Color>(Color(0xFFE8D1C5)),
                              shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                      side:
                                      const BorderSide(color: Color(0xFFE8D1C5))))),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Suivant",
                            style:  Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnBoard {
  final String image, title, description;

  OnBoard(
      {required this.image, required this.title, required this.description});
}

class OnBoardContent extends StatelessWidget {
  const OnBoardContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (image.isNotEmpty) ...[const Spacer(), Image.asset(
          image,
          height: 250,
        )],
        const Spacer(),
        Text(title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 16),
        Text(description, textAlign: TextAlign.center, style: Theme.of(context)
            .textTheme
            .headlineSmall!.copyWith(color: Colors.white)),
        const Spacer(),
      ],
    );
  }
}

final List<OnBoard> data = [
  OnBoard(
      image: "",
      title: "BRAVO !",
      description: """
      Vous etes bien inscrits a notre mariage,
      vous trouverez ici toutes les infos sur l'evenements,
      des defis, des choses a gagner et plus encore !
      
      Bonne decouverte !
      """),
];
