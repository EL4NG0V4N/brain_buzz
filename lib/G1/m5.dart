import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(NumberGameApp());

class NumberGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Game',
      theme: ThemeData.dark(),
      home: GameHomePage(),
    );
  }
}

class GameHomePage extends StatefulWidget {
  @override
  _GameHomePageState createState() => _GameHomePageState();
}

class _GameHomePageState extends State<GameHomePage> {
  int gridSize = 4; // Default to Medium
  late List<int> numbers;
  late List<bool> revealed;
  int? firstIndex;
  int? secondIndex;
  int score = 0;
  int moves = 0;
  bool waiting = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    List<int> baseNumbers = List.generate(
      (gridSize * gridSize ~/ 2),
      (i) => i + 1,
    );
    numbers = [...baseNumbers, ...baseNumbers];
    numbers.shuffle();
    revealed = List<bool>.filled(numbers.length, false);
    firstIndex = null;
    secondIndex = null;
    score = 0;
    moves = 0;
    waiting = false;
  }

  void _onTileTap(int index) {
    if (waiting || revealed[index]) return;

    setState(() {
      if (firstIndex == null) {
        firstIndex = index;
      } else if (secondIndex == null && index != firstIndex) {
        secondIndex = index;
        moves++;
        waiting = true;

        Future.delayed(Duration(milliseconds: 800), () {
          setState(() {
            if (numbers[firstIndex!] == numbers[secondIndex!]) {
              revealed[firstIndex!] = true;
              revealed[secondIndex!] = true;
              score += 10;
              _checkForWin();
            }
            firstIndex = null;
            secondIndex = null;
            waiting = false;
          });
        });
      }
    });
  }

  void _checkForWin() {
    if (revealed.every((element) => element)) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text('🎉 Game Over'),
              content: Text(
                'You matched all pairs!\nScore: $score\nMoves: $moves',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(_initializeGame);
                  },
                  child: Text('Play Again'),
                ),
              ],
            ),
      );
    }
  }

  Widget _buildGridTile(int index) {
    bool isRevealed =
        revealed[index] || index == firstIndex || index == secondIndex;

    return GestureDetector(
      onTap: () => _onTileTap(index),
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isRevealed ? Colors.teal : Colors.grey[850],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            isRevealed ? '${numbers[index]}' : '',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Match'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => setState(_initializeGame),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Text('Score: $score', style: TextStyle(fontSize: 22)),
          Text('Moves: $moves', style: TextStyle(fontSize: 18)),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
              ),
              itemCount: numbers.length,
              itemBuilder: (context, index) => _buildGridTile(index),
            ),
          ),
        ],
      ),
    );
  }
}
