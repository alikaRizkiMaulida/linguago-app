import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';

/// Layar Script Category — pilih kategori pelajaran Hangul.
class ScriptCategoryScreen extends StatelessWidget {
  const ScriptCategoryScreen({super.key});

  static const List<Map<String, dynamic>> _categories = [
    {
      'title': 'Concept Hangul',
      'desc': 'Discover what Hangul is and how the writing system works.',
      'emoji': '한\n글',
      'bg': Color(0xFFFFB3BA), // Pink
      'unlocked': true,
      'lockLevel': null,
    },
    {
      'title': 'Basic Vowels',
      'desc': 'Learn the basic vowel letters in Hangul and how to pronounce them.',
      'emoji': 'ㅗ ㅚ\nㅏ ㅟ',
      'bg': Color(0xFFD4C4F0), // Light Purple
      'unlocked': false,
      'lockLevel': 2,
    },
    {
      'title': 'Basic Consonants',
      'desc': 'Learn the basic consonant letters and their sounds in Hangul.',
      'emoji': 'ㄱ ㄷ\nㅂ ㅈ',
      'bg': Color(0xFFFFF0B3), // Yellow
      'unlocked': false,
      'lockLevel': 3,
    },
    {
      'title': 'Compound Vowels',
      'desc': 'Combine basic vowels to create new sounds in Hangul.',
      'emoji': 'ㅘ ㅙ\nㅚ ㅝ',
      'bg': Color(0xFFE8E8FF), // Light Blue/Purple
      'unlocked': false,
      'lockLevel': 4,
    },
    {
      'title': 'Double Consonants',
      'desc': 'Learn double consonants that produce stronger and tenser sounds.',
      'emoji': 'ㄲ ㄸ\nㅃ ㅆ',
      'bg': Color(0xFFFFDAB9), // Peach
      'unlocked': false,
      'lockLevel': 5,
    },
    {
      'title': 'Final Consonants',
      'desc': 'Understand final consonants (받침) in Korean syllables.',
      'emoji': '사\n람',
      'bg': Color(0xFFE0F7FA), // Light Cyan
      'unlocked': false,
      'lockLevel': 6,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FF),
      body: SafeArea(
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
              'Learn Hangul from beginner to advanced! ✨',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 48), // Space for floating circles

            // ── Category grid ─────────────────────────────────────────
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 50, // More space for the floating circle
                  childAspectRatio: 0.65,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  return _ScriptCard(
                    title: cat['title'] as String,
                    desc: cat['desc'] as String,
                    emoji: cat['emoji'] as String,
                    bg: cat['bg'] as Color,
                    unlocked: cat['unlocked'] as bool,
                    lockLevel: cat['lockLevel'] as int?,
                  );
                },
              ),
            ),
          ],
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
  final bool unlocked;
  final int? lockLevel;

  const _ScriptCard({
    required this.title,
    required this.desc,
    required this.emoji,
    required this.bg,
    required this.unlocked,
    this.lockLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                color: AppColors.primaryPurple.withOpacity(0.06),
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
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.secondaryText,
                    height: 1.4,
                  ),
                  overflow: TextOverflow.visible,
                ),
              ),
              const SizedBox(height: 8),
              // Button / Lock pill
              if (unlocked)
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      'start',
                      style: TextStyle(
                        fontSize: 12,
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
                    color: const Color(0xFFF3EEFB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_rounded,
                          color: AppColors.navInActive, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Unlocked at Level $lockLevel',
                        style: TextStyle(
                          fontSize: 9,
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
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFD61A54), // Hot pink color for text
                  height: 1.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
