import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveThemeToPrefs();
    notifyListeners();
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> _saveThemeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  ThemeData getTheme() {
    return _isDarkMode ? _darkTheme : _lightTheme;
  }

  // iTunes-style light theme
  final _lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      background: Colors.white,
      surface: const Color(0xFFF5F5F7),
      primary: Colors.blue,
      secondary: Colors.grey[300]!,
      onBackground: Colors.black87,
      onSurface: Colors.black87,
      tertiary: Colors.black87,
      tertiaryContainer: Colors.grey[400],
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
    ),
    iconTheme: const IconThemeData(
      color: Colors.black87,
      size: 24,
    ),
    dividerColor: Colors.grey[300],
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.blue;
        }
        return Colors.grey;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.blue.withOpacity(0.5);
        }
        return Colors.grey.withOpacity(0.5);
      }),
    ),
  );

  // iTunes-style dark theme
  final _darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      background: const Color(0xFF232326),
      surface: const Color(0xFF2D2D30),
      primary: const Color(0xFF60A5FA),
      secondary: const Color(0xFF3D3D40),
      onBackground: const Color(0xFFF5F5F7),
      onSurface: const Color(0xFFF5F5F7),
      tertiary: const Color(0xFFF5F5F7),
      tertiaryContainer: const Color(0xFF9CA3AF),
      error: const Color(0xFFFF6B6B),
    ),
    scaffoldBackgroundColor: const Color(0xFF232326),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF232326),
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFFF5F5F7)),
      titleTextStyle: TextStyle(
        color: Color(0xFFF5F5F7),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFFF5F5F7),
      size: 24,
    ),
    dividerColor: const Color(0xFF3D3D40),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF60A5FA);
        }
        return const Color(0xFF9CA3AF);
      }),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF60A5FA).withOpacity(0.5);
        }
        return const Color(0xFF9CA3AF).withOpacity(0.3);
      }),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFF5F5F7)),
      bodyMedium: TextStyle(color: Color(0xFFF5F5F7)),
      titleMedium: TextStyle(color: Color(0xFFF5F5F7)),
    ),
  );
} 