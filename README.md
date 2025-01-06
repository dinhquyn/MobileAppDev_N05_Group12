## Hình Ảnh app
![image](https://github.com/user-attachments/assets/25f762a4-580f-49fd-9d4d-5bc3c97cd9fb)
![Uploading image.png…]()
![image](https://github.com/user-attachments/assets/1dad8b72-64b3-4e3a-aa6e-a19cfb4cb802)



## @ Code chính của class User: user.dart
class User {
  String username;
  String password;
  String role;

  User({required this.username, required this.password, required this.role});
}
## @ Object của class User: user_data.dart
import '../models/user.dart';

final List<User> users = [
  User(username: 'Phan Văn Tình', password: 'admin123', role: 'Admin'),
  User(username: 'Đinh Xuân Quyền', password: '123456', role: 'User'),
  User(username: 'Nguyễn Văn A', password: 'password2', role: 'User'),
  User(username: 'Phùng Hải Anh', password: 'manager@123', role: 'Manager'),
  User(username: 'Ẩn danh', password: 'guest123', role: 'Guest'),
];
Hiển thị trên màn hình : home_screen.dart
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
## @Code hàm main: Main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

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
