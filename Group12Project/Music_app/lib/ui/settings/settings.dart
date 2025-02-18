import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          body: SafeArea(
            child: ListView(
              children: [
                SwitchListTile(
                  title: const Text('Chế độ tối'),
                  subtitle: const Text('Bật/tắt giao diện tối'),
                  value: themeProvider.isDarkMode,
                  onChanged: (bool value) {
                    themeProvider.toggleTheme();
                  },
                ),
                const Divider(),
                
                ListTile(
                  title: const Text('Thông báo'),
                  subtitle: const Text('Quản lý thông báo ứng dụng'),
                  trailing: const Icon(Icons.notifications),
                  onTap: () {
                    // Xử lý khi nhấn vào mục thông báo
                  },
                ),
                
                ListTile(
                  title: const Text('Chất lượng âm thanh'),
                  subtitle: const Text('Điều chỉnh chất lượng phát nhạc'),
                  trailing: const Icon(Icons.music_note),
                  onTap: () {
                    // Xử lý khi nhấn vào mục chất lượng âm thanh
                  },
                ),
                
                ListTile(
                  title: const Text('Đồng bộ'),
                  subtitle: const Text('Quản lý đồng bộ dữ liệu'),
                  trailing: const Icon(Icons.sync),
                  onTap: () {
                    // Xử lý khi nhấn vào mục đồng bộ
                  },
                ),
                
                ListTile(
                  title: const Text('Thông tin ứng dụng'),
                  subtitle: const Text('Phiên bản 1.0.0'),
                  trailing: const Icon(Icons.info),
                  onTap: () {
                    // Xử lý khi nhấn vào mục thông tin
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
