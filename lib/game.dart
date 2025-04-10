import 'package:brain_buzz_/G1/m1.dart';
import 'package:brain_buzz_/G1/m2.dart';
import 'package:brain_buzz_/G1/m3.dart';
import 'package:brain_buzz_/G1/m4.dart';
import 'package:brain_buzz_/G1/m5.dart';
import 'package:brain_buzz_/G1/m6.dart';
import 'package:brain_buzz_/speaking.dart'; // YouTubeLinksPlayer() screen
import 'package:flutter/material.dart';

class GamesScreen extends StatefulWidget {
  @override
  _GamesScreenState createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  bool showStats = false;
  String selectedCategory = 'Writing';

  final List<String> categories = [
    'Writing',
    'Speaking',
    'Reading',
    'Memory',
    'Math',
  ];

  final Map<String, List<String>> gameMap = {
    'Writing': ['Brevity', 'Commas', 'Detail', 'Grammar Fix'],
    // 'Speaking': ['Speaking Videos'], // no need to include speaking tiles
    'Reading': ['Skimming', 'Scanning', 'Inference', 'Speed Read'],
    'Memory': ['Card Match', 'Pattern Memory', 'Tile Flip', 'Simon Says'],
    'Math': ['Quick Add', 'Times Table', 'Number Rush', 'Puzzle Math'],
  };

  final Map<String, WidgetBuilder> gameRoutes = {
    'Brevity': (_) => HomePage(),
    'Commas': (_) => PuzzleApp(),
    'Detail': (_) => MemoryGameScreen(),
    'Grammar Fix': (_) => SokobanGame(levelIndex: 0),
    'Skimming': (_) => NumberGameApp(),
    //'Scanning': (_) => NumberPuzzleGame(),
    // No need to add Speaking tile route here
  };

  @override
  Widget build(BuildContext context) {
    List<String> currentGames = gameMap[selectedCategory] ?? [];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Games',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    'SHOW GAME STATISTICS',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Spacer(),
                  Switch(
                    value: showStats,
                    onChanged: (value) {
                      setState(() {
                        showStats = value;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  String cat = categories[index];
                  bool isSelected = selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) {
                        if (cat == 'Speaking') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => YouTubeLinksPlayer(),
                            ),
                          );
                        } else {
                          setState(() {
                            selectedCategory = cat;
                          });
                        }
                      },
                      selectedColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                      ),
                      backgroundColor: Colors.grey[800],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  itemCount: currentGames.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final title = currentGames[index];
                    return InkWell(
                      onTap: () {
                        final builder = gameRoutes[title];
                        if (builder != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: builder),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Game "$title" not implemented yet',
                              ),
                            ),
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            title,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
