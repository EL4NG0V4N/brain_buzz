import 'package:brain_buzz_/f1.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class GetResults_Screen extends StatelessWidget {
  const GetResults_Screen({super.key});

  Widget buildSkillRow(String label, int score, String level, Color color) {
    double progress = score / 5000;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$label: $score',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                level,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101041),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Your starting EPQ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              // Skill bars
              buildSkillRow("WRITING", 1335, "INTERMEDIATE", Colors.cyan),
              buildSkillRow(
                "SPEAKING",
                1329,
                "INTERMEDIATE",
                Colors.deepOrange,
              ),
              buildSkillRow("READING", 1305, "INTERMEDIATE", Colors.pinkAccent),
              buildSkillRow("MATH", 2551, "ADVANCED", Colors.deepPurpleAccent),
              buildSkillRow("MEMORY", 3202, "ADVANCED", Colors.orange),

              const Spacer(),

              // Finish button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.teal[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Finish setting up account",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
