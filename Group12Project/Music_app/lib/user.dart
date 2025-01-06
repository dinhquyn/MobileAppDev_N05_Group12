class User {
  String username;
  String password;
  String role;

  User({required this.username, required this.password, required this.role});

  @override
  String toString() {
    return 'User(username: $username, role: $role)';
  }
}
