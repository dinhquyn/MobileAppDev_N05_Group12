import 'package:flutter/material.dart';
import '../../data/model/song.dart';
import '../home/viewmodel.dart';

class DiscoveryTab extends StatefulWidget {
  const DiscoveryTab({super.key});

  @override
  State<DiscoveryTab> createState() => _DiscoveryTabState();
}

class _DiscoveryTabState extends State<DiscoveryTab> {
  List<Song> songs = [];
  late MusicAppViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MusicAppViewModel();
    _viewModel.loadSongs();
    _observeData();
  }

  void _observeData() {
    _viewModel.songStream.stream.listen((songList) {
      setState(() {
        songs.addAll(songList);
      });
    });
  }

  @override
  void dispose() {
    _viewModel.songStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: songs.isEmpty 
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm bài hát, nghệ sĩ...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),

                    // Categories
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                      child: Text(
                        'Thể loại',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        children: [
                          _buildCategoryCard(context, 'Nhạc Pop', Icons.music_note, Colors.blue),
                          _buildCategoryCard(context, 'Rock', Icons.queue_music, Colors.red),
                          _buildCategoryCard(context, 'Jazz', Icons.piano, Colors.orange),
                          _buildCategoryCard(context, 'Classical', Icons.music_note, Colors.purple),
                          _buildCategoryCard(context, 'Hip Hop', Icons.headphones, Colors.green),
                        ],
                      ),
                    ),

                    // Trending
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 24, bottom: 8),
                      child: Text(
                        'Thịnh hành',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    _buildMusicList(songs.take(5).toList()),

                    // New Releases
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 24, bottom: 8),
                      child: Text(
                        'Mới phát hành',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    _buildMusicList(songs.skip(5).take(5).toList()),

                    // For You
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 24, bottom: 8),
                      child: Text(
                        'Dành cho bạn',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    _buildMusicList(songs.skip(10).take(5).toList()),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.8),
              color.withOpacity(0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMusicList(List<Song> songList) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: songList.length,
        itemBuilder: (context, index) {
          final song = songList[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: Container(
              width: 160,
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Album Art
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      song.image,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset(
                            'assets/ITunes_logo.svg.png',
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Song Title
                  Text(
                    song.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Artist Name
                  Text(
                    song.artist,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}