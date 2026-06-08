import 'package:flutter/material.dart';
import '../services/storage_service.dart';

/// ──────────────────────────────────────────────
/// Theme Provider — Light/Dark mode toggle
/// ──────────────────────────────────────────────
///
/// Manages the app's theme mode (light/dark) and
/// persists the user's preference in Hive.
class ThemeProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  /// Current theme mode state.
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  /// Returns the current ThemeMode for MaterialApp.
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Load the saved theme preference from Hive.
  void loadState() {
    _isDarkMode = _storage.getDarkMode();
    notifyListeners();
  }

  /// Toggle between light and dark mode.
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _storage.setDarkMode(_isDarkMode);
    notifyListeners();
  }
}
