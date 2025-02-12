import 'package:flutter/material.dart';

import 'InfoSongScreen.dart';
import '../models/song.dart';

class SongListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: songList.length,
      itemBuilder: (context, index) {
        final song = songList[index];
        return SongCard(song: song);
      },
    );
  }
}

class SongCard extends StatelessWidget {
  final Song song;

  SongCard({required this.song});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(Icons.music_note, color: Colors.blue),
        title: Text(
          song.songname,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          song.singer,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        trailing: Icon(Icons.play_arrow, color: Colors.green),
        onTap: () {
          // Điều hướng tới InfoSongScreen và truyền dữ liệu bài hát
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InfoSongScreen(song: song),
            ),
          );
        },
      ),
    );
  }
}
