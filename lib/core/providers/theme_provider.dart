import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeModeProvider extends StateNotifier<ThemeMode> {
  ThemeModeProvider() : super(ThemeMode.light) {
        _loadThemeMode();
  }
 SharedPreferences? _prefs;

  Future<void> _loadThemeMode() async {
    _prefs = await SharedPreferences.getInstance();
    String? theme = _prefs!.getString("theme");
    if (theme != null) {
      state = theme == "dark" ? ThemeMode.dark : theme == "system" ? ThemeMode.system : ThemeMode.light;
    }
  }
  void toggleThemeMode() async {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _prefs = await SharedPreferences.getInstance();
    _prefs!.setString("theme", state.toString().split('.').last);
  }
  void setThemeSystem() {
    state = ThemeMode.system;
  }
  bool isDarkMode() {
    return state == ThemeMode.dark;
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeProvider, ThemeMode>((ref) {
  return ThemeModeProvider();
});