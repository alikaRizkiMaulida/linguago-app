import 'package:shared_preferences/shared_preferences.dart';

class QuizProgress {
  /// Unlocked part index:
  /// 1 = Part 1 unlocked (Part 2, 3 locked)
  /// 2 = Part 1 & 2 unlocked (Part 3 locked)
  /// 3 = Part 1, 2, 3 unlocked
  static int unlockedPart = 1;

  static const String _keyUnlockedPart = 'quiz_unlocked_part';

  /// Load progress from SharedPreferences
  static Future<void> loadProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      unlockedPart = prefs.getInt(_keyUnlockedPart) ?? 1;
    } catch (e) {
      unlockedPart = 1;
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
}

