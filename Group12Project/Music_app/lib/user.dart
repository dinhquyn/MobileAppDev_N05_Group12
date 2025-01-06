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

List<User> userList = [
  User(username: "Thanh", password: "1234", role: "Admin"),
  User(username: "Dung", password: "5678", role: "Editor"),
  User(username: "Viet", password: "90qw", role: "Viewer"),
  User(username: "Vinh", password: "erty", role: "Viewer"),
  User(username: "Hieu", password: "uiop", role: "Viewer"),
];