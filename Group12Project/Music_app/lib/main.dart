import 'package:flutter/material.dart';

import 'user_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

  // Danh sách bài hát
  final List<Map<String, String>> _songs = [
    {'title': 'Em của ngày hôm qua', 'artist': 'Sơn Tùng MTP'},
    {'title': 'Mất kết nối', 'artist': 'Dương Domic'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang chủ'),
        backgroundColor: Colors.blueGrey,
      ),
      body: _currentIndex == 0 ? _buildSongList() : _buildUserGrid(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
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
            label: 'Người dùng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
      ),
    );
  }

  // Widget hiển thị danh sách bài hát
  Widget _buildSongList() {
    return ListView.builder(
      itemCount: _songs.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: Icon(Icons.music_note, color: Colors.blue),
            title: Text(
              _songs[index]['title']!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              _songs[index]['artist']!,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            trailing: Icon(Icons.play_arrow, color: Colors.green),
            onTap: () {},
          ),
        );
      },
    );
  }

  // Widget danh sách người dùng
  Widget _buildUserGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.6,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 5,
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.person, size: 50, color: Colors.blue),
              SizedBox(height: 10),
              Text(
                users[index].username,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Role: ${users[index].role}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        );
      },
    );
  }
}
