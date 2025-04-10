import 'package:brain_buzz_/G1/m1.dart';
import 'package:brain_buzz_/G1/m2.dart';
import 'package:brain_buzz_/G1/m3.dart';
import 'package:brain_buzz_/G1/m4.dart';
import 'package:brain_buzz_/G1/m5.dart';
import 'package:brain_buzz_/q1.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(RecommendationApp());
}

class RecommendationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recommendation UI',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home: RecommendationHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RecommendationHomePage extends StatelessWidget {
  final List<Map<String, dynamic>> appItems = [
    {'name': 'Brevity', 'page': HomePage()},
    {'name': 'Commas', 'page': PuzzleApp()},
    {'name': 'Detail', 'page': MemoryGameScreen()},
    {'name': 'Grammar Fix', 'page': SokobanGame(levelIndex: 0)},
    {'name': 'Skimming', 'page': NumberGameApp()},
    {'name': 'Daily Puzzle', 'page': QuizScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Today')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommended Apps',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Horizontal Scroll Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    appItems.map((item) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => item['page']),
                          );
                        },
                        child: Container(
                          width: 120,
                          margin: EdgeInsets.symmetric(horizontal: 6),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              item['name'],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),

            SizedBox(height: 30),

            // Daily Puzzle Redirect
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => QuizScreen()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Daily Puzzle',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Stub Pages for Navigation
