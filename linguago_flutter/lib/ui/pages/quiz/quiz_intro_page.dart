import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Jalur import constants asli project
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/quiz_state.dart'; 

import 'package:linguago_flutter/ui/pages/quiz/quiz_page.dart';

class QuizIntroPage extends StatefulWidget {
  final int level;
  const QuizIntroPage({super.key, this.level = 1});

  @override
  State<QuizIntroPage> createState() => _QuizIntroPageState();
}

class _QuizIntroPageState extends State<QuizIntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FF), // Background aplikasi #FBF9FF
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                // ── App Bar Header ───────────────────────────────────────────
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
                            const Text(
                              'Quiz',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              QuizProgress.learningLanguage == 'Korea' 
                                  ? 'Introduction to Hangul' 
                                  : 'Introduction to English Phonics',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryPurple,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48), // Penyeimbang IconButton back
                    ],
                  ),
                ),

                // ── Scrollable Body Content ──────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Card 1: Quiz Description ─────────────────────────
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryPurple.withValues(alpha: 0.08),
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
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SvgPicture.asset(
                                    'assets/Group 36818.svg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Quiz Description',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primaryText,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      QuizProgress.learningLanguage == 'Korea'
                                          ? 'Test your understanding of basic Hangul vowels and consonants before starting this quiz challenge!'
                                          : 'Test your understanding of basic English vowels and consonants before starting this quiz challenge!',
                                      style: const TextStyle(
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

                        // ── Quiz Sections Title ──────────────────────────────
                        const Text(
                          'Quiz Sections',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ── Quiz Sections Cards Scrollable Row ───────────────
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Builder(
                            builder: (context) {
                              final int unlocked = QuizProgress.unlockedPart;
                              final int L = widget.level;
                              
                              final int part1Num = (L - 1) * 3 + 1;
                              final int part2Num = (L - 1) * 3 + 2;
                              final int part3Num = (L - 1) * 3 + 3;

                              // Menyelaraskan status active/complete sesuai data asli di aplikasi kamu
                              final bool part1Active = unlocked == (L - 1) * 5 + 2;
                              final bool part1Completed = unlocked >= (L - 1) * 5 + 3;

                              final bool part2Active = unlocked == (L - 1) * 5 + 3;
                              final bool part2Completed = unlocked >= (L - 1) * 5 + 4;

                              final bool part3Active = unlocked == (L - 1) * 5 + 5;
                              final bool part3Completed = unlocked >= (L - 1) * 5 + 6;

                              void goToQuiz(int sectionIndex) {
                                final parts = [
                                  (L - 1) * 5 + 1,
                                  (L - 1) * 5 + 2,
                                  (L - 1) * 5 + 5,
                                ];
                                if (sectionIndex < parts.length) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (_) => QuizPage(part: parts[sectionIndex]),
                                    ),
                                  );
                                }
                              }

                              return Row(
                                children: [
                                  _QuizSectionCard(
                                    partNum: 'Part $part1Num',
                                    isActive: part1Active,
                                    isCompleted: part1Completed,
                                    description: QuizProgress.learningLanguage == 'Korea'
                                        ? 'Review basic Hangul sounds and words!'
                                        : 'Review basic English sounds and words!',
                                    assetPath: 'assets/Group 36852.png',
                                    btnText: part1Completed ? 'Finish' : (part1Active ? 'Start' : 'Locked'),
                                    onBtnTap: (part1Active || part1Completed) ? () => goToQuiz(0) : () {},
                                  ),
                                  const SizedBox(width: 12),
                                  _QuizSectionCard(
                                    partNum: 'Part $part2Num',
                                    isActive: part2Active,
                                    isCompleted: part2Completed,
                                    description: QuizProgress.learningLanguage == 'Korea'
                                        ? 'Practice reading, listening, and Korean patterns!'
                                        : 'Practice reading, listening, and English patterns!',
                                    assetPath: 'assets/Group 36850.png',
                                    btnText: part2Completed ? 'Finish' : (part2Active ? 'Start' : 'Locked'),
                                    onBtnTap: (part2Active || part2Completed) ? () => goToQuiz(1) : () {},
                                  ),
                                  const SizedBox(width: 12),
                                  _QuizSectionCard(
                                    partNum: 'Part $part3Num',
                                    isActive: part3Active,
                                    isCompleted: part3Completed,
                                    description: QuizProgress.learningLanguage == 'Korea'
                                        ? 'Complete mixed Hangul quizzes and challenges!'
                                        : 'Complete mixed English quizzes and challenges!',
                                    assetPath: 'assets/Group 36850-1.svg',
                                    btnText: part3Completed ? 'Finish' : (part3Active ? 'Start' : 'Locked'),
                                    onBtnTap: (part3Active || part3Completed) ? () => goToQuiz(2) : () {},
                                  ),
                                ],
                              );
                            }
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ── Preview Reward Title ─────────────────────────────
                        const Text(
                          'Preview Reward',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ── Reward Row Cards ─────────────────────────────────
                        const Row(
                          children: [
                            Expanded(child: _RewardCard(svgAsset: 'assets/Frame 1000001490.svg', value: '20', label: 'XP')),
                            SizedBox(width: 8),
                            Expanded(child: _RewardCard(svgAsset: 'assets/noto_fire.svg', value: '1', label: 'Streak')),
                            SizedBox(width: 8),
                            Expanded(child: _RewardCard(svgAsset: 'assets/Frame 1000001486.svg', value: '5', label: 'Badges')),
                            SizedBox(width: 8),
                            Expanded(child: _RewardCard(svgAsset: 'assets/noto-v1_heart-suit.svg', value: '3', label: 'Heart')),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Helper Text bawah reward
                        const Center(
                          child: Text(
                            'Rewards will be given after completing each part!',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // ── Large Bottom Start Quiz Button ────────────────────
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryPurple,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            onPressed: () {
                              final unlocked = QuizProgress.unlockedPart;
                              final L = widget.level;
                              final List<int> parts = [
                                (L - 1) * 5 + 1,
                                (L - 1) * 5 + 2,
                                (L - 1) * 5 + 5,
                              ];
                              for (final p in parts) {
                                if (unlocked >= p) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (_) => QuizPage(part: p),
                                    ),
                                  );
                                  return;
                                }
                              }
                            },
                            child: const Text(
                              'Start Quiz!',
                              style: TextStyle(
                                fontSize: 16,
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
  final String assetPath;
  final VoidCallback onBtnTap;
  final String btnText;

  const _QuizSectionCard({
    required this.partNum,
    required this.isActive,
    required this.isCompleted,
    required this.description,
    required this.assetPath,
    required this.onBtnTap,
    required this.btnText,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLocked = !isActive && !isCompleted;
    
    return Container(
      width: 118,
      height: 185,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Part Pill Atas
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: isLocked ? const Color(0xFFEBEBEB) : const Color(0xFFF3EEFB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              partNum,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: isLocked ? AppColors.secondaryText : AppColors.primaryPurple,
              ),
            ),
          ),

          // Illustration Circle Tengah
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Color(0xFFFBF9FF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: assetPath.endsWith('.png') 
                  ? Image.asset(assetPath, width: 30, height: 30, fit: BoxFit.contain)
                  : SvgPicture.asset(assetPath, width: 30, height: 30, fit: BoxFit.contain),
            ),
          ),

          // Description Text
          Text(
            description,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
              height: 1.3,
            ),
          ),

          // Button Bawah Kartu
          GestureDetector(
            onTap: onBtnTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: isLocked ? const Color(0xFFDCD8E2) : AppColors.primaryPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLocked) ...[
                    const Icon(Icons.lock_rounded, color: Colors.white, size: 11),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    btnText,
                    style: const TextStyle(
                      fontSize: 10.5,
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
    );
  }
}

class _RewardCard extends StatelessWidget {
  final String svgAsset;
  final String value;
  final String label;

  const _RewardCard({
    required this.svgAsset,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          svgAsset.endsWith('.png')
              ? Image.asset(svgAsset, width: 24, height: 24)
              : SvgPicture.asset(svgAsset, width: 24, height: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
