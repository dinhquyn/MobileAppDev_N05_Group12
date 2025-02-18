import 'dart:math';
import 'package:appdev/ui/now_playing/audio_player_manager.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:appdev/data/model/song.dart';

/// Lớp quản lý danh sách bài hát yêu thích
class FavoriteSongs {
  static List<Song> favorites = [];
}

class NowPlaying extends StatelessWidget {
  const NowPlaying({super.key, required this.playingSong, required this.songs});
  final Song playingSong;
  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    return NowPlayingPage(
      songs: songs,
      playingSong: playingSong,
    );
  }
}

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({super.key, required this.songs, required this.playingSong});

  final Song playingSong;
  final List<Song> songs;

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _imageAnimController;
  late AudioPlayerManager _audioPlayerManager;

  late Song currentSong;
  int currentIndex = 0;
  bool shuffleMode = false;
  bool repeatMode = false;

  @override
  void initState() {
    super.initState();
    _imageAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 12000),
    );
    // Lấy bài hát hiện tại và chỉ số của nó trong danh sách
    currentSong = widget.playingSong;
    currentIndex = widget.songs.indexOf(currentSong);

    _audioPlayerManager = AudioPlayerManager(songUrl: currentSong.source);
    _audioPlayerManager.init();

    // Lắng nghe trạng thái của audio player
    _audioPlayerManager.player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        // Khi bài hát kết thúc, thực hiện theo các chế độ
        if (repeatMode) {
          // Lặp lại bài hiện tại
          playSongAtIndex(currentIndex);
        } else if (shuffleMode) {
          // Chọn ngẫu nhiên một bài khác
          int newIndex = currentIndex;
          if (widget.songs.length > 1) {
            while (newIndex == currentIndex) {
              newIndex = Random().nextInt(widget.songs.length);
            }
          }
          playSongAtIndex(newIndex);
        } else {
          // Chuyển tiếp bài tiếp theo (với wrap-around)
          nextSong();
        }
      }
    });
  }

  @override
  void dispose() {
    _audioPlayerManager.dispose();
    _imageAnimController.dispose();
    super.dispose();
  }

  /// Hàm chuyển bài hát theo chỉ số được truyền vào
  Future<void> playSongAtIndex(int index) async {
    setState(() {
      currentIndex = index;
      currentSong = widget.songs[index];
    });
    // Dừng và giải phóng player cũ
    await _audioPlayerManager.player.stop();
    _audioPlayerManager.dispose();

    // Tạo lại audioPlayerManager với nguồn mới
    _audioPlayerManager = AudioPlayerManager(songUrl: currentSong.source);
    _audioPlayerManager.init();
    _audioPlayerManager.player.play();

    // Nếu có hiệu ứng quay hình, reset AnimationController tại đây
    _imageAnimController.reset();
    _imageAnimController.forward();
  }

  /// Chuyển sang bài tiếp theo (wrap-around nếu ở cuối danh sách)
  void nextSong() {
    int newIndex = (currentIndex + 1) % widget.songs.length;
    playSongAtIndex(newIndex);
  }

  /// Chuyển sang bài trước đó (wrap-around nếu ở đầu danh sách)
  void previousSong() {
    int newIndex = currentIndex - 1;
    if (newIndex < 0) {
      newIndex = widget.songs.length - 1;
    }
    playSongAtIndex(newIndex);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const delta = 64;
    final radius = (screenWidth - delta) / 2;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Now Playing'),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_horiz),
        ),
      ),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(currentSong.album),
              const SizedBox(height: 16),
              const Text('_ ___ _'),
              const SizedBox(height: 48),
              RotationTransition(
                turns:
                    Tween(begin: 0.0, end: 1.0).animate(_imageAnimController),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/ITunes_logo.svg.png',
                    image: currentSong.image,
                    width: screenWidth - delta,
                    height: screenWidth - delta,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/ITunes_logo.svg.png',
                        width: screenWidth - delta,
                        height: screenWidth - delta,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 64, bottom: 16),
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Icon Share (giữ nguyên)
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.share_outlined),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      // Thông tin bài hát
                      Column(
                        children: [
                          Text(
                            currentSong.title,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentSong.artist,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color,
                                ),
                          ),
                        ],
                      ),
                      // Icon trái tim: lưu/bỏ bài hát yêu thích (không điều hướng)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (FavoriteSongs.favorites.contains(currentSong)) {
                              FavoriteSongs.favorites.remove(currentSong);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Removed from Favorites")),
                              );
                            } else {
                              FavoriteSongs.favorites.add(currentSong);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Added to Favorites")),
                              );
                            }
                          });
                        },
                        icon: Icon(
                          FavoriteSongs.favorites.contains(currentSong)
                              ? Icons.favorite
                              : Icons.favorite_outline,
                        ),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 0, left: 24, right: 24, bottom: 10),
                child: _progressBar(), // Thanh progress có chức năng tua
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 0, left: 24, right: 24, bottom: 10),
                child: _mediaButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Cập nhật thanh progressBar để hỗ trợ tua bài hát bằng cách gọi onSeek
  StreamBuilder<DurationState> _progressBar() {
    return StreamBuilder<DurationState>(
      stream: _audioPlayerManager.durationState,
      builder: (context, snapshot) {
        final durationState = snapshot.data;
        final progress = durationState?.progress ?? Duration.zero;
        final total = durationState?.total ?? Duration.zero;
        return ProgressBar(
          progress: progress,
          total: total,
          onSeek: (duration) {
            _audioPlayerManager.player.seek(duration);
          },
        );
      },
    );
  }

  StreamBuilder<PlayerState> _playButton() {
    return StreamBuilder<PlayerState>(
      stream: _audioPlayerManager.player.playerStateStream,
      builder: (context, snapshot) {
        final playState = snapshot.data;
        final processingState = playState?.processingState;
        final playing = playState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: const EdgeInsets.all(8),
            width: 48,
            height: 48,
            child: const CircularProgressIndicator(),
          );
        } else if (playing != true) {
          return MediaButtonControl(
            function: () {
              _audioPlayerManager.player.play();
            },
            icon: Icons.play_arrow,
            color: null,
            size: 48,
          );
        } else if (processingState != ProcessingState.completed) {
          return MediaButtonControl(
            function: () {
              _audioPlayerManager.player.pause();
            },
            icon: Icons.pause,
            color: null,
            size: 48,
          );
        } else {
          return MediaButtonControl(
            function: () {
              _audioPlayerManager.player.seek(Duration.zero);
            },
            icon: Icons.replay,
            color: null,
            size: 48,
          );
        }
      },
    );
  }

  Widget _mediaButtons() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Nút trộn bài (Shuffle)
          MediaButtonControl(
            function: () {
              setState(() {
                shuffleMode = !shuffleMode;
              });
            },
            icon: Icons.shuffle,
            color: shuffleMode ? Colors.blue : Colors.deepPurple,
            size: 24,
          ),
          // Nút bài trước (Previous)
          MediaButtonControl(
            function: () {
              previousSong();
            },
            icon: Icons.skip_previous,
            color: Colors.deepPurple,
            size: 36,
          ),
          // Nút play/pause
          _playButton(),
          // Nút bài kế tiếp (Next)
          MediaButtonControl(
            function: () {
              nextSong();
            },
            icon: Icons.skip_next,
            color: Colors.deepPurple,
            size: 36,
          ),
          // Nút lặp lại (Repeat)
          MediaButtonControl(
            function: () {
              setState(() {
                repeatMode = !repeatMode;
              });
            },
            icon: Icons.repeat,
            color: repeatMode ? Colors.blue : Colors.deepPurple,
            size: 24,
          ),
        ],
      ),
    );
  }
}

class MediaButtonControl extends StatefulWidget {
  const MediaButtonControl({
    super.key,
    required this.function,
    required this.icon,
    required this.color,
    required this.size,
  });

  final void Function()? function;
  final IconData icon;
  final double size;
  final Color? color;

  @override
  State<StatefulWidget> createState() => _MediaButtonControlState();
}

class _MediaButtonControlState extends State<MediaButtonControl> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.function,
      icon: Icon(widget.icon),
      iconSize: widget.size,
      color: widget.color ?? Theme.of(context).colorScheme.primary,
    );
  }
}
