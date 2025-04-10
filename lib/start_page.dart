import 'package:brain_buzz_/models/glowing_button.dart';
import 'package:brain_buzz_/promotion_page.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int currentIndex = 0;
  List<String> responses = [];

  final List<Map<String, String>> questions = [
    {'image': 'assets/images/yn1.png', 'question': 'Improve your vocabulary'},
    {
      'image': 'assets/images/yn2.png',
      'question': 'Strengthen your focus while reading'
    },
    {
      'image': 'assets/images/yn3.png',
      'question': 'Improve your writing abilities'
    },
    {
      'image': 'assets/images/yn4.png',
      'question': 'Enhance your memory skills'
    },
    {'image': 'assets/images/yn5.png', 'question': 'Boost your attention'},
    {
      'image': 'assets/images/yn6.png',
      'question': 'Improve your problem-solving skills'
    },
  ];

  void answerQuestion(String answer) {
    setState(() {
      responses.add(answer);
      if (currentIndex < questions.length - 1) {
        currentIndex++;
      } else {
        // Navigate to results page after last question
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PromotionPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 60), // Push content down
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png', // Replace with actual logo path
                  height: 40, // Adjust size as needed
                ),
                const SizedBox(width: 10),
                Text(
                  'BRAIN BUZZ',
                  style: TextStyle(
                    color: theme.secondary,
                    fontSize: 28, // Adjust font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Image.asset(questions[currentIndex]['image']!, height: 200),
            const SizedBox(height: 20),
            Text(
              questions[currentIndex]['question']!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.onBackground,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GlowingButton(
                    onPressed: () => answerQuestion('Yes'), text: "Yes"),
                GlowingButton(
                    onPressed: () => answerQuestion('No'), text: "No"),
              ],
            ),
            const SizedBox(height: 60), // Adjust spacing
          ],
        ),
      ),
    );
  }
}
