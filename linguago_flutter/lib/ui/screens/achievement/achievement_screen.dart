import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';

/// Layar Achievement — menampilkan daftar pencapaian user.
class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  static const List<Map<String, dynamic>> _achievements = [
    {
      'svg': 'assets/Group 36772.svg',
      'title': 'Try all learning\nfeatures',
      'unlocked': true,
      'progress': 1.0,
      'color': Color(0xFF7EC8E3),
    },
    {
      'svg': 'assets/Group 36773.svg',
      'title': 'Answer\nquizzes quickly',
      'unlocked': true,
      'progress': 1.0,
      'color': Color(0xFFFFDFA0),
    },
    {
      'svg': 'assets/Group 36774.svg',
      'title': 'Completed\nlessons',
      'unlocked': true,
      'progress': 1.0,
      'color': Color(0xFFC8A2C8),
    },
    {
      'svg': 'assets/Group 36775.svg',
      'title': 'Unlimited quiz\nhearts',
      'unlocked': true,
      'progress': 1.0,
      'color': Color(0xFFFFB3BA),
    },
    {
      'svg': 'assets/Group 36776-1.svg',
      'title': 'Maintain a long\nlearning streak',
      'unlocked': true,
      'progress': 1.0,
      'color': Color(0xFFE57373),
    },
    {
      'svg': 'assets/Group 36778.svg',
      'title': 'Reach top 3 on\nleaderboard',
      'unlocked': false,
      'progress': 0.0,
      'color': Colors.transparent,
    },
    {
      'svg': 'assets/Group 36779.svg',
      'title': 'Complete many\nreading lessons',
      'unlocked': false,
      'progress': 0.0,
      'color': Colors.transparent,
    },
    {
      'svg': 'assets/Group 36780.svg',
      'title': 'Keep learning\nafter quizzes',
      'unlocked': false,
      'progress': 0.0,
      'color': Colors.transparent,
    },
    {
      'svg': 'assets/Group 36780-1.svg',
      'title': 'Reach rank #1\non leaderboard',
      'unlocked': false,
      'progress': 0.0,
      'color': Colors.transparent,
    },
    {
      'svg': 'assets/Group 36781.svg',
      'title': 'Finish lessons\nsmoothly',
      'unlocked': false,
      'progress': 0.0,
      'color': Colors.transparent,
    },
    {
      'svg': 'assets/Group 36785.svg',
      'title': 'Collect many\ngems/rewards',
      'unlocked': false,
      'progress': 0.0,
      'color': Colors.transparent,
    },
    {
      'svg': 'assets/Group 36786.svg',
      'title': 'Complete a full\nlesson perfectly',
      'unlocked': false,
      'progress': 0.0,
      'color': Colors.transparent,
    },
    {
      'svg': 'assets/Group 36796.svg',
      'title': 'Maintain a long\nlearning streak',
      'unlocked': false,
      'progress': 0.0,
      'color': Colors.transparent,
    },
    {
      'svg': 'assets/Group 36787.svg',
      'title': 'Reach rank #2\non leaderboard',
      'unlocked': false,
      'progress': 0.0,
      'color': Colors.transparent,
    },
    {
      'svg': 'assets/Group 36788.svg',
      'title': 'Get multiple\ncorrect answers',
      'unlocked': false,
      'progress': 0.0,
      'color': Colors.transparent,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                itemCount: _achievements.length,
                itemBuilder: (context, index) {
                  final item = _achievements[index];
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Badge Image (drawn directly, without container circle/border, larger size)
        SizedBox(
          width: 82,
          height: 82,
          child: SvgPicture.asset(
            svgAsset,
            fit: BoxFit.contain,
          ),
        ),
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
              color: AppColors.primaryText,
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
                color: AppColors.primaryPurple,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
