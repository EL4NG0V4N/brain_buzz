import 'package:flutter/material.dart';
import 'dart:math';

class PuzzleApp extends StatelessWidget {
  const PuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '15 Puzzle Pro',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const PuzzlePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({super.key});

  @override
  State<PuzzlePage> createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  late List<int> tiles;
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    shuffle();
  }

  void shuffle() {
    tiles = List<int>.generate(16, (i) => i);
    tiles.shuffle();
    if (!_isSolvable(tiles) || _isSolved()) shuffle();
  }

  bool _isSolvable(List<int> board) {
    int inv = 0;
    for (int i = 0; i < board.length; i++) {
      for (int j = i + 1; j < board.length; j++) {
        if (board[i] > board[j] && board[i] != 0 && board[j] != 0) {
          inv++;
        }
      }
    }
    int row = 4 - (board.indexOf(0) ~/ 4);
    return (inv + row) % 2 == 0;
  }

  bool _isSolved() {
    for (int i = 0; i < 15; i++) {
      if (tiles[i] != i + 1) return false;
    }
    return tiles[15] == 0;
  }

  void onTileTap(int index) {
    int empty = tiles.indexOf(0);
    if (_isAdjacent(index, empty)) {
      setState(() {
        tiles[empty] = tiles[index];
        tiles[index] = 0;
      });
      if (_isSolved()) {
        Future.delayed(const Duration(milliseconds: 300), () {
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: const Text("🎉 You Win!"),
                  content: const Text("Nice job solving the puzzle!"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() => shuffle());
                      },
                      child: const Text("Restart"),
                    ),
                  ],
                ),
          );
        });
      }
    }
  }

  void giveHint() {
    int empty = tiles.indexOf(0);
    List<int> possibleMoves = [];

    for (int i = 0; i < 16; i++) {
      if (_isAdjacent(i, empty)) {
        possibleMoves.add(i);
      }
    }

    if (possibleMoves.isNotEmpty) {
      int suggestedMove = possibleMoves[Random().nextInt(possibleMoves.length)];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("💡 Try moving tile ${tiles[suggestedMove]}"),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  bool _isAdjacent(int a, int b) {
    int rowA = a ~/ 4, colA = a % 4;
    int rowB = b ~/ 4, colB = b % 4;
    return (rowA == rowB && (colA - colB).abs() == 1) ||
        (colA == colB && (rowA - rowB).abs() == 1);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.85;

    return Scaffold(
      appBar: AppBar(
        title: const Text("15 Puzzle Pro"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                isDark = !isDark;
              });
              final mode = isDark ? ThemeMode.dark : ThemeMode.light;
              WidgetsBinding.instance.window.platformBrightness ==
                      Brightness.dark
                  ? mode
                  : mode;
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Optional Background Image
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/bg.jpg', // Replace with your image asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: size,
                  height: size,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 16,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemBuilder: (context, index) {
                      final value = tiles[index];
                      return GestureDetector(
                        onTap: () => onTileTap(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color:
                                value == 0
                                    ? Colors.transparent
                                    : Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow:
                                value == 0
                                    ? []
                                    : [
                                      BoxShadow(
                                        color: Theme.of(context).shadowColor,
                                        offset: const Offset(2, 2),
                                        blurRadius: 6,
                                      ),
                                    ],
                          ),
                          child: Center(
                            child: Text(
                              value == 0 ? '' : '$value',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color:
                                    value == 0
                                        ? Colors.transparent
                                        : Theme.of(
                                          context,
                                        ).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 16,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => setState(() => shuffle()),
                      icon: const Icon(Icons.replay),
                      label: const Text("Restart"),
                    ),
                    ElevatedButton.icon(
                      onPressed: giveHint,
                      icon: const Icon(Icons.lightbulb_outline),
                      label: const Text("Hint"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
