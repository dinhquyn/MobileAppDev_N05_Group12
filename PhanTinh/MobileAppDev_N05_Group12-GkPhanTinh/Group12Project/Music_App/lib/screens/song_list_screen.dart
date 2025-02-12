import 'package:flutter/material.dart';

class SongListScreen extends StatelessWidget {
  final List<Map<String, String>> songs;

  SongListScreen({required this.songs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: Icon(Icons.music_note, color: Colors.blue),
            title: Text(
              songs[index]['title']!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              songs[index]['artist']!,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            trailing: Icon(Icons.play_arrow, color: Colors.green),
            onTap: () {},
          ),
        );
      },
    );
  }
}
