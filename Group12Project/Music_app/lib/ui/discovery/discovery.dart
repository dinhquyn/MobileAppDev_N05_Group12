import 'package:appdev/ui/now_playing/playing.dart';
import 'package:flutter/material.dart';
import 'package:appdev/data/model/song.dart';

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({Key? key}) : super(key: key);

  @override
  _DiscoveryPageState createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  /// Phương thức refresh: giả lập delay và gọi setState() để reload giao diện
  Future<void> _refreshFavorites() async {
    // Giả lập quá trình tải dữ liệu (ví dụ từ API hoặc cơ sở dữ liệu)
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // Sau khi khung hình đầu tiên được vẽ, tự động refresh trang
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lấy danh sách bài hát yêu thích từ FavoriteSongs.favorites
    final List<Song> favorites = FavoriteSongs.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Songs'),
      ),
      // RefreshIndicator hỗ trợ kéo xuống để reload trang
      body: RefreshIndicator(
        onRefresh: _refreshFavorites,
        // AlwaysScrollableScrollPhysics đảm bảo có thể kéo xuống ngay cả khi danh sách trống
        child: favorites.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(
                    height: 500,
                    child: Center(
                      child: Text('Chưa có bài hát yêu thích nào.'),
                    ),
                  )
                ],
              )
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final Song song = favorites[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      // Sử dụng FadeInImage để hiển thị hình ảnh của bài hát
                      child: FadeInImage.assetNetwork(
                        placeholder:
                            'assets/placeholder.png', // Đảm bảo có file ảnh này trong assets
                        image: song.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.music_note);
                        },
                      ),
                    ),
                    title: Text(song.title),
                    subtitle: Text(song.artist),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {
                        // Khi nhấn nút play, chuyển sang màn hình NowPlaying
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NowPlaying(
                              playingSong: song,
                              songs: favorites,
                            ),
                          ),
                        );
                      },
                    ),
                    // Cho phép xoá bài hát yêu thích khi nhấn giữ (long press)
                    onLongPress: () {
                      setState(() {
                        FavoriteSongs.favorites.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Removed from Favorites'),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
