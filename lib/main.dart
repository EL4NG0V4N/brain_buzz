import 'package:flutter/material.dart';
import 'package:brain_buzz_/home_page.dart';

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
      home: HomePage(),
    );
  }
}
