import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/home/home.dart';
import 'ui/settings/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MusicApp(),
    ),
  );
}

