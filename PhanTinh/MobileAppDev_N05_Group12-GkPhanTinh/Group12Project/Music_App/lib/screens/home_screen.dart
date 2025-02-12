import 'package:flutter/material.dart';
import 'song_list_screen.dart';
import 'user_grid_screen.dart';
import '../data/user_data.dart'; // Import dữ liệu người dùng
import '../data/song_data.dart'; // Import danh sách bài hát

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
        title: Text(
          _currentIndex == 0
              ? 'Trang chủ'
              : _currentIndex == 1
                  ? 'Danh sách bài hát'
                  : 'Danh sách người dùng',
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: _currentIndex == 0
          ? buildHomeScreen() // Giao diện Trang chủ
          : _currentIndex == 1
              ? SongListScreen(songs: songs) // Truyền dữ liệu bài hát
              : UserGridScreen(users: users), // Truyền dữ liệu người dùng
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
            label: 'Bài hát',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Người dùng',
          ),
        ],
      ),
    );
  }

  Widget buildHomeScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Chào mừng bạn đến với ứng dụng quản lý',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Icon(
              Icons.dashboard,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'Bạn có thể duyệt danh sách bài hát hoặc người dùng bằng cách sử dụng thanh điều hướng bên dưới.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
