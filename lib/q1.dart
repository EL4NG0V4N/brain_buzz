import 'package:brain_buzz_/image_screen.dart';
import 'package:flutter/material.dart';
import 'question_model.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  String? selectedAnswer;
  bool showFeedback = false;

  final List<Question> questions = [
    Question(
      text: 'She went ___ the store.',
      options: ['to', 'too'],
      correctAnswer: 'to',
    ),
    Question(
      text: 'I want to go ___.',
      options: ['to', 'too'],
      correctAnswer: 'too',
    ),
    Question(
      text: 'He ran ___ fast.',
      options: ['to', 'too'],
      correctAnswer: 'too',
    ),
  ];

  void _handleAnswer(String answer) {
    if (selectedAnswer != null) return;

    setState(() {
      selectedAnswer = answer;
      showFeedback = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          if (currentQuestionIndex < questions.length - 1) {
            currentQuestionIndex++;
            selectedAnswer = null;
            showFeedback = false;
          } else {
            _showResultDialog();
          }
        });
      }
    });
  }

  void _showResultDialog() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ImageQuizScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildQuestionText(question.text),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      question.options.map((option) {
                        return OptionButton(
                          label: option,
                          isSelected: selectedAnswer == option,
                          isCorrect: question.correctAnswer == option,
                          wasAnswered: showFeedback,
                          onTap: () => _handleAnswer(option),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 80),
                GestureDetector(
                  onTap: () => _handleAnswer("I don't know"),
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

  Widget _buildQuestionText(String text) {
    // Handles ___ blank placeholder
    final parts = text.split("___");
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: parts[0],
            style: const TextStyle(fontSize: 26, color: Colors.white),
          ),
          const WidgetSpan(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                child: SizedBox(width: 50, height: 30),
              ),
            ),
          ),
          TextSpan(
            text: parts.length > 1 ? parts[1] : "",
            style: const TextStyle(fontSize: 26, color: Colors.white),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class OptionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isCorrect;
  final bool wasAnswered;

  const OptionButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.isSelected,
    required this.isCorrect,
    required this.wasAnswered,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.transparent;

    if (wasAnswered && isSelected) {
      borderColor = isCorrect ? Colors.greenAccent : Colors.grey;
    }

    return GestureDetector(
      onTap: onTap,
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
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
