import 'package:brain_buzz_/math_quiz.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class OddOneOutQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;

  OddOneOutQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}

class OddOneOutQuizScreen extends StatefulWidget {
  const OddOneOutQuizScreen({Key? key}) : super(key: key);

  @override
  State<OddOneOutQuizScreen> createState() => _OddOneOutQuizScreenState();
}

class _OddOneOutQuizScreenState extends State<OddOneOutQuizScreen> {
  final List<OddOneOutQuestion> questions = [
    OddOneOutQuestion(
      question: "Which word doesn't fit?",
      options: ['inconsiderate', 'generous', 'selfish'],
      correctAnswer: 'generous',
    ),
    OddOneOutQuestion(
      question: "Which is not a fruit?",
      options: ['apple', 'banana', 'carrot'],
      correctAnswer: 'carrot',
    ),
    OddOneOutQuestion(
      question: "Which is not a programming language?",
      options: ['Python', 'Flutter', 'Java'],
      correctAnswer: 'Flutter',
    ),
  ];

  int currentQuestionIndex = 0;
  String? selectedOption;
  bool isAnswered = false;

  void handleAnswer(String option) {
    if (isAnswered) return;

    setState(() {
      selectedOption = option;
      isAnswered = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      goToNextQuestion();
    });
  }

  void goToNextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOption = null;
        isAnswered = false;
      });
    } else {
      // End of quiz logic
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MathQuizScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFF101041),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: progress,
                color: Colors.white,
                backgroundColor: Colors.white24,
              ),
              const SizedBox(height: 32),
              Text(
                question.question,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children:
                    question.options.map((option) {
                      final isCorrect = option == question.correctAnswer;
                      final isSelected = option == selectedOption;

                      Color borderColor = Colors.transparent;
                      if (isAnswered && isSelected) {
                        borderColor = isCorrect ? Colors.green : Colors.grey;
                      }

                      return GestureDetector(
                        onTap: () => handleAnswer(option),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(color: borderColor, width: 4),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            option,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () => handleAnswer(''),
                child: const Text(
                  "I don't know",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
