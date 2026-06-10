import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/quiz_state.dart';

/// Layar Achievement — menampilkan daftar pencapaian user secara dinamis.
class AchievementPage extends StatelessWidget {
  const AchievementPage({super.key});

  List<Map<String, dynamic>> _getDynamicAchievements() {
    return [
      {
        'svg': 'assets/Group 36772.svg',
        'title': 'Try all learning\nfeatures',
        'unlocked': QuizProgress.unlockedPart >= 2,
        'progress': (QuizProgress.unlockedPart / 3).clamp(0.0, 1.0),
        'color': const Color(0xFF7EC8E3),
      },
      {
        'svg': 'assets/Group 36773.svg',
        'title': 'Answer\nquizzes quickly',
        'unlocked': QuizProgress.coins >= 20,
        'progress': (QuizProgress.coins / 20).clamp(0.0, 1.0),
        'color': const Color(0xFFFFDFA0),
      },
      {
        'svg': 'assets/Group 36774.svg',
        'title': 'Completed\nlessons',
        'unlocked': QuizProgress.xp >= 450,
        'progress': ((QuizProgress.xp - 400) / 50).clamp(0.0, 1.0),
        'color': const Color(0xFFC8A2C8),
      },
      {
        'svg': 'assets/Group 36775.svg',
        'title': 'Unlimited quiz\nhearts',
        'unlocked': QuizProgress.hearts >= 5,
        'progress': (QuizProgress.hearts / 5).clamp(0.0, 1.0),
        'color': const Color(0xFFFFB3BA),
      },
      {
        'svg': 'assets/Group 36776-1.svg',
        'title': 'Maintain a long\nlearning streak',
        'unlocked': QuizProgress.checkInDays >= 3,
        'progress': (QuizProgress.checkInDays / 3).clamp(0.0, 1.0),
        'color': const Color(0xFFE57373),
      },
      {
        'svg': 'assets/Group 36778.svg',
        'title': 'Reach top 3 on\nleaderboard',
        'unlocked': QuizProgress.xp >= 600,
        'progress': (QuizProgress.xp / 600).clamp(0.0, 1.0),
        'color': const Color(0xFFFFD54F),
      },
      {
        'svg': 'assets/Group 36779.svg',
        'title': 'Complete many\nreading lessons',
        'unlocked': QuizProgress.unlockedPart >= 3,
        'progress': (QuizProgress.unlockedPart / 3).clamp(0.0, 1.0),
        'color': const Color(0xFF81C784),
      },
      {
        'svg': 'assets/Group 36780.svg',
        'title': 'Keep learning\nafter quizzes',
        'unlocked': QuizProgress.xp >= 500,
        'progress': (QuizProgress.xp / 500).clamp(0.0, 1.0),
        'color': const Color(0xFF4DD0E1),
      },
      {
        'svg': 'assets/Group 36780-1.svg',
        'title': 'Reach rank #1\non leaderboard',
        'unlocked': QuizProgress.xp >= 1000,
        'progress': (QuizProgress.xp / 1000).clamp(0.0, 1.0),
        'color': const Color(0xFFFF8A65),
      },
      {
        'svg': 'assets/Group 36781.svg',
        'title': 'Finish lessons\nsmoothly',
        'unlocked': QuizProgress.hearts >= 5 && QuizProgress.xp >= 480,
        'progress': (QuizProgress.xp / 480).clamp(0.0, 1.0),
        'color': const Color(0xFFBA68C8),
      },
      {
        'svg': 'assets/Group 36785.svg',
        'title': 'Collect many\ngems/rewards',
        'unlocked': QuizProgress.coins >= 50,
        'progress': (QuizProgress.coins / 50).clamp(0.0, 1.0),
        'color': const Color(0xFF90A4AE),
      },
      {
        'svg': 'assets/Group 36786.svg',
        'title': 'Complete a full\nlesson perfectly',
        'unlocked': QuizProgress.xp >= 800,
        'progress': (QuizProgress.xp / 800).clamp(0.0, 1.0),
        'color': const Color(0xFFA1887F),
      },
      {
        'svg': 'assets/Group 36796.svg',
        'title': 'Maintain a long\nlearning streak',
        'unlocked': QuizProgress.checkInDays >= 7,
        'progress': (QuizProgress.checkInDays / 7).clamp(0.0, 1.0),
        'color': const Color(0xFFF06292),
      },
      {
        'svg': 'assets/Group 36787.svg',
        'title': 'Reach rank #2\non leaderboard',
        'unlocked': QuizProgress.xp >= 750,
        'progress': (QuizProgress.xp / 750).clamp(0.0, 1.0),
        'color': const Color(0xFF7986CB),
      },
      {
        'svg': 'assets/Group 36788.svg',
        'title': 'Get multiple\ncorrect answers',
        'unlocked': QuizProgress.xp >= 550,
        'progress': (QuizProgress.xp / 550).clamp(0.0, 1.0),
        'color': const Color(0xFF4DB6AC),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final list = _getDynamicAchievements();

    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: SafeArea(
        child: Column(
          children: [
            // ── App bar ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
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
                  Expanded(
                    child: Text(
                      'Achievement',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Grid ─────────────────────────────────────────────────
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.62,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  return _AchievementItem(
                    svgAsset: item['svg'] as String,
                    title: item['title'] as String,
                    unlocked: item['unlocked'] as bool,
                    progress: item['progress'] as double,
                    bgColor: item['color'] as Color,
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

class _AchievementItem extends StatelessWidget {
  final String svgAsset;
  final String title;
  final bool unlocked;
  final double progress;
  final Color bgColor;

  const _AchievementItem({
    required this.svgAsset,
    required this.title,
    required this.unlocked,
    required this.progress,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget badge = SizedBox(
      width: 82,
      height: 82,
      child: SvgPicture.asset(
        svgAsset,
        fit: BoxFit.contain,
      ),
    );

    // Gray out badge and text if not unlocked
    if (!unlocked) {
      badge = ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0,      0,      0,      1, 0,
        ]),
        child: Opacity(
          opacity: 0.65,
          child: badge,
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Badge Image
        badge,
        const SizedBox(height: 12),
        // Title text
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 3,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: unlocked ? AppColors.primaryText : AppColors.secondaryText.withValues(alpha: 0.4),
              height: 1.3,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Progress bar (straight horizontal line)
        Container(
          height: 4,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E0EF),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: unlocked ? AppColors.primaryPurple : AppColors.primaryPurple.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
