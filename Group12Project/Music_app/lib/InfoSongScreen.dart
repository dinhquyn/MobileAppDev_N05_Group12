import 'package:flutter/material.dart';
import 'song.dart';

class InfoSongScreen extends StatelessWidget {
  final Song song;

  InfoSongScreen({required this.song});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double imageWidth = screenWidth * 0.7;
    double imageHeight = screenHeight;

    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin bài hát'),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 32),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 33, 212, 243),
                      width: 5,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        song.songname,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tác giả: ${song.artirst}\n'
                        'Ca sĩ: ${song.singer}\n'
                        'Các thông tin khác:...',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber),
                          Icon(Icons.star, color: Colors.amber),
                          Icon(Icons.star, color: Colors.amber),
                          Icon(Icons.star, color: Colors.amber),
                          Icon(Icons.star_border, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            '${song.review} Reviews',
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildInfoColumn(Icons.access_time, 'Thời lượng:', '${song.time} phút'),
                          _buildInfoColumn(Icons.calendar_today, 'Phát hành:', '${song.date}'),
                          _buildInfoColumn(Icons.headphones, 'Lượt nghe:', '${song.view}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Center(
                child: Container(
                  width: imageWidth,
                  height: imageHeight,
                  child: Image.asset(
                    '${song.image}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Info Columns
  Widget _buildInfoColumn(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.green, size: 28),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
