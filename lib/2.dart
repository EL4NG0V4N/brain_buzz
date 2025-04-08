import 'package:flutter/material.dart';
import 'package:brain_buzz_/3.dart'; // Make sure this points to DidYouKnowScreen

class ADHDQuestionScreen extends StatelessWidget {
  const ADHDQuestionScreen({super.key});

  void _navigateToDidYouKnow(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DidYouKnowScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {}, // Add skip action here if needed
            child: Text("Skip", style: TextStyle(color: Colors.grey)),
          ),
        ],
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Do you have ADD/ADHD?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              "These can affect your communication skills.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            OptionButton(
              text: "Yes",
              onPressed: () => _navigateToDidYouKnow(context),
            ),
            OptionButton(
              text: "I think I do",
              onPressed: () => _navigateToDidYouKnow(context),
            ),
            OptionButton(
              text: "No",
              onPressed: () => _navigateToDidYouKnow(context),
            ),
            OptionButton(
              text: "I prefer not to share",
              onPressed: () => _navigateToDidYouKnow(context),
            ),
            TextButton(
              onPressed: () => _navigateToDidYouKnow(context),
              child: Text(
                "Not sure",
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const OptionButton({required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          minimumSize: Size(double.infinity, 50),
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
