import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text('Layout Flutter'),
        // ),
        body: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.blueGrey,
              width: double.infinity,
              child: Center(
                child: Text(
                  'Logo',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),

            // Body
            Expanded(
              child: Container(
                color: Colors.grey[200],
                child: Center(
                  child: Text(
                    'Body Content',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),

            // Footer
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.blueGrey,
              width: double.infinity,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround, // Căn đều các text
                children: [
                  Text(
                    'Trang chủ',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    'Danh sách phát nhạc',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    'Cá nhân',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    'Cài đặt',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
