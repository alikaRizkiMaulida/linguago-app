import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/quiz_state.dart';
import 'package:linguago_flutter/ui/screens/quiz/quiz_completed_screen.dart';
import 'package:linguago_flutter/ui/screens/quiz/quiz_failed_screen.dart';
import 'package:linguago_flutter/ui/widgets/mascot_widget.dart';
import 'package:linguago_flutter/ui/bloc/quiz/quiz_bloc.dart';

class QuizPage extends StatefulWidget {
  final int part;
  const QuizPage({super.key, this.part = 1});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    context.read<QuizBloc>().add(QuizEvent.started(part: widget.part));
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizBloc, QuizState>(
      listener: (context, state) {
        state.map(
          initial: (_) {},
          loading: (_) {},
          inProgress: (s) {
            _progressController.animateTo(
              (s.currentIndex + 1) / s.questions.length,
              curve: Curves.easeOut,
            );
          },
          completed: (s) {
            _unlockNextPart();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<void>(
                builder: (_) => QuizCompletedScreen(
                  part: widget.part,
                  correctCount: s.correctCount,
                  totalQuestions: s.totalQuestions,
                  xpEarned: s.correctCount * 4,
                  isLastPart: widget.part == 5 ||
                      widget.part == 9 ||
                      widget.part == 12 ||
                      widget.part == 15,
                ),
              ),
            );
          },
          failed: (s) {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => QuizFailedScreen(
                  correctCount: s.correctCount,
                  totalQuestions: s.totalQuestions,
                  onRetry: () =>
                      context.read<QuizBloc>().add(const QuizEvent.resetQuiz()),
                ),
              ),
            );
          },
        );
      },
      builder: (context, state) {
        return state.map(
          initial: (_) => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          loading: (_) => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          inProgress: (s) => _buildQuizContent(
            questions: s.questions,
            currentIndex: s.currentIndex,
            selectedOption: s.selectedOption,
            selectedArrangeIndices: s.selectedArrangeIndices,
            hasChecked: s.hasChecked,
            isAnswerCorrect: s.isAnswerCorrect,
            hearts: s.hearts,
            correctCount: s.correctCount,
          ),
          completed: (_) => const Scaffold(
            body: Center(child: Text('Quiz Selesai!')),
          ),
          failed: (_) => const Scaffold(
            body: Center(child: Text('Quiz Gagal!')),
          ),
        );
      },
    );
  }

  Widget _buildQuizContent({
    required List<Map<String, dynamic>> questions,
    required int currentIndex,
    int? selectedOption,
    required List<int> selectedArrangeIndices,
    required bool hasChecked,
    required bool isAnswerCorrect,
    required int hearts,
    required int correctCount,
  }) {
    final qData = questions[currentIndex];
    final qType = qData['type'] as String?;
    final isArrange = qType == 'arrange';
    final isAudioChoice = qType == 'audio_choice';
    final isImageChoice = qType == 'image_choice';
    final currentOptions = isArrange
        ? <String>[]
        : List<String>.from(qData['options'] ?? []);

    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(hearts: hearts, currentIndex: currentIndex, questionsLength: questions.length),
            _buildQuestionText(qData['text'] as String),
            if (isAudioChoice) _buildAudioPill(qData),
            if (isArrange) _buildArrangeTarget(qData),
            if (qType == 'reading' && qData['word'] != null)
              _buildReadingWord(qData),
            if (isArrange)
              _buildArrangeSection(
                letters: (qData['letters'] as List<dynamic>).cast<String>(),
                selectedArrangeIndices: selectedArrangeIndices,
              )
            else
              _buildOptionsSection(
                options: currentOptions,
                selectedOption: selectedOption,
                isImageChoice: isImageChoice,
                qData: qData,
              ),
            _buildActionButton(
              hasChecked: hasChecked,
              isAnswerCorrect: isAnswerCorrect,
              selectedOption: selectedOption,
              selectedArrangeIndices: selectedArrangeIndices,
              isArrange: isArrange,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({
    required int hearts,
    required int currentIndex,
    required int questionsLength,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.chevron_left_rounded, size: 30, color: AppColors.primaryText),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final trackWidth = constraints.maxWidth;
                return SizedBox(
                  height: 28,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE7F8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, child) {
                          return FractionallySizedBox(
                            widthFactor: _progressController.value,
                            child: Container(
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.primaryPurple,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                      ),
                      AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, child) {
                          final progress = _progressController.value;
                          const starSize = 24.0;
                          final leftPos = (trackWidth * progress) - (starSize / 2);
                          return Positioned(
                            left: leftPos,
                            top: (28 - starSize) / 2,
                            child: SvgPicture.asset(
                              'assets/ic_round-star.svg',
                              width: starSize,
                              height: starSize,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFFFFCA28),
                                BlendMode.srcIn,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              const Icon(Icons.favorite_rounded, size: 20, color: Color(0xFFEF5350)),
              const SizedBox(width: 4),
              Text(
                '$hearts',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryText,
          ),
        ),
      ),
    );
  }

  Widget _buildAudioPill(Map<String, dynamic> qData) {
    return Column(
      children: [
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3EEFB),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primaryPurple, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.volume_up_rounded, color: AppColors.primaryPurple, size: 16),
                const SizedBox(width: 6),
                Text(
                  qData['audioWord'] as String? ?? '',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryPurple,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.dotted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArrangeTarget(Map<String, dynamic> qData) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          '"${qData['target']}"',
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: AppColors.primaryPurple,
          ),
        ),
      ],
    );
  }

  Widget _buildReadingWord(Map<String, dynamic> qData) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Text(
          qData['word'] as String,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryPurple,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsSection({
    required List<String> options,
    int? selectedOption,
    required bool isImageChoice,
    required Map<String, dynamic> qData,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isImageChoice)
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.2,
                  children: List.generate(options.length, (index) {
                    final isSel = selectedOption == index;
                    final imagePath = (qData['optionImages'] as List<String>?)?[index] ?? '';
                    return GestureDetector(
                      onTap: () => context.read<QuizBloc>().add(QuizEvent.optionTapped(index: index)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSel ? AppColors.primaryPurple.withOpacity(0.1) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSel ? AppColors.primaryPurple : const Color(0xFFE0E0E0),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (imagePath.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(imagePath, height: 60, fit: BoxFit.cover),
                              ),
                            const SizedBox(height: 4),
                            Text(
                              options[index],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSel ? AppColors.primaryPurple : AppColors.primaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              )
            else
              ...List.generate(options.length, (index) {
                final isSel = selectedOption == index;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () => context.read<QuizBloc>().add(QuizEvent.optionTapped(index: index)),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isSel ? AppColors.primaryPurple.withOpacity(0.1) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSel ? AppColors.primaryPurple : const Color(0xFFE0E0E0),
                          width: isSel ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        options[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                          color: isSel ? AppColors.primaryPurple : AppColors.primaryText,
                        ),
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildArrangeSection({
    required List<String> letters,
    required List<int> selectedArrangeIndices,
  }) {
    final selectedLetters = selectedArrangeIndices.map((i) => letters[i]).toList();

    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryPurple.withOpacity(0.3)),
            ),
            child: Center(
              child: Text(
                selectedLetters.isEmpty ? '(tap letters below)' : selectedLetters.join(' '),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: selectedLetters.isEmpty ? Colors.grey : AppColors.primaryPurple,
                  letterSpacing: 4,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: List.generate(letters.length, (index) {
                  final isSelected = selectedArrangeIndices.contains(index);
                  return GestureDetector(
                    onTap: () => context.read<QuizBloc>().add(QuizEvent.letterTapped(index: index)),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryPurple.withOpacity(0.15) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryPurple : const Color(0xFFE0E0E0),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          letters[index],
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? AppColors.primaryPurple : AppColors.primaryText,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required bool hasChecked,
    required bool isAnswerCorrect,
    int? selectedOption,
    required List<int> selectedArrangeIndices,
    required bool isArrange,
  }) {
    final canCheck = isArrange
        ? selectedArrangeIndices.isNotEmpty
        : selectedOption != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: GestureDetector(
        onTap: () {
          if (!hasChecked) {
            if (canCheck) {
              context.read<QuizBloc>().add(const QuizEvent.checkAnswer());
            }
          } else {
            context.read<QuizBloc>().add(const QuizEvent.nextQuestion());
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: canCheck || hasChecked ? AppColors.primaryPurple : const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            hasChecked ? (isAnswerCorrect ? 'Correct! Next →' : 'Continue →') : 'Check',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: canCheck || hasChecked ? Colors.white : AppColors.primaryText.withOpacity(0.4),
            ),
          ),
        ),
      ),
    );
  }

  void _unlockNextPart() {
    if (widget.part == 1 && QuizProgress.unlockedPart == 2) {
      QuizProgress.setUnlockedPart(3);
    } else if (widget.part == 2 && QuizProgress.unlockedPart == 3) {
      QuizProgress.setUnlockedPart(4);
    } else if (widget.part == 5 && QuizProgress.unlockedPart == 4) {
      QuizProgress.setUnlockedPart(5);
    } else if (widget.part == 7 && QuizProgress.unlockedPart == 5) {
      QuizProgress.setUnlockedPart(6);
    } else if (widget.part == 8 && QuizProgress.unlockedPart == 6) {
      QuizProgress.setUnlockedPart(7);
    } else if (widget.part == 9 && QuizProgress.unlockedPart == 7) {
      QuizProgress.setUnlockedPart(8);
    } else if (widget.part == 10 && QuizProgress.unlockedPart == 9) {
      QuizProgress.setUnlockedPart(10);
    } else if (widget.part == 11 && QuizProgress.unlockedPart == 10) {
      QuizProgress.setUnlockedPart(11);
    } else if (widget.part == 12 && QuizProgress.unlockedPart == 11) {
      QuizProgress.setUnlockedPart(12);
    } else if (widget.part == 13 && QuizProgress.unlockedPart == 12) {
      QuizProgress.setUnlockedPart(13);
    } else if (widget.part == 14 && QuizProgress.unlockedPart == 13) {
      QuizProgress.setUnlockedPart(14);
    } else if (widget.part == 15 && QuizProgress.unlockedPart == 14) {
      QuizProgress.setUnlockedPart(15);
    }
  }
}
