import 'package:flutter/material.dart';
import '../models/user.dart';

class UserGridScreen extends StatelessWidget {
  final List<User> users;

  UserGridScreen({required this.users});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Hiển thị 3 cột
          crossAxisSpacing: 10, // Khoảng cách ngang
          mainAxisSpacing: 10, // Khoảng cách dọc
        ),
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 40, // Kích thước biểu tượng
                    color: Colors.blue, // Màu sắc biểu tượng
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${users[index].username}', // Hiển thị tên người dùng
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700]), // Style cho tên người dùng
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Role: ${users[index].role}', // Hiển thị vai trò người dùng
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
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
