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

  final _lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      surface: const Color(0xFFF5F5F7),
      primary: Colors.blue,
      secondary: Colors.grey[300]!,
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
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.blue;
        }
        return Colors.grey;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
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
    colorScheme: const ColorScheme.dark(
      surface: Color(0xFF2D2D30),
      primary: Color(0xFF60A5FA),
      secondary: Color(0xFF3D3D40),
      onSurface: Color(0xFFF5F5F7),
      tertiary: Color(0xFFF5F5F7),
      tertiaryContainer: Color(0xFF9CA3AF),
      error: Color(0xFFFF6B6B),
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
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFF60A5FA);
        }
        return const Color(0xFF9CA3AF);
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
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