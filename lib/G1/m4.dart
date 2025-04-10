import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: SokobanGame(levelIndex: 0)));

class SokobanGame extends StatefulWidget {
  final int levelIndex;

  const SokobanGame({super.key, required this.levelIndex});

  @override
  State<SokobanGame> createState() => _SokobanGameState();
}

class _SokobanGameState extends State<SokobanGame> {
  static const int gridSize = 5;
  late List<List<String>> grid;
  int playerX = 0;
  int playerY = 0;

  @override
  void initState() {
    super.initState();
    loadLevel();
  }

  void loadLevel() {
    List<List<String>> level = SokobanLevels.levels[widget.levelIndex];
    grid = List.generate(
      gridSize,
      (y) => List.generate(gridSize, (x) => level[y][x]),
    );
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        if (grid[y][x] == 'P') {
          playerX = x;
          playerY = y;
          grid[y][x] = ' ';
        }
      }
    }
  }

  void movePlayer(int dx, int dy) {
    int newX = playerX + dx;
    int newY = playerY + dy;

    if (!_inBounds(newX, newY)) return;

    String target = grid[newY][newX];

    if (target == 'W') return; // Wall collision

    if (target == 'B') {
      // Push box logic
      int boxNewX = newX + dx;
      int boxNewY = newY + dy;
      if (!_inBounds(boxNewX, boxNewY)) return;
      String beyond = grid[boxNewY][boxNewX];
      if (beyond == ' ' || beyond == 'G') {
        grid[boxNewY][boxNewX] = 'B';
        grid[newY][newX] = ' ';
      } else {
        return;
      }
    }

    setState(() {
      playerX = newX;
      playerY = newY;
    });

    if (_isLevelComplete()) {
      _showWinDialog();
    }
  }

  bool _inBounds(int x, int y) =>
      x >= 0 && y < gridSize && x < gridSize && y >= 0;

  bool _isLevelComplete() {
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        if (grid[y][x] == 'G') return false;
      }
    }
    return true;
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("🎉 Level Complete!"),
            actions: [
              if (widget.levelIndex < SokobanLevels.levels.length - 1)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder:
                            (_, __, ___) => SokobanGame(
                              levelIndex: widget.levelIndex + 1,
                            ), // Transition to next level
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: const Text("Next Level"),
                ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const HomeScreen(),
                      transitionsBuilder: (_, animation, __, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                    ),
                    (route) => false,
                  );
                },
                child: const Text("Back to Menu"),
              ),
            ],
          ),
    );
  }

  Widget buildGrid() {
    List<Widget> rows = [];
    for (int y = 0; y < gridSize; y++) {
      List<Widget> row = [];
      for (int x = 0; x < gridSize; x++) {
        Color color = _getTileColor(x, y);
        row.add(
          Container(
            margin: const EdgeInsets.all(2),
            width: 50,
            height: 50,
            color: color,
          ),
        );
      }
      rows.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: row));
    }
    return Column(children: rows);
  }

  Color _getTileColor(int x, int y) {
    if (x == playerX && y == playerY) return Colors.blue;
    switch (grid[y][x]) {
      case 'W':
        return Colors.black;
      case 'G':
        return Colors.green;
      case 'B':
        return Colors.brown;
      default:
        return Colors.grey[300]!;
    }
  }

  Widget buildControls() {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_upward),
          onPressed: () => movePlayer(0, -1),
          tooltip: 'Move Up',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => movePlayer(-1, 0),
              tooltip: 'Move Left',
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () => movePlayer(1, 0),
              tooltip: 'Move Right',
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.arrow_downward),
          onPressed: () => movePlayer(0, 1),
          tooltip: 'Move Down',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Level ${widget.levelIndex + 1}")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [buildGrid(), const SizedBox(height: 20), buildControls()],
      ),
    );
  }
}

class SokobanLevels {
  static final List<List<List<String>>> levels = [
    [
      [' ', ' ', ' ', ' ', ' '],
      [' ', 'W', 'W', ' ', ' '],
      [' ', 'B', ' ', 'G', ' '],
      [' ', ' ', 'P', ' ', ' '],
      [' ', ' ', ' ', ' ', ' '],
    ],
    [
      [' ', ' ', ' ', 'G', ' '],
      [' ', 'W', 'W', ' ', ' '],
      [' ', ' ', 'B', ' ', ' '],
      [' ', 'P', ' ', ' ', ' '],
      [' ', ' ', ' ', ' ', ' '],
    ],
    [
      [' ', ' ', 'B', ' ', ' '],
      [' ', 'W', 'B', 'W', ' '],
      [' ', 'B', 'P', ' ', ' '],
      [' ', 'W', ' ', 'G', ' '],
      [' ', ' ', ' ', ' ', ' '],
    ],
    [
      [' ', 'B', ' ', ' ', ' '],
      [' ', 'W', 'W', ' ', ' '],
      [' ', 'B', 'P', 'G', ' '],
      [' ', ' ', 'W', ' ', ' '],
      [' ', ' ', ' ', ' ', ' '],
    ],
    [
      ['B', ' ', ' ', ' ', ' '],
      ['W', 'B', 'B', ' ', ' '],
      ['P', 'B', 'G', 'W', ' '],
      [' ', ' ', 'W', ' ', ' '],
      [' ', ' ', ' ', ' ', ' '],
    ],
  ];
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sokoban Game")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const SokobanGame(levelIndex: 0),
                transitionsBuilder: (_, animation, __, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              ),
            );
          },
          child: const Text("Start Game"),
        ),
      ),
    );
  }
}
