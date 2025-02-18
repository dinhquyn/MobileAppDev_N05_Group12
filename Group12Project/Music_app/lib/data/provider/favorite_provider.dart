import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../data/model/song.dart';
import '../../data/service/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Song> _favoriteSongs = [];
  List<Song> get favoriteSongs => _favoriteSongs;

  FavoriteProvider() {
    _initializeFavorites();
  }

  Future<void> _initializeFavorites() async {
    final user = _auth.currentUser;
    if (user != null) {
      await loadFavorites(user.uid);
    } else {
      await _loadFromLocal();
    }
  }

  Future<void> _loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('favorites') ?? [];
    _favoriteSongs = favoritesJson
        .map((songJson) => Song.fromJson(json.decode(songJson)))
        .toList();
    notifyListeners();
  }

  Future<void> _saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = _favoriteSongs
        .map((song) => json.encode(song.toJson()))
        .toList();
    await prefs.setStringList('favorites', favoritesJson);
  }

  bool isFavorite(Song song) {
    return _favoriteSongs.any((s) => s.source == song.source);
  }

  Future<void> loadFavorites(String userId) async {
    _favoriteSongs = await _firebaseService.getFavorites(userId);
    notifyListeners();
  }

  Future<void> toggleFavorite(Song song) async {
    final user = _auth.currentUser;
    if (user != null) {
      await toggleFavoriteFirebase(song, user.uid);
    } else {
      toggleFavoriteLocal(song);
    }
  }

  Future<void> toggleFavoriteFirebase(Song song, String userId) async {
    if (isFavorite(song)) {
      _favoriteSongs.removeWhere((s) => s.source == song.source);
    } else {
      _favoriteSongs.add(song);
    }
    await _firebaseService.saveFavorites(userId, _favoriteSongs);
    notifyListeners();
  }

  void toggleFavoriteLocal(Song song) {
    if (isFavorite(song)) {
      _favoriteSongs.removeWhere((s) => s.source == song.source);
    } else {
      _favoriteSongs.add(song);
    }
    _saveToLocal();
    notifyListeners();
  }
} 