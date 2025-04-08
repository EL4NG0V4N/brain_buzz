import 'package:flutter/material.dart';

class HowDidYouHearScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> options = [
      "Friend or family member",
      "Google",
      "News, article, or blog",
      "Social media or online ads",
      "TV",
      "Play Store",
      "Other",
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              // Handle skip action
            },
            child: Text("Skip", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              "How did you hear about us?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HowDidYouHearScreen(),
                          ),
                        );
                      },
                      child: Text(
                        options[index],
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
