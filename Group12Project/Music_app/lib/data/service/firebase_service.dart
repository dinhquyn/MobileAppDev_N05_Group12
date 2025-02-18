import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/song.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Lưu danh sách yêu thích
  Future<void> saveFavorites(String userId, List<Song> favorites) async {
    final favoritesData = favorites.map((song) => song.toJson()).toList();
    await _firestore
        .collection('users')
        .doc(userId)
        .set({'favorites': favoritesData}, SetOptions(merge: true));
  }

  // Lấy danh sách yêu thích
  Future<List<Song>> getFavorites(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists || !doc.data()!.containsKey('favorites')) return [];
    
    final favoritesData = doc.data()!['favorites'] as List;
    return favoritesData.map((data) => Song.fromJson(data)).toList();
  }

  // Đăng nhập
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Đăng ký
  Future<UserCredential> signUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Lưu thông tin chi tiết của user
  Future<void> saveUserData(String userId, Map<String, dynamic> userData) async {
    await _firestore.collection('users').doc(userId).set({
      'email': userData['email'],
      'displayName': userData['displayName'],
      'createdAt': FieldValue.serverTimestamp(),
      'favorites': [], // Danh sách bài hát yêu thích
      'playlists': [], // Playlist của user
    });
  }
} 