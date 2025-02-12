import 'package:flutter/material.dart';
import '../models/song.dart';

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
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 33, 212, 243),
                    width: 5,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 193, 223, 238),
                        border: Border.all(
                          color: Colors.black87,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        song.songname,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 193, 223, 238),
                        border: Border.all(
                          color: Colors.black87,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Tác giả: ${song.artist}\n'
                        'Ca sĩ: ${song.singer}\n',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: double.infinity, // Chiếm toàn bộ chiều rộng có thể
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 193, 223, 238),
                        border: Border.all(
                          color: Colors.black87,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20), // Khoảng cách bên trong viền đỏ
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red, // Viền đỏ
                              width: 3,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star, color: Colors.grey),
                              Icon(Icons.star, color: Colors.grey),
                              Icon(Icons.star, color: Colors.grey),
                              Icon(Icons.star, color: Colors.grey),
                              Icon(Icons.star_border, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                '${song.review} Reviews',
                                style: TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: double.infinity, // Chiếm toàn bộ chiều rộng có thể
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 193, 223, 238),
                        border: Border.all(
                          color: Colors.black87,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20), // Khoảng cách bên trong viền đỏ
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red, // Viền đỏ
                              width: 3,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildInfoColumn(Icons.access_time, 'Thời lượng:', '${song.time} phút'),
                              _buildInfoColumn(Icons.calendar_today, 'Phát hành:', '${song.date}'),
                              _buildInfoColumn(Icons.headphones, 'Lượt nghe:', '${song.view}'),
                            ],
                          ),
                        ),
                      ),
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
                  song.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
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
