import 'package:appdev/data/source/source.dart';
import '../model/song.dart';

abstract interface class Repository {
  Future<List<Song>?> loadData();
}

class DefaultRepository implements Repository {
  final _localDataSource = LocalDataSource();
  final _remoteDataSource = RemoteDataSource();

  @override
  Future<List<Song>?> loadData() async {
    // Lấy dữ liệu từ remote trước
    final remoteSongs = await _remoteDataSource.loadData();
    if (remoteSongs != null) {
      return remoteSongs;
    }
    
    // Nếu remote không có dữ liệu, lấy dữ liệu từ local
    final localSongs = await _localDataSource.loadData();
    return localSongs;
  }
}
