import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linguago_flutter/data/datasource/auth_local_datasource.dart';

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

  static final ValueNotifier<int> xpNotifier = ValueNotifier<int>(400);
  static int get xp => xpNotifier.value;
  static set xp(int val) => xpNotifier.value = val;

  static int checkInDays = 0; // Days checked in so far
  static final ValueNotifier<String> learningLanguageNotifier = ValueNotifier<String>('English');
  static String get learningLanguage => learningLanguageNotifier.value;
  static set learningLanguage(String val) => learningLanguageNotifier.value = val;

  static const String _keyUnlockedPart = 'quiz_unlocked_part';
  static const String _keyCoins = 'quiz_coins';
  static const String _keyHearts = 'quiz_hearts';
  static const String _keyXp = 'quiz_xp';
  static const String _keyCheckInDays = 'quiz_check_in_days';
  static const String _keyLearningLanguage = 'quiz_learning_language';

  static Future<String> _getPrefix() async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      if (authData.user != null && authData.user!.id != null) {
        return 'user_${authData.user!.id}_';
      }
    } catch (_) {}
    return '';
import 'package:linguago_flutter/core/constants/language_preference.dart';

class QuizProgress {
  /// Unlocked part index for English:
  static int unlockedPartEnglish = 1;

  /// Unlocked part index for Korean:
  static int unlockedPartKorean = 1;

  static const String _keyUnlockedPartEnglish = 'quiz_unlocked_part_english';
  static const String _keyUnlockedPartKorean = 'quiz_unlocked_part_korean';

  /// Getter that returns the progress for the current learning language
  static int get unlockedPart {
    if (LanguagePreference.current == 'English') {
      return unlockedPartEnglish;
    } else {
      return unlockedPartKorean;
    }
  }

  /// Load progress from SharedPreferences
  static Future<void> loadProgress() async {
    try {
      final prefix = await _getPrefix();
      final prefs = await SharedPreferences.getInstance();
      unlockedPart = prefs.getInt('$prefix$_keyUnlockedPart') ?? 1;
      coins = prefs.getInt('$prefix$_keyCoins') ?? 10;
      hearts = prefs.getInt('$prefix$_keyHearts') ?? 5;
      xp = prefs.getInt('$prefix$_keyXp') ?? 400;
      checkInDays = prefs.getInt('$prefix$_keyCheckInDays') ?? 0;
      learningLanguage = prefs.getString('$prefix$_keyLearningLanguage') ?? 'English';
    } catch (e) {
      unlockedPart = 1;
      coins = 10;
      hearts = 5;
      xp = 400;
      checkInDays = 0;
      learningLanguage = 'English';
    }
  }

  /// Update and save check-in days
  static Future<void> setCheckInDays(int value) async {
    checkInDays = value;
    try {
      final prefix = await _getPrefix();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('$prefix$_keyCheckInDays', value);
    } catch (e) {
      // ignore
      unlockedPartEnglish = prefs.getInt(_keyUnlockedPartEnglish) ?? 1;
      unlockedPartKorean = prefs.getInt(_keyUnlockedPartKorean) ?? 1;
    } catch (e) {
      unlockedPartEnglish = 1;
      unlockedPartKorean = 1;
    }
  }

  /// Update and save progress to SharedPreferences
  static Future<void> setUnlockedPart(int part) async {
    try {
      final prefix = await _getPrefix();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('$prefix$_keyUnlockedPart', part);
    } catch (e) {
      // ignore
    }
  }

  /// Update and save coins to SharedPreferences
  static Future<void> setCoins(int value) async {
    coins = value;
    try {
      final prefix = await _getPrefix();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('$prefix$_keyCoins', value);
    } catch (e) {
      // ignore
    }
  }

  /// Update and save hearts to SharedPreferences
  static Future<void> setHearts(int value) async {
    hearts = value;
    try {
      final prefix = await _getPrefix();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('$prefix$_keyHearts', value);
    } catch (e) {
      // ignore
    }
  }

  /// Update and save xp to SharedPreferences
  static Future<void> setXp(int value) async {
    xp = value;
    try {
      final prefix = await _getPrefix();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('$prefix$_keyXp', value);
    } catch (e) {
      // ignore
    }
  }

  /// Update and save learning language to SharedPreferences
  static Future<void> setLearningLanguage(String lang) async {
    learningLanguage = lang;
    try {
      final prefix = await _getPrefix();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$prefix$_keyLearningLanguage', lang);
      if (LanguagePreference.current == 'English') {
        unlockedPartEnglish = part;
        await prefs.setInt(_keyUnlockedPartEnglish, part);
      } else {
        unlockedPartKorean = part;
        await prefs.setInt(_keyUnlockedPartKorean, part);
      }
    } catch (e) {
      // ignore
    }
  }

  /// Map progress value to visible unlocked path index
  static int getMapUnlocked(int unlockedPart) {
    if (unlockedPart == 1) return 1;
    if (unlockedPart >= 2 && unlockedPart <= 4) return 2;  // Box 2 quizzes
    if (unlockedPart >= 5 && unlockedPart <= 7) return 3;  // Box 3 quizzes
    if (unlockedPart == 8) return 4;                       // Box 4 (Fun Fact)
    if (unlockedPart >= 9 && unlockedPart <= 11) return 5; // Box 5 quizzes
    if (unlockedPart >= 12 && unlockedPart <= 14) return 6; // Box 6 quizzes
    return 6; // Box 6 completed, everything else locked
  }
}


