import 'package:flutter/material.dart';
import 'game_detail_screen.dart'; // Ensure this file exists

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
    'Speaking': ['Pronunciation', 'Fluency', 'Tone Match', 'Echo Game'],
    'Reading': ['Skimming', 'Scanning', 'Inference', 'Speed Read'],
    'Memory': ['Card Match', 'Pattern Memory', 'Tile Flip', 'Simon Says'],
    'Math': ['Quick Add', 'Times Table', 'Number Rush', 'Puzzle Math'],
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
            // Title
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

            // Toggle switch
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

            // Category Chips
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
                        setState(() {
                          selectedCategory = cat;
                        });
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

            // Game Grid (2 columns, 4 total boxes)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  itemCount: currentGames.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 boxes per row
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final title = currentGames[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GameDetailScreen(gameTitle: title),
                          ),
                        );
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
