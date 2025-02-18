import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/service/firebase_service.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  final FirebaseService _firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        currentUser = user;
      });
    });
  }

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
                    // User Info
                    if (currentUser != null) ...[
                      Text(
                        currentUser?.displayName ?? 'Người dùng',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentUser?.email ?? '',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                    ] else ...[
                      ElevatedButton(
                        onPressed: () => _showLoginDialog(context),
                        child: const Text('Đăng nhập'),
                      ),
                    ],
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
                  if (currentUser != null)
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
                      onTap: () async {
                        await _firebaseService.signOut();
                        setState(() {
                          currentUser = null;
                        });
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

  void _showLoginDialog(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    bool isLogin = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isLogin ? 'Đăng nhập' : 'Đăng ký'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(isLogin ? 'Đăng ký tài khoản mới' : 'Đã có tài khoản'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (isLogin) {
                    await _firebaseService.signIn(
                      emailController.text,
                      passwordController.text,
                    );
                  } else {
                    await _firebaseService.signUp(
                      emailController.text,
                      passwordController.text,
                    );
                  }
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
              child: Text(isLogin ? 'Đăng nhập' : 'Đăng ký'),
            ),
          ],
        ),
      ),
    );
  }
}
