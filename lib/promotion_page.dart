import 'package:brain_buzz_/motivation_screen.dart';
import 'package:flutter/material.dart';

class PromotionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Text(
                'Brain Buzz members report\npowerful results:',
                style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.onPrimary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ResultCard(
                  percentage: '93%',
                  description: 'felt mentally sharper',
                  color: Colors.orange),
              SizedBox(height: 16),
              ResultCard(
                  percentage: '89%',
                  description: 'improved mental math skills',
                  color: Colors.blue),
              SizedBox(height: 16),
              ResultCard(
                  percentage: '88%',
                  description: 'boosted writing skills',
                  color: Colors.teal),
              Spacer(),
              Text(
                'Based on a study of members who used Brain Buzz 5 times per week.',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MotivationScreen(),
                    )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                ),
                child: Text(
                  'Continue',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  final String percentage;
  final String description;
  final Color color;

  const ResultCard(
      {required this.percentage,
      required this.description,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Text(percentage, style: TextStyle(color: Colors.white)),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(description, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
