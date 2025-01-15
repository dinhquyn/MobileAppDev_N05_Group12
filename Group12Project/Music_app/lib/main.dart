import 'package:flutter/material.dart';
import 'InfoSongScreen.dart';
import 'song.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách bài hát'),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.builder(
        itemCount: songList.length,
        itemBuilder: (context, index) {
          final song = songList[index];
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
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue, // Màu mục được chọn
        unselectedItemColor: Colors.grey, // Màu mục không được chọn
        backgroundColor: Colors.white, // Màu nền thanh điều hướng
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.queue_music),
            label: 'Danh sách phát nhạc',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Cá nhân',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
      ),
    );
  }
}
