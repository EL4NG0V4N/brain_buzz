import 'package:brain_buzz_/odd_one.dart';
import 'package:flutter/material.dart';

// Define the question model
class ImageQuestion {
  final String questionText;
  final String imagePath;
  final List<String> options;
  final String correctAnswer;

  ImageQuestion({
    required this.questionText,
    required this.imagePath,
    required this.options,
    required this.correctAnswer,
  });
}

class ImageQuizScreen extends StatefulWidget {
  const ImageQuizScreen({super.key});

  @override
  State<ImageQuizScreen> createState() => _ImageQuizScreenState();
}

class _ImageQuizScreenState extends State<ImageQuizScreen> {
  final List<ImageQuestion> questions = [
    ImageQuestion(
      questionText: "Match the word\nand the image",
      imagePath: "assets/images/2.png",
      options: ["mountain", "forest"],
      correctAnswer: "mountain",
    ),
    ImageQuestion(
      questionText: "Which word best represents this image?",
      imagePath: "assets/images/1.jpeg",
      options: ["island", "seashore"],
      correctAnswer: "seashore",
    ),
    // Add more questions here
  ];

  int currentIndex = 0;
  String? selectedAnswer;
  bool wasAnswered = false;

  void handleAnswer(String answer) {
    if (wasAnswered) return;

    setState(() {
      selectedAnswer = answer;
      wasAnswered = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (currentIndex < questions.length - 1) {
        setState(() {
          currentIndex++;
          selectedAnswer = null;
          wasAnswered = false;
        });
      } else {
        _showResultDialog();
        // Quiz finished
        // Navigate or show result if needed
      }
    });
  }

  void _showResultDialog() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OddOneOutQuizScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentIndex];
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D0D4D), Color(0xFF1B2A59)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: (currentIndex + 1) / questions.length,
                  backgroundColor: Colors.white12,
                  color: Colors.white,
                ),
                const SizedBox(height: 40),
                Text(
                  question.questionText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
                const SizedBox(height: 30),
                Image.asset(question.imagePath, height: 180),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      question.options.map((option) {
                        bool isCorrect = option == question.correctAnswer;
                        Color borderColor = Colors.transparent;

                        if (wasAnswered && selectedAnswer == option) {
                          borderColor = isCorrect ? Colors.green : Colors.grey;
                        }

                        return GestureDetector(
                          onTap: () => handleAnswer(option),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(color: borderColor, width: 5),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              option,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 80),
                GestureDetector(
                  onTap: () => handleAnswer("I don't know"),
                  child: const Text(
                    "I don't know",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
