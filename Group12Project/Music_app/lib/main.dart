import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class RecipeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin bài hát'),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Em của ngày hôm qua',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tác giả: Sơn Tùng MTP\n'
                      'Ca sĩ: Sơn Tùng MTP\n'
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
                          '170 Reviews',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoColumn(Icons.access_time, 'Thời lượng:', '3:45 phút'),
                        _buildInfoColumn(Icons.calendar_today, 'Phát hành:', '2014'),
                        _buildInfoColumn(Icons.headphones, 'Lượt nghe:', '10M+'),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                child: Center(
                  child: Image.asset(
                    'assets/sontungmtp.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RecipeScreen(),
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
        title: Text('Danh sách bài hát'),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.builder(
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
