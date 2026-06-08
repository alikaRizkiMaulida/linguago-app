import 'package:shared_preferences/shared_preferences.dart';
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
      final prefs = await SharedPreferences.getInstance();
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
      final prefs = await SharedPreferences.getInstance();
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

