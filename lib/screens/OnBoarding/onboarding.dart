import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:woyaa/screens/Home/home_screen.dart';
import 'package:woyaa/screens/Swipe/swipe_screens.dart';

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
    return Scaffold(
      body: SafeArea(
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
                height: 60,
                width: 60,
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
                  style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                  child: Icon(Icons.arrow_forward),
                )),
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
        const Spacer(),
        Image.asset(
          image,
          height: 250,
        ),
        const Spacer(),
        Text(title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Text(description, textAlign: TextAlign.center),
        const Spacer(),
      ],
    );
  }
}

final List<OnBoard> data = [
  OnBoard(
      image: "assets/images/splash_1.png",
      title: "title 1",
      description: "description 1"),
  OnBoard(
      image: "assets/images/splash_2.png",
      title: "title 2",
      description: "description 2"),
  OnBoard(
      image: "assets/images/splash_3.png",
      title: "title 3",
      description: "description 3"),
];
