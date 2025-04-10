import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MaterialApp(home: HomePage()));

class MyColor {
  static int gridBackground = 0xFFa2917d;
  static int gridColorTwoFour = 0xFFeee4da;
  static int fontColorTwoFour = 0xFF766c62;
  static int emptyGridBackground = 0xFFbfafa0;
  static int gridColorEightSixtyFourTwoFiftySix = 0xFFf5b27e;
  static int gridColorOneTwentyEightFiveOneTwo = 0xFFf77b5f;
  static int gridColorSixteenThirtyTwoOneZeroTwoFour = 0xFFecc402;
  static int gridColorWin = 0xFF60d992;
  static int transparentWhite = 0x80FFFFFF;
}

class Tile extends StatelessWidget {
  final String number;
  final double width, height, size;
  final int color;

  Tile(this.number, this.width, this.height, this.color, this.size);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Color(color),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.bold,
            color: Color(MyColor.fontColorTwoFour),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<int>> grid = [];
  List<List<int>> gridNew = [];
  late SharedPreferences sharedPreferences;
  int score = 0;
  bool isgameOver = false;
  bool isgameWon = false;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  void initGame() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      grid = blankGrid();
      gridNew = blankGrid();
      addNumber(grid);
      addNumber(grid);
    });
  }

  List<Widget> getGrid(double width, double height) {
    List<Widget> tiles = [];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        int num = grid[i][j];
        String number = num > 0 ? "$num" : "";
        int color;
        if (num == 0)
          color = MyColor.emptyGridBackground;
        else if (num == 2 || num == 4)
          color = MyColor.gridColorTwoFour;
        else if ([8, 64, 256].contains(num))
          color = MyColor.gridColorEightSixtyFourTwoFiftySix;
        else if ([16, 32, 1024].contains(num))
          color = MyColor.gridColorSixteenThirtyTwoOneZeroTwoFour;
        else if ([128, 512].contains(num))
          color = MyColor.gridColorOneTwentyEightFiveOneTwo;
        else
          color = MyColor.gridColorWin;

        double size =
            number.length <= 2 ? 40.0 : (number.length == 3 ? 30.0 : 20.0);

        tiles.add(Tile(number, width, height, color, size));
      }
    }
    return tiles;
  }

  void handleGesture(int direction) {
    bool flipped = false, rotated = false;
    if (direction == 0 || direction == 1) {
      grid = transposeGrid(grid);
      rotated = true;
    }
    if (direction == 0 || direction == 3) {
      grid = flipGrid(grid);
      flipped = true;
    }

    List<List<int>> past = copyGrid(grid);
    for (int i = 0; i < 4; i++) {
      var result = operate(grid[i], score, sharedPreferences);
      score = result[0];
      grid[i] = result[1];
    }

    if (flipped) grid = flipGrid(grid);
    if (rotated) grid = transposeGrid(grid);

    if (!compare(past, grid)) return;

    setState(() {
      grid = addNumber(grid);
      isgameOver = isGameOver(grid);
      isgameWon = isGameWon(grid);
    });
  }

  Future<String> getHighScore() async {
    int? score = sharedPreferences.getInt('high_score');
    return (score ?? 0).toString();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double gridWidth = (width - 80) / 4;
    double gridHeight = gridWidth;
    double height = 30 + (gridHeight * 4) + 10;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("2048"),
        centerTitle: true,
        backgroundColor: Color(MyColor.gridBackground),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              buildScoreBox(),
              Container(
                height: height,
                color: Color(MyColor.gridBackground),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onVerticalDragEnd: (details) {
                          if (details.primaryVelocity! < 0)
                            handleGesture(0);
                          else if (details.primaryVelocity! > 0)
                            handleGesture(1);
                        },
                        onHorizontalDragEnd: (details) {
                          if (details.primaryVelocity! > 0)
                            handleGesture(2);
                          else if (details.primaryVelocity! < 0)
                            handleGesture(3);
                        },
                        child: GridView.count(
                          crossAxisCount: 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: getGrid(gridWidth, gridHeight),
                        ),
                      ),
                    ),
                    if (isgameOver || isgameWon)
                      Container(
                        height: height,
                        color: Color(MyColor.transparentWhite),
                        child: Center(
                          child: Text(
                            isgameOver ? 'Game Over!' : 'You Won!',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(MyColor.gridBackground),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              buildControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildScoreBox() => Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      width: 200,
      height: 80,
      decoration: BoxDecoration(
        color: Color(MyColor.gridBackground),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Score', style: TextStyle(color: Colors.white70)),
          Text(
            '$score',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    ),
  );

  Widget buildControls() => Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white70),
          iconSize: 35,
          onPressed: () {
            setState(() {
              grid = blankGrid();
              gridNew = blankGrid();
              addNumber(grid);
              addNumber(grid);
              score = 0;
              isgameOver = false;
              isgameWon = false;
            });
          },
          color: Color(MyColor.gridBackground),
        ),
        Column(
          children: [
            const Text('High Score', style: TextStyle(color: Colors.white70)),
            FutureBuilder<String>(
              future: getHighScore(),
              builder:
                  (ctx, snapshot) => Text(
                    snapshot.data ?? '0',
                    style: const TextStyle(color: Colors.white),
                  ),
            ),
          ],
        ),
      ],
    ),
  );
}

