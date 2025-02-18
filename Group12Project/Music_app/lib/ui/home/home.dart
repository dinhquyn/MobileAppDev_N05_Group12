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

  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/ITunes_logo.svg.png',
                      image: songs[_selectedItemIndex].image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/ITunes_logo.svg.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          songs[_selectedItemIndex].title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          songs[_selectedItemIndex].artist,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
              // Thông tin chi tiết
              InfoRow(
                icon: Icons.album,
                label: 'Album',
                value: songs[_selectedItemIndex].album,
              ),
              const SizedBox(height: 16),
              InfoRow(
                icon: Icons.timer,
                label: 'Thời lượng',
                value: _formatDuration(songs[_selectedItemIndex].duration),
              ),
              const SizedBox(height: 16),
              InfoRow(
                icon: Icons.music_note,
                label: 'Nguồn',
                value: songs[_selectedItemIndex].source.split('/').last,
              ),
              const SizedBox(height: 24),
              // Các nút tương tác
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ActionButton(
                    icon: Icons.share,
                    label: 'Chia sẻ',
                    onTap: () {
                      // TODO: Implement share
                      Navigator.pop(context);
                    },
                  ),
                  ActionButton(
                    icon: Icons.playlist_add,
                    label: 'Thêm vào playlist',
                    onTap: () {
                      // TODO: Implement add to playlist
                      Navigator.pop(context);
                    },
                  ),
                  Consumer<FavoriteProvider>(
                    builder: (context, favoriteProvider, child) {
                      return ActionButton(
                        icon: favoriteProvider.isFavorite(songs[_selectedItemIndex])
                            ? Icons.favorite
                            : Icons.favorite_border,
                        label: 'Yêu thích',
                        onTap: () {
                          favoriteProvider.toggleFavorite(songs[_selectedItemIndex]);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
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
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
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

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
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
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
