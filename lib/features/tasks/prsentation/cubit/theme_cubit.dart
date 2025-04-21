import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/core/services/service_locator.dart';

enum ThemeState { light, dark, system }

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themePreferenceKey = 'theme_preference';

  ThemeCubit() : super(ThemeState.system) {
    _loadThemePreference();
  }

  ThemeMode get themeMode {
    switch (state) {
      case ThemeState.light:
        return ThemeMode.light;
      case ThemeState.dark:
        return ThemeMode.dark;
      case ThemeState.system:
      default:
        return ThemeMode.system;
    }
  }

  Future<void> _loadThemePreference() async {
    try {
      final prefs = sl<SharedPreferences>();
      final savedTheme = prefs.getString(_themePreferenceKey);

      if (savedTheme != null) {
        if (savedTheme == 'dark') {
          emit(ThemeState.dark);
        } else if (savedTheme == 'light') {
          emit(ThemeState.light);
        } else {
          emit(ThemeState.system);
        }
      }
    } catch (e) {
      print('Error loading theme preference: $e');
    }
  }

  Future<void> _saveThemePreference(ThemeState themeState) async {
    try {
      final prefs = sl<SharedPreferences>();
      String themeName;

      switch (themeState) {
        case ThemeState.dark:
          themeName = 'dark';
          break;
        case ThemeState.light:
          themeName = 'light';
          break;
        case ThemeState.system:
        default:
          themeName = 'system';
          break;
      }

      await prefs.setString(_themePreferenceKey, themeName);
    } catch (e) {
      print('Error saving theme preference: $e');
    }
  }

  Future<void> toggleTheme() async {
    final newState =
        state == ThemeState.light ? ThemeState.dark : ThemeState.light;
    emit(newState);
    await _saveThemePreference(newState);
  }

  Future<void> setTheme(ThemeState themeState) async {
    if (state == themeState) return;

    emit(themeState);
    await _saveThemePreference(themeState);
  }

  bool isDarkMode() {
    return state == ThemeState.dark;
  }
}
