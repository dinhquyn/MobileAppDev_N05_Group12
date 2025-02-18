import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/song.dart';

class SongService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy danh sách bài hát từ Firestore
  Future<List<Song>> getSongs() async {
    try {
      print('Đang lấy dữ liệu từ Firestore...');
      final QuerySnapshot snapshot = await _firestore.collection('songs').get();
      print('Số lượng bài hát từ Firestore: ${snapshot.docs.length}');
      
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Song.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy dữ liệu từ Firestore: $e');
      return [];
    }
  }

  // Upload danh sách bài hát lên Firestore (chỉ dùng 1 lần)
  Future<void> uploadSongs(List<Song> songs) async {
    try {
      final batch = _firestore.batch();
      
      for (var song in songs) {
        final docRef = _firestore.collection('songs').doc();
        batch.set(docRef, song.toJson());
      }

      await batch.commit();
      print('Successfully uploaded ${songs.length} songs');
    } catch (e) {
      print('Error in uploadSongs: $e');
      rethrow;
    }
  }
} 