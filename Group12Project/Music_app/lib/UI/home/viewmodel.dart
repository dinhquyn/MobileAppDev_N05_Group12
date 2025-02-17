import 'dart:async';
import 'package:appdev/data/model/song.dart';
import 'package:appdev/data/repository/repository.dart';

class MusicAppViewModel{
  
  StreamController<List<Song>> songStream = StreamController();

  void loadSongs(){

    final repository = DefaultRepository();
    repository.loadData().then((value) => songStream.add(value!)); 
  }
}