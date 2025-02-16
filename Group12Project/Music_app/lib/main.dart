import 'package:appdev/data/repository/repository.dart';
import 'package:flutter/material.dart';

void main() async {
  var repository = DefaultRepository();
  var songs = await repository.loadData();
  if (songs != null) {
    for (var song in songs) {
      debugPrint(song.toString());
    }
  }
}

class MussicApp extends StatelessWidget {
  const MussicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
