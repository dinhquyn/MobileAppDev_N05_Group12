import 'package:flutter/material.dart';

class AccountTab extends StatelessWidget {
  const AccountTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // User Name
                    const Text(
                      'Đinh Xuân Quyền',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Email
                    Text(
                      'dinhquyen888@gmail.com',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(),

              // Account Settings
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Thông tin cá nhân'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to profile edit
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.favorite_border),
                    title: const Text('Bài hát yêu thích'),
                    trailing: const Text('28'),
                    onTap: () {
                      // TODO: Navigate to favorites
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.playlist_play),
                    title: const Text('Playlist của tôi'),
                    trailing: const Text('4'),
                    onTap: () {
                      // TODO: Navigate to playlists
                    },
                  ),
                  
                  const Divider(),
                  
                  // Account Security
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Bảo mật tài khoản'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to security settings
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications_none),
                    title: const Text('Thông báo'),
                    trailing: Switch(
                      value: true,
                      onChanged: (bool value) {
                        // TODO: Toggle notifications
                      },
                    ),
                  ),
                  
                  const Divider(),
                  
                  // Support & About
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Trợ giúp & Hỗ trợ'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to help
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('Về ứng dụng'),
                    trailing: const Text('v1.0.0'),
                    onTap: () {
                      // TODO: Show about dialog
                    },
                  ),
                  
                  const Divider(),
                  
                  // Logout
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    title: Text(
                      'Đăng xuất',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    onTap: () {
                      // TODO: Handle logout
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
