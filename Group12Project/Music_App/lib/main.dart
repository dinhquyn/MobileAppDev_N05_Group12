import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MusicApp(),
    );
  }
}

class MusicApp extends StatefulWidget {
  const MusicApp({super.key});

  @override
  State<MusicApp> createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  final List<String> _songs = [
    "Song 1",
    "Song 2",
    "Song 3",
    "Song 4",
    "Song 5",
  ];

  int _currentSongIndex = 0;
  bool _isPlaying = false;

  // Function to toggle play/pause
  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  // Function to go to the next song
  void _nextSong() {
    setState(() {
      _currentSongIndex = (_currentSongIndex + 1) % _songs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music App",
        style: TextStyle(
          color: Colors.white)
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Row(
        children: [
          // Left side: List of songs
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: _songs.length,
                itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_songs[index]),
                  selected: _currentSongIndex == index,
                  selectedTileColor: Colors.blue[100],
                  onTap: () {
                    setState(() {
                      _currentSongIndex = index;
                    });
                  },
                );
              },
            ),
          ),
          // Right side: Music Player
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Music disc illustration
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue[300],
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Current song information
                  Text(
                    _songs[_currentSongIndex],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Seek bar
                  Slider(
                    value: 0, // Mock value, can integrate with a real player
                    onChanged: (value) {},
                    min: 0,
                    max: 1,
                  ),
                  const SizedBox(height: 10),
                  // Next button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        // onPressed: _togglePlayPause,
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        // onPressed: _nextSong,
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: const Icon(
                          Icons.skip_next,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
