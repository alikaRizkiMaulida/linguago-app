import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/quiz_state.dart';
import 'package:linguago_flutter/ui/pages/lesson_detail_screen.dart';
import 'package:linguago_flutter/ui/screens/quiz/fun_fact_screen.dart';
import 'package:linguago_flutter/ui/screens/quiz/quiz_screen.dart';

class QuizIntroScreen extends StatefulWidget {
  const QuizIntroScreen({super.key});

  @override
  State<QuizIntroScreen> createState() => _QuizIntroScreenState();
}

class _QuizIntroScreenState extends State<QuizIntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FF), // matching #FBF9FF background
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar Header ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded, size: 30),
                    color: AppColors.primaryText,
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Quiz',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Introduction to Hangul',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48), // spacer to match back button width
                ],
              ),
            ),

            // ── Scrollable Body Content ──────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Card 1: Quiz Description ─────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPurple.withOpacity(0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF3EEFB),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/mingcute_game-2-fill.svg',
                                width: 28,
                                height: 28,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.primaryPurple,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Quiz Description',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Test your understanding of basic Hangul vowels and consonants before starting this quiz challenge!',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.secondaryText,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Quiz Sections Title ──────────────────────────────────
                    Text(
                      'Quiz Sections',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Quiz Sections Cards Scrollable Row ──────────────────
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Builder(
                        builder: (context) {
                          final int unlocked = QuizProgress.unlockedPart;
                          return Row(
                            children: [
                              _QuizSectionCard(
                                partNum: 'Part 1',
                                isActive: unlocked == 2,
                                isCompleted: unlocked >= 3,
                                description: 'Review basic Hangul vowels and consonants',
                                svgAsset: 'assets/mingcute_game-2-fill.svg',
                                btnText: unlocked >= 3 ? 'Finish' : (unlocked == 2 ? 'Start' : 'Locked'),
                                onBtnTap: unlocked >= 2 ? () => Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 1)),
                                ).then((_) {
                                  setState(() {});
                                }) : () {},
                              ),
                              const SizedBox(width: 12),
                              _QuizSectionCard(
                                partNum: 'Part 2',
                                isActive: unlocked == 3,
                                isCompleted: unlocked >= 4,
                                description: 'Practice reading, listening, and Hangul patterns!',
                                svgAsset: 'assets/material-symbols_book-6-rounded.svg',
                                btnText: unlocked >= 4 ? 'Finish' : (unlocked == 3 ? 'Start' : 'Locked'),
                                onBtnTap: unlocked >= 3 ? () => Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 2)),
                                ).then((_) {
                                  setState(() {});
                                }) : () {},
                              ),
                              const SizedBox(width: 12),
                              _QuizSectionCard(
                                partNum: 'Part 3',
                                isActive: unlocked == 5,
                                isCompleted: unlocked >= 6,
                                description: 'Complete mixed Hangul quizzes and challenges!',
                                svgAsset: 'assets/icon-park-outline_love-and-help.svg',
                                btnText: unlocked >= 6 ? 'Finish' : (unlocked == 5 ? 'Start' : 'Locked'),
                                onBtnTap: unlocked >= 5 ? () => Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 5)),
                                ).then((_) {
                                  setState(() {});
                                }) : () {},
                              ),
                            ],
                          );
                        }
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Preview Reward Title ─────────────────────────────────
                    Text(
                      'Preview Reward',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Reward Row Cards ─────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        _RewardCard(svgAsset: 'assets/Vector 46.svg', value: '20', label: 'XP', iconColor: Color(0xFFFFB300)),
                        _RewardCard(svgAsset: 'assets/noto_fire.svg', value: '1', label: 'Streak', iconColor: Colors.transparent, useColorFilter: false),
                        _RewardCard(svgAsset: 'assets/game-icons_achievement.svg', value: '5', label: 'Badges', iconColor: Color(0xFFFFC107)),
                        _RewardCard(svgAsset: 'assets/icon-park-outline_love-and-help.svg', value: '3', label: 'Heart', iconColor: Color(0xFFE57373)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Soft helper text
                    Center(
                      child: Text(
                        'Rewards will be given after completing each part!',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Large Bottom Start Quiz Button ────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          final int unlocked = QuizProgress.unlockedPart;
                          if (unlocked == 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(builder: (_) => const LessonDetailScreen(part: 1)),
                            ).then((_) => setState(() {}));
                          } else if (unlocked == 2) {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 1)),
                            ).then((_) => setState(() {}));
                          } else if (unlocked == 3) {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 2)),
                            ).then((_) => setState(() {}));
                          } else if (unlocked == 4) {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(builder: (_) => const FunFactScreen(part: 4)),
                            ).then((_) => setState(() {}));
                          } else if (unlocked == 5) {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 5)),
                            ).then((_) => setState(() {}));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('All parts completed! Level 2 coming soon!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Start Quiz!',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizSectionCard extends StatelessWidget {
  final String partNum;
  final bool isActive;
  final bool isCompleted;
  final String description;
  final String svgAsset;
  final VoidCallback onBtnTap;
  final String btnText;

  const _QuizSectionCard({
    required this.partNum,
    required this.isActive,
    required this.isCompleted,
    required this.description,
    required this.svgAsset,
    required this.onBtnTap,
    required this.btnText,
  });

  @override
  Widget build(BuildContext context) {
    // All cards always show purple theme; lock icon still appears if not active/completed
    const bool isPurple = true;
    final bool isLocked = !isActive && !isCompleted;
    return SizedBox(
      width: 115,
      child: Container(
        height: 175,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Part Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: isPurple ? const Color(0xFFF3EEFB) : const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                partNum,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: isPurple ? AppColors.primaryPurple : AppColors.secondaryText,
                ),
              ),
            ),

            // Illustration circle
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFFBF9FF),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  svgAsset,
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    isPurple ? AppColors.primaryPurple : AppColors.secondaryText,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),

            // Description text
            Text(
              description,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
                height: 1.3,
              ),
            ),

            // Button
            GestureDetector(
              onTap: onBtnTap,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: isPurple ? AppColors.primaryPurple : const Color(0xFFDCD8E2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLocked)
                      const Icon(Icons.lock_rounded, color: Colors.white, size: 10)
                    else
                      const SizedBox.shrink(),
                    if (isLocked) const SizedBox(width: 4) else const SizedBox.shrink(),
                    Text(
                      btnText,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  final String svgAsset;
  final String value;
  final String label;
  final Color iconColor;
  final bool useColorFilter;

  const _RewardCard({
    required this.svgAsset,
    required this.value,
    required this.label,
    required this.iconColor,
    this.useColorFilter = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            svgAsset,
            width: 24,
            height: 24,
            colorFilter: useColorFilter ? ColorFilter.mode(iconColor, BlendMode.srcIn) : null,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
