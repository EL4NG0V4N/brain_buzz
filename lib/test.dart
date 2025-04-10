import 'package:flutter/material.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text prompt at the top
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'She went ___ the store.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Option buttons in a row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColorfulBubbleButton(text: 'too'),
                  SizedBox(width: 20), // Space between buttons
                  ColorfulBubbleButton(text: 'to'),
                ],
              ),
              SizedBox(height: 40), // Space above "I don't know"
              // "I don't know" option at the bottom
              Text(
                "I don't know",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ColorfulBubbleButton extends StatelessWidget {
  final String text;

  const ColorfulBubbleButton({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.shade300.withOpacity(0.7),
            Colors.tealAccent.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // Handle button press
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          shape: CircleBorder(),
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

void main() {
  runApp(const BrainBuzzApp());
}

class BrainBuzzApp extends StatelessWidget {
  const BrainBuzzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brain Buzz App',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Colors.deepOrange,
          secondary: Colors.deepOrangeAccent,
          background: Colors.black,
          surface: Colors.grey[900]!,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Colors.white70,
          onSurface: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const QuizPage(),
    );
  }
}
