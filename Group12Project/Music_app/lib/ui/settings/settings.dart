import 'package:appdev/ui/settings/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: SwitchListTile(
          title: const Text("Chế độ tối"),
          subtitle: const Text("Bật để chuyển sang chủ đề tối, tắt để sử dụng chủ đề sáng"),
          value: themeProvider.isDarkMode,
          onChanged: (bool value) {
            themeProvider.toggleTheme(value);
          },
        ),
      ),
    );
  }
}
