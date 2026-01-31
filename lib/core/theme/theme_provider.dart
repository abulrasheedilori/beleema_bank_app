import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(_themes.first);

  int _index = 0;

  void cycleTheme() {
    _index = (_index + 1) % _themes.length;
    state = _themes[_index];
  }

  static final List<ThemeData> _themes = [
    _buildTheme(
      primary: Colors.green,
      background: Colors.white,
      accent: Colors.green.shade700,
      brightness: Brightness.light,
    ),
    _buildTheme(
      primary: Colors.green,
      background: Colors.green.shade50,
      accent: Colors.green.shade900,
      brightness: Brightness.light,
    ),
    _buildTheme(
      primary: Colors.green.shade300,
      background: Colors.green.shade900,
      accent: Colors.green.shade100,
      brightness: Brightness.dark,
    ),
    _buildTheme(
      primary: Colors.blue,
      background: Colors.blue.shade50,
      accent: Colors.blue.shade700,
      brightness: Brightness.light,
    ),
    _buildTheme(
      primary: Colors.purple,
      background: Colors.purple.shade50,
      accent: Colors.purple.shade700,
      brightness: Brightness.light,
    ),
    _buildTheme(
      primary: Colors.amber,
      background: Colors.amber.shade50,
      accent: Colors.amber.shade700,
      brightness: Brightness.light,
    ),
  ];

  static ThemeData _buildTheme({
    required Color primary,
    required Color background,
    required Color accent,
    required Brightness brightness,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: Colors.white,
      secondary: accent,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      surface: background,
      onSurface: brightness == Brightness.dark ? Colors.white : Colors.black,
      background: background,
      onBackground: brightness == Brightness.dark ? Colors.white : Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outline),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outline),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.error),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),

        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        foregroundColor: colorScheme.onBackground,
        elevation: 0,
      ),
    );
  }
}
