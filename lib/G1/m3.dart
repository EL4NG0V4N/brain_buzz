import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MemoryGameApp());
}

class MemoryGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: Colors.indigo.shade50,
      ),
      home: MemoryGameScreen(),
    );
  }
}

class MemoryGameScreen extends StatefulWidget {
  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  List<_CardModel> cards = [];
  List<int> flippedIndices = [];
  int score = 0;
  int tries = 0;
  Timer? _timer;
  int seconds = 60;
  bool gameEnded = false;

  final List<String> emojis = ['🐶', '🐱', '🦊', '🐻', '🐼', '🐵'];

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    List<String> allEmojis = [...emojis, ...emojis];
    allEmojis.shuffle(Random());

    cards = List.generate(
      allEmojis.length,
      (index) => _CardModel(content: allEmojis[index]),
    );

    flippedIndices.clear();
    score = 0;
    tries = 0;
    seconds = 60;
    gameEnded = false;

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds == 0) {
        setState(() {
          gameEnded = true;
          _timer?.cancel();
        });
      } else {
        setState(() {
          seconds--;
        });
      }
    });

    setState(() {});
  }

  void _flipCard(int index) {
    if (cards[index].isMatched ||
        cards[index].isFlipped ||
        flippedIndices.length == 2 ||
        gameEnded)
      return;

    setState(() {
      cards[index].isFlipped = true;
      flippedIndices.add(index);
    });

    if (flippedIndices.length == 2) {
      tries++;
      Future.delayed(Duration(milliseconds: 500), () {
        final firstIndex = flippedIndices[0];
        final secondIndex = flippedIndices[1];

        if (cards[firstIndex].content == cards[secondIndex].content) {
          setState(() {
            cards[firstIndex].isMatched = true;
            cards[secondIndex].isMatched = true;
            score++;
          });
        } else {
          setState(() {
            cards[firstIndex].isFlipped = false;
            cards[secondIndex].isFlipped = false;
          });
        }

        setState(() => flippedIndices.clear());
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWin = score == emojis.length;

    return Scaffold(
      appBar: AppBar(
        title: Text("Memory Game"),
        centerTitle: true,
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: _startGame)],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _InfoBox(label: 'Score', value: '$score'),
                _InfoBox(label: 'Tries', value: '$tries'),
                _InfoBox(label: 'Time', value: '$seconds s'),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: cards.length,
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final card = cards[index];
                return GestureDetector(
                  onTap: () => _flipCard(index),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color:
                          card.isMatched || card.isFlipped
                              ? Colors.white
                              : Colors.indigo,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      card.isMatched || card.isFlipped ? card.content : "?",
                      style: TextStyle(fontSize: 28),
                    ),
                  ),
                );
              },
            ),
          ),
          if (gameEnded || isWin)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    isWin ? "🎉 You Win!" : "⏳ Time's up!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _startGame,
                    child: Text("Play Again"),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CardModel {
  final String content;
  bool isFlipped = false;
  bool isMatched = false;

  _CardModel({required this.content});
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;

  const _InfoBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
      ],
    );
  }
}
