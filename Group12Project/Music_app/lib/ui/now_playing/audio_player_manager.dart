import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../../data/model/song.dart';

class AudioPlayerManager {
  static final AudioPlayerManager _instance = AudioPlayerManager._internal();
  factory AudioPlayerManager() => _instance;
  AudioPlayerManager._internal() {
    _init();
  }

  final player = AudioPlayer();
  String songUrl = '';
  List<Song> playlist = [];
  int currentIndex = -1;

  void _init() {
    // Lắng nghe sự kiện kết thúc bài hát
    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        playNext();
      }
    });
  }

  // Thêm phương thức để cập nhật playlist
  void updatePlaylist(List<Song> songs, int startIndex) {
    playlist = songs;
    currentIndex = startIndex;
  }

  // Phát bài tiếp theo
  void playNext() {
    if (playlist.isEmpty || currentIndex < 0) return;
    
    currentIndex = (currentIndex + 1) % playlist.length;
    final nextSong = playlist[currentIndex];
    updateSongUrl(nextSong.source);
    prepare(isNewSong: true);
    player.play();
  }

  // Phát bài trước đó
  void playPrevious() {
    if (playlist.isEmpty || currentIndex < 0) return;
    
    currentIndex = (currentIndex - 1 + playlist.length) % playlist.length;
    final previousSong = playlist[currentIndex];
    updateSongUrl(previousSong.source);
    prepare(isNewSong: true);
    player.play();
  }
  void updateSongUrl(String url) {
    songUrl = url;
  }

  Future<void> prepare({required bool isNewSong}) async {
    if (isNewSong) {
      await player.setUrl(songUrl);
    }
  }

  Stream<DurationState> get durationState =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
          player.positionStream,
          player.durationStream,
              (position, duration) => DurationState(
            progress: position,
            total: duration ?? Duration.zero,
            buffered: Duration.zero,
          ));

  void dispose() {
    player.dispose();
  }
}
class DurationState{
  const DurationState({
    required this.progress,
    required this.buffered,
    this.total,
});

  final Duration progress;
  final Duration buffered;
  final Duration? total;
} 