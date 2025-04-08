import 'package:brain_buzz_/thank_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class MathQuizQuestion {
  final String leftOperand;
  final String operator;
  final String rightOperand;
  final List<String> options;
  final String correctAnswer;

  MathQuizQuestion({
    required this.leftOperand,
    required this.operator,
    required this.rightOperand,
    required this.options,
    required this.correctAnswer,
  });
}

class MathQuizScreen extends StatefulWidget {
  const MathQuizScreen({Key? key}) : super(key: key);

  @override
  State<MathQuizScreen> createState() => _MathQuizScreenState();
}

class _MathQuizScreenState extends State<MathQuizScreen> {
  final List<MathQuizQuestion> questions = [
    MathQuizQuestion(
      leftOperand: "4",
      operator: "+",
      rightOperand: "9",
      options: ['6', '5'],
      correctAnswer: '5',
    ),
    MathQuizQuestion(
      leftOperand: "7",
      operator: "-",
      rightOperand: "3",
      options: ['4', '5'],
      correctAnswer: '4',
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ThankYouScreen()),
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: progress,
                color: Colors.white,
                backgroundColor: Colors.white24,
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildEquationText(question.leftOperand),
                  _buildEquationText(" ${question.operator} "),
                  Container(
                    width: 60,
                    height: 60,
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      color: const Color(0xFF06244D),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(height: 4, color: Colors.cyanAccent),
                  ),
                  _buildEquationText(" = "),
                  _buildEquationText(question.rightOperand),
                ],
              ),
              const SizedBox(height: 48),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
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

  Widget _buildEquationText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
