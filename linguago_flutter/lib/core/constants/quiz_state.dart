import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizProgress {
  /// Unlocked part index:
  /// 1 = Part 1 unlocked (Part 2, 3 locked)
  /// 2 = Part 1 & 2 unlocked (Part 3 locked)
  /// 3 = Part 1, 2, 3 unlocked
  static final ValueNotifier<int> unlockedPartNotifier = ValueNotifier<int>(1);
  static int get unlockedPart => unlockedPartNotifier.value;
  static set unlockedPart(int val) => unlockedPartNotifier.value = val;

  static final ValueNotifier<int> coinsNotifier = ValueNotifier<int>(10);
  static int get coins => coinsNotifier.value;
  static set coins(int val) => coinsNotifier.value = val;

  static final ValueNotifier<int> heartsNotifier = ValueNotifier<int>(5);
  static int get hearts => heartsNotifier.value;
  static set hearts(int val) => heartsNotifier.value = val;

  static int checkInDays = 0; // Days checked in so far
  static String learningLanguage = 'English'; // default to English for new users

  static const String _keyUnlockedPart = 'quiz_unlocked_part';
  static const String _keyCoins = 'quiz_coins';
  static const String _keyHearts = 'quiz_hearts';
  static const String _keyCheckInDays = 'quiz_check_in_days';
  static const String _keyLearningLanguage = 'quiz_learning_language';

  /// Load progress from SharedPreferences
  static Future<void> loadProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      unlockedPart = prefs.getInt(_keyUnlockedPart) ?? 1;
      coins = prefs.getInt(_keyCoins) ?? 10;
      hearts = prefs.getInt(_keyHearts) ?? 5;
      checkInDays = prefs.getInt(_keyCheckInDays) ?? 0;
      learningLanguage = prefs.getString(_keyLearningLanguage) ?? 'English';
    } catch (e) {
      unlockedPart = 1;
      coins = 10;
      hearts = 5;
      checkInDays = 0;
      learningLanguage = 'English';
    }
  }

  /// Update and save check-in days
  static Future<void> setCheckInDays(int value) async {
    checkInDays = value;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyCheckInDays, value);
    } catch (e) {
      // ignore
    }
  }

  /// Update and save progress to SharedPreferences
  static Future<void> setUnlockedPart(int part) async {
    unlockedPart = part;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyUnlockedPart, part);
    } catch (e) {
      // ignore
    }
  }

  /// Update and save coins to SharedPreferences
  static Future<void> setCoins(int value) async {
    coins = value;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyCoins, value);
    } catch (e) {
      // ignore
    }
  }

  /// Update and save hearts to SharedPreferences
  static Future<void> setHearts(int value) async {
    hearts = value;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyHearts, value);
    } catch (e) {
      // ignore
    }
  }

  /// Update and save learning language to SharedPreferences
  static Future<void> setLearningLanguage(String lang) async {
    learningLanguage = lang;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyLearningLanguage, lang);
    } catch (e) {
      // ignore
    }
  }
}


