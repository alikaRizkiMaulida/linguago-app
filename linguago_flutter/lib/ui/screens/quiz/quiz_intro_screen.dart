import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/quiz_state.dart';
import 'package:linguago_flutter/core/constants/language_preference.dart';
import 'package:linguago_flutter/ui/pages/lesson_detail_screen.dart';
import 'package:linguago_flutter/ui/pages/english_lesson_detail_screen.dart';
import 'package:linguago_flutter/ui/screens/quiz/quiz_screen.dart';

class QuizIntroScreen extends StatefulWidget {
  final int boxLevel; // 2 = Box 2 quizzes, 3 = Box 3 quizzes
  const QuizIntroScreen({super.key, this.boxLevel = 2});

  @override
  State<QuizIntroScreen> createState() => _QuizIntroScreenState();
}

class _QuizIntroScreenState extends State<QuizIntroScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isEnglish = LanguagePreference.current == 'English';
    final int unlocked = QuizProgress.unlockedPart;
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
                          isEnglish ? 'English Concept' : 'Introduction to Hangul',
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
                                'assets/Frame 37056.svg',
                                width: 32,
                                height: 32,
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
                                  isEnglish
                                      ? 'Test your understanding of basic English letter sounds and pronunciations before starting this quiz challenge!'
                                      : 'Test your understanding of basic Hangul vowels and consonants before starting this quiz challenge!',
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
                          if (widget.boxLevel == 6) {
                            // ── Box 6 quiz sections ──────────────────────
                            return Row(
                              children: [
                                _QuizSectionCard(
                                  partNum: 'Part 1',
                                  isActive: unlocked == 12,
                                  isCompleted: unlocked >= 13,
                                  description: isEnglish
                                      ? 'Test your Level 6 English skills!'
                                      : 'Test your Level 6 Korean skills!',
                                  svgAsset: 'assets/image 427.svg',
                                  btnText: unlocked >= 13 ? 'Finish' : (unlocked == 12 ? 'Start' : 'Locked'),
                                  onBtnTap: unlocked >= 12 ? () => Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 13)),
                                  ).then((_) { setState(() {}); }) : () {},
                                ),
                                const SizedBox(width: 12),
                                _QuizSectionCard(
                                  partNum: 'Part 2',
                                  isActive: unlocked == 13,
                                  isCompleted: unlocked >= 14,
                                  description: isEnglish
                                      ? 'More Level 6 English challenges!'
                                      : 'More Level 6 Korean challenges!',
                                  svgAsset: 'assets/image 428.svg',
                                  btnText: unlocked >= 14 ? 'Finish' : (unlocked == 13 ? 'Start' : 'Locked'),
                                  onBtnTap: unlocked >= 13 ? () => Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 14)),
                                  ).then((_) { setState(() {}); }) : () {},
                                ),
                                const SizedBox(width: 12),
                                _QuizSectionCard(
                                  partNum: 'Part 3',
                                  isActive: unlocked == 14,
                                  isCompleted: unlocked >= 15,
                                  description: isEnglish
                                      ? 'Complete mixed Level 6 English quizzes and challenges!'
                                      : 'Complete mixed Level 6 Korean quizzes and challenges!',
                                  svgAsset: 'assets/image 429.svg',
                                  btnText: unlocked >= 15 ? 'Finish' : (unlocked == 14 ? 'Start' : 'Locked'),
                                  onBtnTap: unlocked >= 14 ? () => Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 15)),
                                  ).then((_) { setState(() {}); }) : () {},
                                ),
                              ],
                            );
                          }
                          if (widget.boxLevel == 5) {
                            // ── Box 5 quiz sections ──────────────────────
                            return Row(
                              children: [
                                _QuizSectionCard(
                                  partNum: 'Part 1',
                                  isActive: unlocked == 9,
                                  isCompleted: unlocked >= 10,
                                  description: isEnglish
                                      ? 'Test your Level 5 English skills!'
                                      : 'Test your Level 5 Korean skills!',
                                  svgAsset: 'assets/image 427.svg',
                                  btnText: unlocked >= 10 ? 'Finish' : (unlocked == 9 ? 'Start' : 'Locked'),
                                  onBtnTap: unlocked >= 9 ? () => Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 10)),
                                  ).then((_) { setState(() {}); }) : () {},
                                ),
                                const SizedBox(width: 12),
                                _QuizSectionCard(
                                  partNum: 'Part 2',
                                  isActive: unlocked == 10,
                                  isCompleted: unlocked >= 11,
                                  description: isEnglish
                                      ? 'More Level 5 English challenges!'
                                      : 'More Level 5 Korean challenges!',
                                  svgAsset: 'assets/image 428.svg',
                                  btnText: unlocked >= 11 ? 'Finish' : (unlocked == 10 ? 'Start' : 'Locked'),
                                  onBtnTap: unlocked >= 10 ? () => Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 11)),
                                  ).then((_) { setState(() {}); }) : () {},
                                ),
                                const SizedBox(width: 12),
                                _QuizSectionCard(
                                  partNum: 'Part 3',
                                  isActive: unlocked == 11,
                                  isCompleted: unlocked >= 12,
                                  description: isEnglish
                                      ? 'Complete mixed Level 5 English quizzes and challenges!'
                                      : 'Complete mixed Level 5 Korean quizzes and challenges!',
                                  svgAsset: 'assets/image 429.svg',
                                  btnText: unlocked >= 12 ? 'Finish' : (unlocked == 11 ? 'Start' : 'Locked'),
                                  onBtnTap: unlocked >= 11 ? () => Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 12)),
                                  ).then((_) { setState(() {}); }) : () {},
                                ),
                              ],
                            );
                          }
                          if (widget.boxLevel == 3) {
                            // ── Box 3 quiz sections ──────────────────────
                            return Row(
                              children: [
                                _QuizSectionCard(
                                  partNum: 'Part 1',
                                  isActive: unlocked == 5,
                                  isCompleted: unlocked >= 6,
                                  description: isEnglish
                                      ? 'Test your Level 3 English skills!'
                                      : 'Test your Level 3 Korean skills!',
                                  svgAsset: 'assets/image 427.svg',
                                  btnText: unlocked >= 6 ? 'Finish' : (unlocked == 5 ? 'Start' : 'Locked'),
                                  onBtnTap: unlocked >= 5 ? () => Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 7)),
                                  ).then((_) { setState(() {}); }) : () {},
                                ),
                                const SizedBox(width: 12),
                                _QuizSectionCard(
                                  partNum: 'Part 2',
                                  isActive: unlocked == 6,
                                  isCompleted: unlocked >= 7,
                                  description: isEnglish
                                      ? 'More Level 3 English challenges!'
                                      : 'More Level 3 Korean challenges!',
                                  svgAsset: 'assets/image 428.svg',
                                  btnText: unlocked >= 7 ? 'Finish' : (unlocked == 6 ? 'Start' : 'Locked'),
                                  onBtnTap: unlocked >= 6 ? () => Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 8)),
                                  ).then((_) { setState(() {}); }) : () {},
                                ),
                                const SizedBox(width: 12),
                                _QuizSectionCard(
                                  partNum: 'Part 3',
                                  isActive: unlocked == 7,
                                  isCompleted: unlocked >= 8,
                                  description: isEnglish
                                      ? 'Complete mixed Level 3 English quizzes and challenges!'
                                      : 'Complete mixed Level 3 Korean quizzes and challenges!',
                                  svgAsset: 'assets/image 429.svg',
                                  btnText: unlocked >= 8 ? 'Finish' : (unlocked == 7 ? 'Start' : 'Locked'),
                                  onBtnTap: unlocked >= 7 ? () => Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 9)),
                                  ).then((_) { setState(() {}); }) : () {},
                                ),
                              ],
                            );
                          }
                          // ── Box 2 quiz sections (default) ────────────────
                          return Row(
                            children: [
                              _QuizSectionCard(
                                partNum: 'Part 1',
                                isActive: unlocked == 2,
                                isCompleted: unlocked >= 3,
                                description: isEnglish
                                    ? 'Review basic English letter sounds and words!'
                                    : 'Review basic Hangul vowels and consonants',
                                svgAsset: 'assets/image 427.svg',
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
                                description: isEnglish
                                    ? 'Practice reading, listening, and English spelling patterns!'
                                    : 'Practice reading, listening, and Hangul patterns!',
                                svgAsset: 'assets/image 428.svg',
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
                                isActive: unlocked == 4,
                                isCompleted: unlocked >= 5,
                                description: isEnglish
                                    ? 'Complete mixed English quizzes and challenges!'
                                    : 'Complete mixed Hangul quizzes and challenges!',
                                svgAsset: 'assets/image 429.svg',
                                btnText: unlocked >= 5 ? 'Finish' : (unlocked == 4 ? 'Start' : 'Locked'),
                                onBtnTap: unlocked >= 4 ? () => Navigator.push(
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
                          if (widget.boxLevel == 6) {
                            // Box 6 Start Quiz routing
                            if (unlocked == 12) {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 13)),
                              ).then((_) => setState(() {}));
                            } else if (unlocked == 13) {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 14)),
                              ).then((_) => setState(() {}));
                            } else if (unlocked == 14) {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 15)),
                              ).then((_) => setState(() {}));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('All parts completed!'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          } else if (widget.boxLevel == 5) {
                            // Box 5 Start Quiz routing
                            if (unlocked == 9) {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 10)),
                              ).then((_) => setState(() {}));
                            } else if (unlocked == 10) {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 11)),
                              ).then((_) => setState(() {}));
                            } else if (unlocked == 11) {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 12)),
                              ).then((_) => setState(() {}));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('All parts completed!'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          } else if (widget.boxLevel == 3) {
                            // Box 3 Start Quiz routing
                            if (unlocked == 5) {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 7)),
                              ).then((_) => setState(() {}));
                            } else if (unlocked == 6) {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 8)),
                              ).then((_) => setState(() {}));
                            } else if (unlocked == 7) {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 9)),
                              ).then((_) => setState(() {}));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('All parts completed! Box 4 is open!'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          } else {
                            // Box 2 Start Quiz routing
                            if (unlocked == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (_) => isEnglish
                                        ? const EnglishLessonDetailScreen(part: 1)
                                        : const LessonDetailScreen(part: 1)),
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
                                MaterialPageRoute<void>(builder: (_) => const QuizScreen(part: 5)),
                              ).then((_) => setState(() {}));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('All parts completed! Level 3 is open!'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          }
                        },
                        child: Text(
                          widget.boxLevel == 6
                              ? (unlocked >= 15 ? 'Completed!' : 'Start Quiz!')
                              : widget.boxLevel == 5
                                  ? (unlocked >= 12 ? 'Completed!' : 'Start Quiz!')
                                  : widget.boxLevel == 3
                                      ? (unlocked >= 8 ? 'Completed!' : 'Start Quiz!')
                                      : (unlocked >= 5 ? 'Completed!' : 'Start Quiz!'),
                          style: const TextStyle(
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
    final bool isLocked = !isActive && !isCompleted;
    return SizedBox(
      width: 135,
      child: Container(
        height: 205,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? AppColors.primaryPurple
                : (isCompleted
                    ? AppColors.primaryPurple.withOpacity(0.3)
                    : const Color(0xFFEDE7F8)),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withOpacity(isActive ? 0.08 : 0.04),
              blurRadius: isActive ? 16 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Part Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
              decoration: BoxDecoration(
                color: isLocked ? const Color(0xFFF5F3F7) : const Color(0xFFF3EEFB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                partNum,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: isLocked ? AppColors.secondaryText.withOpacity(0.6) : AppColors.primaryPurple,
                ),
              ),
            ),

            // Illustration circle
            Container(
              width: 52,
              height: 52,
              alignment: Alignment.center,
              child: Opacity(
                opacity: isLocked ? 0.45 : 1.0,
                child: SvgPicture.asset(
                  svgAsset,
                  width: 52,
                  height: 52,
                  fit: BoxFit.contain,
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
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isLocked ? AppColors.secondaryText.withOpacity(0.7) : AppColors.primaryText,
                height: 1.3,
              ),
            ),

            // Button
            GestureDetector(
              onTap: onBtnTap,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 7.5),
                decoration: BoxDecoration(
                  color: isLocked ? const Color(0xFFCBBFDC) : AppColors.primaryPurple,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLocked)
                      const Icon(Icons.lock_rounded, color: Colors.white, size: 11)
                    else
                      const SizedBox.shrink(),
                    if (isLocked) const SizedBox(width: 4) else const SizedBox.shrink(),
                    Text(
                      btnText,
                      style: const TextStyle(
                        fontSize: 11,
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
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3EEFB), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            svgAsset,
            width: 26,
            height: 26,
            colorFilter: useColorFilter ? ColorFilter.mode(iconColor, BlendMode.srcIn) : null,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
