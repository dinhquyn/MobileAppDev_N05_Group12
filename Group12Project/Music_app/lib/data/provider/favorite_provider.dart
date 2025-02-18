import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../data/model/song.dart';

class FavoriteProvider with ChangeNotifier {
  List<Song> _favoriteSongs = [];
  List<Song> get favoriteSongs => _favoriteSongs;

  FavoriteProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('favorites') ?? [];
    _favoriteSongs = favoritesJson
        .map((songJson) => Song.fromJson(json.decode(songJson)))
        .toList();
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = _favoriteSongs
        .map((song) => json.encode(song.toJson()))
        .toList();
    await prefs.setStringList('favorites', favoritesJson);
  }

  bool isFavorite(Song song) {
    return _favoriteSongs.any((s) => s.source == song.source);
  }

  void toggleFavorite(Song song) {
    if (isFavorite(song)) {
      _favoriteSongs.removeWhere((s) => s.source == song.source);
    } else {
      _favoriteSongs.add(song);
    }
    _saveFavorites();
    notifyListeners();
  }
} 