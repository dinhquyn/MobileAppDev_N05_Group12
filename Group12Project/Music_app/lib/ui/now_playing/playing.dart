import 'dart:math';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../data/model/song.dart';
import 'audio_player_manager.dart';
import '../../data/provider/favorite_provider.dart';

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
  const NowPlayingPage({
    super.key,
    required this.songs,
    required this.playingSong,
  });

  final Song playingSong;
  final List<Song> songs;

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _imageAnimController;
  late AudioPlayerManager _audioPlayerManager;
  late int _selectedItemIndex;
  late Song _song;
  double _currentAnimationPosition = 0.0;
  bool _isShuffle = false;
  late LoopMode _loopMode;
  final double delta = 64;

  @override
  void initState() {
    super.initState();
    _currentAnimationPosition = 0.0;
    _song = widget.playingSong;
    _imageAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _audioPlayerManager = AudioPlayerManager();

    // Lắng nghe trạng thái của player để chuyển bài
    _audioPlayerManager.player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (_loopMode == LoopMode.one) {
          _audioPlayerManager.player.seek(Duration.zero);
          _audioPlayerManager.player.play();
        } else {
          _setNextSong();
        }
      }
    });

    if (_audioPlayerManager.songUrl.compareTo(_song.source) != 0) {
      _audioPlayerManager.updateSongUrl(_song.source);
      _audioPlayerManager.prepare(isNewSong: true);
    } else {
      _audioPlayerManager.prepare(isNewSong: false);
    }
    _selectedItemIndex = widget.songs.indexOf(widget.playingSong);
    _loopMode = LoopMode.off;
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

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình hiện tại
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    // Tính kích thước cho album cover: trên mobile sẽ chiếm gần toàn bộ chiều rộng, trên desktop sẽ giới hạn lại
    final albumCoverSize = isSmallScreen ? screenWidth - delta : screenWidth * 0.4;
    final albumCoverRadius = albumCoverSize / 2;

    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        // Chọn layout theo kích thước màn hình
        final Widget content = isSmallScreen
            ? _buildVerticalLayout(context, albumCoverSize, albumCoverRadius, favoriteProvider)
            : _buildHorizontalLayout(context, albumCoverSize, albumCoverRadius, favoriteProvider);

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: const Text('Now Playing'),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_horiz),
            ),
          ),
          // Dùng Scaffold bên trong để hiển thị body (bạn có thể thay đổi nếu không cần thiết)
          child: Scaffold(
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: content,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVerticalLayout(BuildContext context, double albumCoverSize,
      double albumCoverRadius, FavoriteProvider favoriteProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _song.album,
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        const Text('_ ___ _'),
        const SizedBox(height: 48),
        RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(_imageAnimController),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(albumCoverRadius),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/ITunes_logo.svg.png',
              image: _song.image,
              width: albumCoverSize,
              height: albumCoverSize,
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/ITunes_logo.svg.png',
                  width: albumCoverSize,
                  height: albumCoverSize,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 64, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share_outlined),
                color: Theme.of(context).colorScheme.primary,
              ),
              Column(
                children: [
                  Text(
                    _song.title,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _song.artist,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  favoriteProvider.toggleFavorite(_song);
                  _showSnackBar(
                    context,
                    favoriteProvider.isFavorite(_song)
                        ? 'Đã thêm "${_song.title}" vào danh sách yêu thích'
                        : 'Đã xóa "${_song.title}" khỏi danh sách yêu thích',
                  );
                },
                icon: Icon(
                  favoriteProvider.isFavorite(_song)
                      ? Icons.favorite
                      : Icons.favorite_outline,
                ),
                color: favoriteProvider.isFavorite(_song)
                    ? Colors.red
                    : Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: _progressBar(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: _mediaButtons(),
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout(BuildContext context, double albumCoverSize,
      double albumCoverRadius, FavoriteProvider favoriteProvider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Cột bên trái: album cover
        Padding(
          padding: const EdgeInsets.all(16),
          child: RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_imageAnimController),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(albumCoverRadius),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/ITunes_logo.svg.png',
                image: _song.image,
                width: albumCoverSize,
                height: albumCoverSize,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/ITunes_logo.svg.png',
                    width: albumCoverSize,
                    height: albumCoverSize,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
        ),
        // Cột bên phải: thông tin bài hát, progress bar và điều khiển media
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _song.album,
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(height: 16),
                const Text('_ ___ _'),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.share_outlined),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _song.title,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _song.artist,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        favoriteProvider.toggleFavorite(_song);
                        _showSnackBar(
                          context,
                          favoriteProvider.isFavorite(_song)
                              ? 'Đã thêm "${_song.title}" vào danh sách yêu thích'
                              : 'Đã xóa "${_song.title}" khỏi danh sách yêu thích',
                        );
                      },
                      icon: Icon(
                        favoriteProvider.isFavorite(_song)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                      ),
                      color: favoriteProvider.isFavorite(_song)
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _progressBar(),
                const SizedBox(height: 32),
                _mediaButtons(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _imageAnimController.dispose();
    // Hủy listener khi widget bị dispose
    _audioPlayerManager.player.playerStateStream.drain();
    super.dispose();
  }

  Widget _mediaButtons() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MediaButtonControl(
              function: _setShuffle,
              icon: Icons.shuffle,
              color: _getShuffleColor(),
              size: 24),
          MediaButtonControl(
              function: _setPrevSong,
              icon: Icons.skip_previous,
              color: Colors.deepPurple,
              size: 36),
          _playButton(),
          MediaButtonControl(
              function: _setNextSong,
              icon: Icons.skip_next,
              color: Colors.deepPurple,
              size: 36),
          MediaButtonControl(
              function: _setupRepeatOption,
              icon: _repeatingIcon(),
              color: _getRepeatingIconColor(),
              size: 24),
        ],
      ),
    );
  }

  StreamBuilder<DurationState> _progressBar() {
    return StreamBuilder<DurationState>(
      stream: _audioPlayerManager.durationState,
      builder: (context, snapshot) {
        final durationState = snapshot.data;
        final progress = durationState?.progress ?? Duration.zero;
        final buffered = durationState?.buffered ?? Duration.zero;
        final total = durationState?.total ?? Duration.zero;
        return ProgressBar(
          progress: progress,
          total: total,
          buffered: buffered,
          onSeek: _audioPlayerManager.player.seek,
          barHeight: 5.0,
          barCapShape: BarCapShape.round,
          baseBarColor: Colors.grey.withOpacity(0.3),
          progressBarColor: Colors.green,
          bufferedBarColor: Colors.grey.withOpacity(0.3),
          thumbColor: Colors.deepPurple,
          thumbGlowColor: Colors.green.withOpacity(0.3),
          thumbRadius: 10.0,
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
          _pauseRotationAnim();
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
            color: Colors.deepPurple,
            size: 48,
          );
        } else if (processingState != ProcessingState.completed) {
          _playRotationAnim();
          return MediaButtonControl(
            function: () {
              _audioPlayerManager.player.pause();
              _pauseRotationAnim();
            },
            icon: Icons.pause,
            color: Colors.deepPurple,
            size: 48,
          );
        } else {
          // Khi bài hát kết thúc, reset animation và cho phép replay
          _stopRotationAnim();
          _resetRotationAnim();
          return MediaButtonControl(
            function: () {
              _audioPlayerManager.player.seek(Duration.zero);
              _resetRotationAnim();
              _playRotationAnim();
            },
            icon: Icons.replay,
            color: Theme.of(context).colorScheme.primary,
            size: 48,
          );
        }
      },
    );
  }

  void _setShuffle() {
    setState(() {
      _isShuffle = !_isShuffle;
    });
  }

  Color? _getShuffleColor() {
    return _isShuffle ? Colors.deepPurple : Colors.grey;
  }

  void _setNextSong() {
    if (_isShuffle) {
      _selectedItemIndex = Random().nextInt(widget.songs.length);
    } else if (_selectedItemIndex < widget.songs.length - 1) {
      _selectedItemIndex++;
    } else if (_loopMode == LoopMode.all &&
        _selectedItemIndex == widget.songs.length - 1) {
      _selectedItemIndex = 0;
    }
    _selectedItemIndex = _selectedItemIndex % widget.songs.length;
    final nextSong = widget.songs[_selectedItemIndex];
    setState(() {
      _song = nextSong;
      _audioPlayerManager.updateSongUrl(nextSong.source);
      _audioPlayerManager.prepare(isNewSong: true);
      _resetRotationAnim();
      _audioPlayerManager.player.play();
    });
  }

  void _setPrevSong() {
    if (_isShuffle) {
      _selectedItemIndex = Random().nextInt(widget.songs.length);
    } else if (_selectedItemIndex > 0) {
      _selectedItemIndex--;
    } else if (_loopMode == LoopMode.all && _selectedItemIndex == 0) {
      _selectedItemIndex = widget.songs.length - 1;
    }
    if (_selectedItemIndex < 0) {
      _selectedItemIndex = widget.songs.length - 1;
    }
    final prevSong = widget.songs[_selectedItemIndex];
    setState(() {
      _song = prevSong;
      _audioPlayerManager.updateSongUrl(prevSong.source);
      _audioPlayerManager.prepare(isNewSong: true);
      _resetRotationAnim();
      _audioPlayerManager.player.play();
    });
  }

  void _setupRepeatOption() {
    if (_loopMode == LoopMode.off) {
      _loopMode = LoopMode.one;
    } else if (_loopMode == LoopMode.one) {
      _loopMode = LoopMode.all;
    } else {
      _loopMode = LoopMode.off;
    }
    setState(() {
      _audioPlayerManager.player.setLoopMode(_loopMode);
    });
  }

  IconData _repeatingIcon() {
    return switch (_loopMode) {
      LoopMode.one => Icons.repeat_one,
      LoopMode.all => Icons.repeat_on,
      _ => Icons.repeat,
    };
  }

  Color? _getRepeatingIconColor() {
    return _loopMode == LoopMode.off ? Colors.grey : Colors.deepPurple;
  }

  void _playRotationAnim() {
    _imageAnimController.forward(from: _currentAnimationPosition);
    _imageAnimController.repeat();
  }

  void _pauseRotationAnim() {
    _stopRotationAnim();
    _currentAnimationPosition = _imageAnimController.value;
  }

  void _stopRotationAnim() {
    _imageAnimController.stop();
  }

  void _resetRotationAnim() {
    _currentAnimationPosition = 0.0;
    _imageAnimController.value = _currentAnimationPosition;
  }
}

extension on TextTheme {
  get headline6 => null;
  
  get subtitle1 => null;
  
  get headline5 => null;
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
  final double? size;
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
