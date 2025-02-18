import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/home/home.dart';
import 'ui/settings/theme_provider.dart';
import 'data/provider/favorite_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: const MusicApp(),
    ),
  );
}

