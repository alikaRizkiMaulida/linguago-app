import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the selected learning language.
/// Default is 'English' for new users.
/// Persists selection across app restarts via SharedPreferences.
class LanguagePreference {
  static const String _key = 'learning_language';

  /// Reactive notifier — listen to this to rebuild UI on language change.
  static final ValueNotifier<String> learningLanguage =
      ValueNotifier<String>('English');

  /// Load saved preference from storage. Call once at app startup.
  static Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_key);
      // Default to 'English' for new users (null = first time)
      learningLanguage.value = saved ?? 'English';
    } catch (_) {
      learningLanguage.value = 'English';
    }
  }

  /// Persist and broadcast new language selection.
  static Future<void> setLearningLanguage(String lang) async {
    learningLanguage.value = lang;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, lang);
    } catch (_) {}
  }

  /// Convenience getter.
  static String get current => learningLanguage.value;
}
