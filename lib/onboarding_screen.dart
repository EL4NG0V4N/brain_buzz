import 'package:brain_buzz_/start_page.dart';
import 'package:flutter/material.dart';
import 'package:intro_screen_onboarding_flutter/intro_app.dart';

class OnboardingScreen extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      title: 'Challenge  Your Mind',
      subTitle:
          'Play 40+ brain games to improve your vocabulary, communication, memory skills, and more.',
      imageUrl: 'assets/images/ob1.png',
    ),
    Introduction(
      title: 'Track Your Progress',
      subTitle:
          'Measure your mental fitness, identify areas of growth, and celebrate your accomplishments.',
      imageUrl: 'assets/images/ob2.png',
    ),
    Introduction(
      title: 'See The Benefits',
      subTitle:
          'Improve your productivity, earning power, and self-confidence with games developed by educational experts.',
      imageUrl: 'assets/images/ob3.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      backgroudColor: Theme.of(context).colorScheme.background,
      foregroundColor: Theme.of(context).colorScheme.primary,
      introductionList: list,
      onTapSkipButton: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StartPage(),
          )),
      skipTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
