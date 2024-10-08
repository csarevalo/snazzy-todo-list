import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  /// Loads the User's preferred TextTheme from local or remote storage.
  Future<TextTheme> textTheme() async => const TextTheme();

  /// Loads the User's preferred AppTheme from local or remote storage.
  Future<AppTheme> appTheme(
    TextTheme txtTheme,
  ) async =>
      AppTheme(
        title: "Green Tea", // Todo: retrieve this from somewhere
        textTheme: txtTheme,
      );

  /// Loads the User's preferred Contrast from local or remote storage.
  Future<Contrast> contrast() async => Contrast.none;

  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async => ThemeMode.system;

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
  }

  /// Persists the user's preferred TextTheme to local or remote storage.
  Future<void> updateTextTheme(TextTheme txtTheme) async {
    // Todo: may be more optimal to only save a string TextTheme name
    // since the TextThemes will be saved in constants
  }

  /// Persists the user's preferred AppTheme to local or remote storage.
  Future<void> updateAppTheme(String themeName) async {
    // Todo: may be more optimal to only save a string AppTheme name
    // since the TextThemes will be saved in constants
  }

  /// Persists the user's preferred AppTheme to local or remote storage.
  Future<void> updateContrast(Contrast contrast) async {
    // Todo: may be more optimal to only save a string AppTheme name
    // since the TextThemes will be saved in constants
  }
}
