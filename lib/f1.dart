import 'package:brain_buzz_/profile_dart';
import 'package:flutter/material.dart';
import 'game.dart'; // Make sure this import path matches your project structure

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Nav App',
      theme: ThemeData(
        brightness: Brightness.dark, // Optional: match GamesScreen theme
        primarySwatch: Colors.blue,
      ),
      home: BottomNavScreen(),
    );
  }
}

class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Center(child: Text('Today', style: TextStyle(fontSize: 24))),
    Center(child: Text('Performance', style: TextStyle(fontSize: 24))),
    GamesScreen(), // Replace placeholder with actual screen
    Center(child: Text('Notifications', style: TextStyle(fontSize: 24))),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<BottomNavigationBarItem> _bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Today'),
    BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Performance'),
    BottomNavigationBarItem(icon: Icon(Icons.videogame_asset), label: 'Games'),
    BottomNavigationBarItem(
      icon: Icon(Icons.notifications),
      label: 'Notification',
    ),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.cyanAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
