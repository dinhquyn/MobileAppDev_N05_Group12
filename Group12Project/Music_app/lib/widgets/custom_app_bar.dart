import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Danh sách bài hát'),
      backgroundColor: Colors.blueGrey,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
