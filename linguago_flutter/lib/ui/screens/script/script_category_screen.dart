import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/quiz_state.dart';
import 'package:linguago_flutter/ui/pages/lesson_detail_screen.dart';

/// Layar Script Category — pilih kategori pelajaran Hangul.
class ScriptCategoryScreen extends StatefulWidget {
  const ScriptCategoryScreen({super.key});

  @override
  State<ScriptCategoryScreen> createState() => _ScriptCategoryScreenState();
}

class _ScriptCategoryScreenState extends State<ScriptCategoryScreen> {
  static const List<Map<String, dynamic>> _categoriesKorea = [
    {
      'title': 'Concept Hangul',
      'desc': 'Discover what Hangul is and how the writing system works.',
      'emoji': '한\n글',
      'bg': Color(0xFFFFB3BA), // Pink
      'textColor': Color(0xFFD61A54),
      'lockLevel': 1,
    },
    {
      'title': 'Basic Vowels',
      'desc': 'Learn the basic vowel letters in Hangul and how to pronounce them.',
      'emoji': 'ㅗ ㅚ\nㅏ ㅟ',
      'bg': Color(0xFFD4C4F0), // Light Purple
      'textColor': Color(0xFF6C4AB6),
      'lockLevel': 6,
    },
    {
      'title': 'Basic Consonants',
      'desc': 'Learn the basic consonant letters and their sounds in Hangul.',
      'emoji': 'ㄱ ㄷ\nㅂ ㅈ',
      'bg': Color(0xFFFFF0B3), // Yellow
      'textColor': Color(0xFFB37400),
      'lockLevel': 11,
    },
    {
      'title': 'Compound Vowels',
      'desc': 'Combine basic vowels to create new sounds in Hangul.',
      'emoji': 'ㅘ ㅙ\nㅚ ㅝ',
      'bg': Color(0xFFE8E8FF), // Light Blue/Purple
      'textColor': Color(0xFF4D4DFF),
      'lockLevel': 16,
    },
    {
      'title': 'Double Consonants',
      'desc': 'Learn double consonants that produce stronger and tenser sounds.',
      'emoji': 'ㄲ ㄸ\nㅃ ㅆ',
      'bg': Color(0xFFFFDAB9), // Peach
      'textColor': Color(0xFFD2691E),
      'lockLevel': 21,
    },
    {
      'title': 'Final Consonants',
      'desc': 'Understand final consonants (받침) in Korean syllables.',
      'emoji': '사\n람',
      'bg': Color(0xFFE0F7FA), // Light Cyan
      'textColor': Color(0xFF00838F),
      'lockLevel': 26,
    },
  ];

  static const List<Map<String, dynamic>> _categoriesEnglish = [
    {
      'title': 'Concept Alphabet',
      'desc': 'Discover what the English Alphabet is and how the writing system works.',
      'emoji': 'A\nB',
      'bg': Color(0xFFFFB3BA), // Pink
      'textColor': Color(0xFFD61A54),
      'lockLevel': 1,
    },
    {
      'title': 'Basic Vowels',
      'desc': 'Learn the basic vowel letters in English (A, E, I, O, U) and how to pronounce them.',
      'emoji': 'A E\nI O',
      'bg': Color(0xFFD4C4F0), // Light Purple
      'textColor': Color(0xFF6C4AB6),
      'lockLevel': 6,
    },
    {
      'title': 'Basic Consonants',
      'desc': 'Learn basic English consonant letters (B, C, D, F, G...) and their sounds.',
      'emoji': 'B C\nD F',
      'bg': Color(0xFFFFF0B3), // Yellow
      'textColor': Color(0xFFB37400),
      'lockLevel': 11,
    },
    {
      'title': 'Compound Vowels',
      'desc': 'Combine basic vowels to create new diphthong sounds in English.',
      'emoji': 'AI EA\nOU EE',
      'bg': Color(0xFFE8E8FF), // Light Blue/Purple
      'textColor': Color(0xFF4D4DFF),
      'lockLevel': 16,
    },
    {
      'title': 'Double Consonants',
      'desc': 'Learn double consonant blends (sh, ch, th, ph) that make unique sounds.',
      'emoji': 'SH CH\nTH PH',
      'bg': Color(0xFFFFDAB9), // Peach
      'textColor': Color(0xFFD2691E),
      'lockLevel': 21,
    },
    {
      'title': 'Final Consonants',
      'desc': 'Understand silent letters and ending consonant sounds in English.',
      'emoji': 'SIL\nENT',
      'bg': Color(0xFFE0F7FA), // Light Cyan
      'textColor': Color(0xFF00838F),
      'lockLevel': 26,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isKorea = QuizProgress.learningLanguage == 'Korea';
    final categories = isKorea ? _categoriesKorea : _categoriesEnglish;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FF),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // App bar just has a back chevron
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.maybePop(context),
                        child: const Icon(
                          Icons.chevron_left_rounded,
                          size: 30,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // ── Header Text ─────────────────────────────────────────
                Text(
                  "Let's Begin!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryPurple,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isKorea
                      ? 'Learn Hangul from beginner to advanced! ✨'
                      : 'Learn English from beginner to advanced! ✨',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 48), // Space for floating circles

                // ── Category grid ─────────────────────────────────────────
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double width = constraints.maxWidth;
                      final double columnWidth = (width - 40 - 16) / 2;
                      final double cardHeight = 256;
                      final double aspectRatio = columnWidth / cardHeight;

                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 50, // More space for the floating circle
                          childAspectRatio: aspectRatio,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          final int lockLevel = cat['lockLevel'] as int;
                          final bool isUnlocked = QuizProgress.unlockedPart >= lockLevel;
                          return _ScriptCard(
                            title: cat['title'] as String,
                            desc: cat['desc'] as String,
                            emoji: cat['emoji'] as String,
                            bg: cat['bg'] as Color,
                            textColor: cat['textColor'] as Color,
                            unlocked: isUnlocked,
                            lockLevel: lockLevel,
                            onRefresh: () => setState(() {}),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScriptCard extends StatelessWidget {
  final String title;
  final String desc;
  final String emoji;
  final Color bg;
  final Color textColor;
  final bool unlocked;
  final int lockLevel;
  final VoidCallback onRefresh;

  const _ScriptCard({
    required this.title,
    required this.desc,
    required this.emoji,
    required this.bg,
    required this.textColor,
    required this.unlocked,
    required this.lockLevel,
    required this.onRefresh,
  });

  void _navigateToLesson(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonDetailScreen(part: lockLevel),
      ),
    ).then((_) {
      onRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: unlocked ? () => _navigateToLesson(context) : null,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // White Card Background
          Container(
            margin: const EdgeInsets.only(top: 36),
            padding: const EdgeInsets.fromLTRB(14, 48, 14, 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: Center(
                    child: Text(
                      desc,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.secondaryText,
                        height: 1.4,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Button / Lock pill
                if (unlocked)
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () => _navigateToLesson(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Start',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundSoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_rounded,
                          color: AppColors.navInActive, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Unlocked at Level ${((lockLevel - 1) ~/ 5 + 1)}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.navInActive,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        // Floating Circle at the top
        Positioned(
          top: 0,
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                emoji,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}
