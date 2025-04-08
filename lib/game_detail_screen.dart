// TODO Implement this library.
import 'package:flutter/material.dart';

class GameDetailScreen extends StatelessWidget {
  final String gameTitle;

  const GameDetailScreen({Key? key, required this.gameTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(gameTitle), backgroundColor: Colors.grey[900]),
      body: Center(
        child: Text(
          'Welcome to $gameTitle Game!',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
