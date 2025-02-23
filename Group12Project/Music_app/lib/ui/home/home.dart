import 'package:appdev/ui/now_playing/audio_player_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/provider/favorite_provider.dart';
import '../discovery/discovery.dart';
import '../now_playing/playing.dart';
import '../settings/settings.dart';
import '../home/viewmodel.dart';
import '../user/user.dart';
import 'package:provider/provider.dart';
import '../settings/theme_provider.dart';

import '../../data/model/song.dart';

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'MusicApp',
          theme: themeProvider.getTheme(),
          home: const MusicHomePage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class MusicHomePage extends StatefulWidget {
  const MusicHomePage({super.key});

  @override
  State<MusicHomePage> createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  final List<Widget> _tabs =[
    const HomeTab(),
    const DiscoveryTab(),
    const AccountTab(),
    const SettingsTab(),
  ];
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Music App'),
      ),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.album), label: 'Discovery'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          return _tabs[index];
        },
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeTabPage();
  }
}


class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  List<Song> songs = [];
  late MusicAppViewModel _viewModel;
  int _selectedItemIndex = -1;

  @override
  void initState() {
    _viewModel = MusicAppViewModel();
    _viewModel.loadSongs();
    observeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  @override
  void dispose() {
    _viewModel.songStream.close();
    AudioPlayerManager().dispose();
    super.dispose();
  }



  Widget getBody() {
    bool showLoading = songs.isEmpty;
    if (showLoading) {
      return getProgressBar();
    } else {
      return getListView();
    }
  }

  Widget getProgressBar() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  ListView getListView() {
    return ListView.separated(
      itemBuilder: (context, position) {
        return getRow(position);
      },
      separatorBuilder: (context, index) {
        return const Divider(
          color: Colors.grey,
          thickness: 1,
          indent: 24,
          endIndent: 24,
        );
      },
      itemCount: songs.length,
      shrinkWrap: true,
    );
  }

  Widget getRow(int index) {
    return _SongItemSection(
      parent: this,
      song: songs[index],
    );
  }


  void observeData() {
    _viewModel.songStream.stream.listen((
        songList) {
      setState(() {
        songs.addAll(songList);
      });
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

void showBottomSheet() {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: false,
    builder: (context) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Phần bên trái (chi tiết bài hát)
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tiêu đề bài hát
                      Text(
                        songs[_selectedItemIndex].title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1, // Giới hạn số dòng
                      ),
                      const SizedBox(height: 8),
                      // Tên nghệ sĩ
                      Text(
                        songs[_selectedItemIndex].artist,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 8),
                      // Album
                      Text(
                        "Album: ${songs[_selectedItemIndex].album}",
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 8),
                      // Thời lượng bài hát
                      Text(
                        "Thời lượng: ${_formatDuration(songs[_selectedItemIndex].duration)}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      // Đánh giá
                      Row(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              5,
                              (index) => const Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "170 Reviews",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Các nút tương tác
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ActionButton(
                            icon: Icons.share,
                            label: 'Chia sẻ',
                            iconSize: 18,
                            fontSize: 10,
                            padding: 4,
                            onTap: () => Navigator.pop(context),
                          ),
                          ActionButton(
                            icon: Icons.playlist_add,
                            label: 'Playlist',
                            iconSize: 18,
                            fontSize: 10,
                            padding: 4,
                            onTap: () => Navigator.pop(context),
                          ),
                          Consumer<FavoriteProvider>(
                            builder: (context, favoriteProvider, child) {
                              bool isFav = favoriteProvider.isFavorite(songs[_selectedItemIndex]);
                              return ActionButton(
                                icon: isFav ? Icons.favorite : Icons.favorite_border,
                                label: 'Yêu thích',
                                iconSize: 18,
                                fontSize: 10,
                                padding: 4,
                                onTap: () {
                                  favoriteProvider.toggleFavorite(songs[_selectedItemIndex]);
                                  _showSnackBar(
                                    context,
                                    isFav
                                        ? 'Đã xóa "${songs[_selectedItemIndex].title}" khỏi danh sách yêu thích'
                                        : 'Đã thêm "${songs[_selectedItemIndex].title}" vào danh sách yêu thích',
                                  );
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8), // Giảm khoảng cách giữa các phần để tránh tràn
                // Phần hình ảnh
                Expanded(
                  flex: 1, // Giảm flex của phần hình ảnh để tránh tràn
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 1.1, // Điều chỉnh tỉ lệ ảnh để không chiếm quá nhiều không gian
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/ITunes_logo.svg.png',
                        image: songs[_selectedItemIndex].image,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/ITunes_logo.svg.png',
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}






  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // điều hướng
  void navigate(Song song) {
    // Cập nhật playlist khi bắt đầu phát
    final audioManager = AudioPlayerManager();
    audioManager.updatePlaylist(songs, songs.indexOf(song));
    
    Navigator.push(context,
      CupertinoPageRoute(builder: (context) {
        return NowPlaying(
          songs: songs,
          playingSong: song,
        );
      })
    );
  }
}

class _SongItemSection extends StatelessWidget {
  const _SongItemSection({
    required this.parent,
    required this.song,
  });
  final _HomeTabPageState parent;
  final Song song;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
        left: 24,
        right: 8,
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FadeInImage.assetNetwork(placeholder: 'assets/ITunes_logo.svg.png',
          image: song.image,
          width: 48,
          height: 48,
          imageErrorBuilder: (context, error, stackTrace){
            return Image.asset('ITunes_logo.svg.png',
              width: 48,
              height: 48,
            );
          },
        ),
      ),
      title: Text(
          song.title
      ),
      subtitle: Text(song.artist),
      trailing: IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {
            parent._selectedItemIndex = parent.songs.indexOf(song);
            parent.showBottomSheet();
          }
      ),
      onTap: () {
        parent.navigate(song);
      },
    );
  }
}

// Widget phụ trợ để hiển thị thông tin
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }
}

// Widget nút tương tác
class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double iconSize;
  final double fontSize;
  final double padding;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconSize = 6,
    this.fontSize = 6, 
    this.padding = 6,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
