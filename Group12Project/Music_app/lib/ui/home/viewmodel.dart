import 'dart:async';
import '../../data/model/song.dart';
import '../../data/service/song_service.dart';

class MusicAppViewModel {
  final _songService = SongService();
  final songStream = StreamController<List<Song>>();

  Future<void> loadSongs() async {
    try {
      print('Bắt đầu tải danh sách bài hát...');
      final songs = await _songService.getSongs();
      print('Đã tải ${songs.length} bài hát');
      songStream.add(songs);
    } catch (e) {
      print('Lỗi khi tải bài hát: $e');
      songStream.addError(e);
    }
  }

  // Hàm upload data (chỉ chạy 1 lần)
  Future<void> uploadInitialData() async {
    // Đọc từ file JSON local
    // final String jsonString = await rootBundle.loadString('assets/songs.json');
    // final List<dynamic> jsonData = json.decode(jsonString);
    // final List<Song> songs = jsonData.map((item) => Song.fromJson(item)).toList();
    
    // Upload lên Firestore
    // await _songService.uploadSongs(songs);
  }
}