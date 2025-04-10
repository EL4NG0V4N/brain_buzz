import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class YouTubeLinksPlayer extends StatefulWidget {
  @override
  _YouTubeLinksPlayerState createState() => _YouTubeLinksPlayerState();
}

class _YouTubeLinksPlayerState extends State<YouTubeLinksPlayer>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> videos = [
    {'id': '6E7i_7Mr_5c', 'title': 'Confidence Booster'},
    {'id': 'N20jOJDYyYA', 'title': 'Public Speaking Tips'},
    {'id': 'q47Vh3X0zms', 'title': 'Speak Fluently in English'},
    {'id': 'JbLAGpQ9RXg', 'title': 'Communication Mastery'},
    {'id': 'NzJ_2XOERjM', 'title': 'Practice with Native Tone'},
  ];

  Set<String> favorites = {};
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('favoriteVideos') ?? [];
    setState(() {
      favorites = saved.toSet();
    });
  }

  Future<void> _saveFavorites() async {
    await prefs.setStringList('favoriteVideos', favorites.toList());
  }

  void _toggleFavorite(String id) {
    setState(() {
      if (favorites.contains(id)) {
        favorites.remove(id);
      } else {
        favorites.add(id);
      }
      _saveFavorites();
    });
  }

  void _launchYouTube(String videoId) async {
    final url = 'https://youtu.be/$videoId';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch YouTube')));
    }
  }

  Widget _buildAnimatedCard(int index, Map<String, String> video) {
    final videoId = video['id']!;
    final title = video['title']!;
    final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';
    final isFavorite = favorites.contains(videoId);

    return TweenAnimationBuilder(
      tween: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)),
      duration: Duration(milliseconds: 600 + index * 120),
      curve: Curves.easeOut,
      builder: (context, offset, child) {
        return Transform.translate(
          offset: offset,
          child: AnimatedOpacity(
            opacity: 1,
            duration: Duration(milliseconds: 600),
            child: GestureDetector(
              onTap: () => _launchYouTube(videoId),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 124, 91, 223),
                      Colors.black,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(22),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: thumbnailUrl,
                        width: 120,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: GestureDetector(
                          onTap: () => _toggleFavorite(videoId),
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            transitionBuilder:
                                (child, animation) => ScaleTransition(
                                  scale: animation,
                                  child: child,
                                ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              key: ValueKey(isFavorite),
                              color:
                                  isFavorite
                                      ? Colors.pinkAccent
                                      : Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Colors.deepPurple.shade900],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("🎤 Speaking Videos"),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.black,
        ),
        body: ListView.builder(
          itemCount: videos.length,
          itemBuilder: (context, index) {
            return _buildAnimatedCard(index, videos[index]);
          },
        ),
      ),
    );
  }
}