List<List<int>> blankGrid() => List.generate(4, (_) => List.filled(4, 0));

List<List<int>> addNumber(List<List<int>> grid) {
  List<Point> options = [];
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      if (grid[i][j] == 0) options.add(Point(i, j));
    }
  }
  if (options.isNotEmpty) {
    final index =
        options[DateTime.now().millisecondsSinceEpoch % options.length];
    grid[index.x][index.y] =
        (DateTime.now().millisecondsSinceEpoch % 10 < 9) ? 2 : 4;
  }
  return grid;
}

List<List<int>> flipGrid(List<List<int>> grid) =>
    grid.map((row) => row.reversed.toList()).toList();

List<List<int>> transposeGrid(List<List<int>> grid) {
  List<List<int>> newGrid = List.generate(4, (_) => List.filled(4, 0));
  for (int i = 0; i < 4; i++)
    for (int j = 0; j < 4; j++) newGrid[i][j] = grid[j][i];
  return newGrid;
}

List<List<int>> copyGrid(List<List<int>> grid) {
  return List.generate(grid.length, (i) => List<int>.from(grid[i]));
}

bool compare(List<List<int>> a, List<List<int>> b) {
  for (int i = 0; i < 4; i++)
    for (int j = 0; j < 4; j++) if (a[i][j] != b[i][j]) return true;
  return false;
}

List operate(List<int> row, int score, SharedPreferences pref) {
  row = slide(row);
  var result = combine(row, score, pref);
  score = result[0];
  row = slide(result[1]);
  return [score, row];
}

List<int> slide(List<int> row) {
  List<int> arr = row.where((v) => v != 0).toList();
  while (arr.length < 4) arr.insert(0, 0);
  return arr;
}

List combine(List<int> row, int score, SharedPreferences pref) {
  for (int i = 3; i > 0; i--) {
    if (row[i] == row[i - 1] && row[i] != 0) {
      row[i] *= 2;
      score += row[i];
      row[i - 1] = 0;
    }
  }
  int high = pref.getInt('high_score') ?? 0;
  if (score > high) pref.setInt('high_score', score);
  return [score, row];
}

bool isGameWon(List<List<int>> grid) => grid.any((row) => row.contains(2048));

bool isGameOver(List<List<int>> grid) {
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      if (grid[i][j] == 0) return false;
      if (i < 3 && grid[i][j] == grid[i + 1][j]) return false;
      if (j < 3 && grid[i][j] == grid[i][j + 1]) return false;
    }
  }
  return true;
}

class Point {
  final int x, y;
  Point(this.x, this.y);
}
