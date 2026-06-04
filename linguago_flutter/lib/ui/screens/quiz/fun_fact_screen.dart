import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/quiz_state.dart';
import 'package:linguago_flutter/ui/screens/quiz/quiz_screen.dart';

class FunFactData {
  final String title;
  final String description;
  final String svgAsset;

  const FunFactData({
    required this.title,
    required this.description,
    required this.svgAsset,
  });
}

class FunFactScreen extends StatefulWidget {
  final int part;
  const FunFactScreen({super.key, this.part = 1});

  @override
  State<FunFactScreen> createState() => _FunFactScreenState();
}

class _FunFactScreenState extends State<FunFactScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  Offset _dragOffset = Offset.zero;

  late AnimationController _swipeAnimationController;
  late AnimationController _resetAnimationController;

  late Animation<Offset> _swipeAnimation;
  late Animation<Offset> _resetAnimation;

  final List<FunFactData> _facts = const [
    FunFactData(
      title: "Hangul Was Created by a King!",
      description:
          "Hangul was created by King Sejong in 1443 to help ordinary people read and write more easily. Before Hangul, Korean people used difficult Chinese characters.",
      svgAsset: "assets/Frame1000001900.svg",
    ),
    FunFactData(
      title: "Hangul Is One of the Easiest Alphabets",
      description:
          "Hangul is known as one of the easiest alphabets to learn because the letters follow simple patterns. Many beginners can start reading Korean in just a few days.",
      svgAsset: "assets/Frame1000001904.svg",
    ),
    FunFactData(
      title: "K-pop Fans Often Learn Hangul First",
      description:
          "Many international fans learning Korean through:\n• song lyrics\n• idol names\n• dramas subtitles\n\nSo, Start with Hangul first!",
      svgAsset: "assets/Frame1000001909.svg",
    ),
    FunFactData(
      title: "Korean Sounds Can Change",
      description:
          "Some Korean letters can sound slightly different depending on where they are placed in a word.\n\nExample:\nㄱ can sound like \"G\" or \"K\"",
      svgAsset: "assets/Frame1000001911.svg",
    ),
    FunFactData(
      title: "Hangul Has a Special Day in Korea",
      description:
          "South Korea celebrates Hangul Day every October 9th to honor the Korean alphabet created by King Sejong. Hangul helped many people learn to read and write more easily.",
      svgAsset: "assets/Frame1000001918.svg",
    ),
  ];

  @override
  void initState() {
    super.initState();

    _swipeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _resetAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _swipeAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _swipeAnimationController,
            curve: Curves.easeOut,
          ),
        );

    _resetAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _resetAnimationController,
            curve: Curves.easeOutBack,
          ),
        );

    // Fix: Rebuild widget while swipe animation runs to prevent freezing
    _swipeAnimationController.addListener(() {
      setState(() {});
    });

    _swipeAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentIndex++;
          _dragOffset = Offset.zero;
        });
        _swipeAnimationController.reset();
      }
    });

    _resetAnimationController.addListener(() {
      setState(() {
        _dragOffset = _resetAnimation.value;
      });
    });
  }

  @override
  void dispose() {
    _swipeAnimationController.dispose();
    _resetAnimationController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_swipeAnimationController.isAnimating ||
        _resetAnimationController.isAnimating)
      return;
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_swipeAnimationController.isAnimating ||
        _resetAnimationController.isAnimating)
      return;

    final velocity = details.velocity.pixelsPerSecond.dx;
    if (_dragOffset.dx > 120.0 || velocity > 800.0) {
      // Swipe Right
      _swipeAnimation =
          Tween<Offset>(
            begin: _dragOffset,
            end: Offset(
              500.0,
              _dragOffset.dy + (details.velocity.pixelsPerSecond.dy * 0.1),
            ),
          ).animate(
            CurvedAnimation(
              parent: _swipeAnimationController,
              curve: Curves.easeOut,
            ),
          );
      _swipeAnimationController.forward();
    } else if (_dragOffset.dx < -120.0 || velocity < -800.0) {
      // Swipe Left
      _swipeAnimation =
          Tween<Offset>(
            begin: _dragOffset,
            end: Offset(
              -500.0,
              _dragOffset.dy + (details.velocity.pixelsPerSecond.dy * 0.1),
            ),
          ).animate(
            CurvedAnimation(
              parent: _swipeAnimationController,
              curve: Curves.easeOut,
            ),
          );
      _swipeAnimationController.forward();
    } else {
      // Reset position
      _resetAnimation = Tween<Offset>(begin: _dragOffset, end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: _resetAnimationController,
              curve: Curves.easeOutBack,
            ),
          );
      _resetAnimationController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = screenWidth * 0.85;
    final bool isCompleted = _currentIndex >= _facts.length;

    // Calculate drag progress
    double progress = 0.0;
    if (_swipeAnimationController.isAnimating) {
      progress = _swipeAnimationController.value;
    } else {
      progress = (_dragOffset.dx.abs() / 150.0).clamp(0.0, 1.0);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FF),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Navigation / App Bar ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded, size: 30),
                    color: AppColors.primaryText,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Fun Fact',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryText,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Lets learn interesting things about korea ✨',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48), // Match back button width
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Interactive Card Stack or Completion view ─────────────────────
            Expanded(
              child: Center(
                child: isCompleted
                    ? _buildCompletionView(context)
                    : SizedBox(
                        width: cardWidth,
                        height: 440,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: _buildCards(progress),
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Indicators and Button (only when not completed) ──────────────
            if (!isCompleted) ...[
              // Progress Dot Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_facts.length, (index) {
                  final bool isActive = index == _currentIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primaryPurple
                          : AppColors.primaryPurple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 30),

              // Bottom Action Button
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: SizedBox(
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
                      QuizProgress.setUnlockedPart(5);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const QuizScreen(part: 5),
                        ),
                      );
                    },
                    child: const Text(
                      'Continue to Final Quiz!',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ] else ...[
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCards(double progress) {
    List<Widget> cards = [];

    // Show up to 3 cards in the stack at once
    for (int i = 2; i >= 0; i--) {
      final int factIndex = _currentIndex + i;
      if (factIndex >= _facts.length) continue;

      final FunFactData fact = _facts[factIndex];

      if (i == 0) {
        // TOP CARD: Draggable
        Offset currentOffset = _dragOffset;
        if (_swipeAnimationController.isAnimating) {
          currentOffset = _swipeAnimation.value;
        }

        // Calculate card rotation based on drag offset dx
        final double rotation = (currentOffset.dx / 1000.0).clamp(-0.15, 0.15);

        cards.add(
          Positioned.fill(
            child: GestureDetector(
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: Transform.translate(
                offset: currentOffset,
                child: Transform.rotate(
                  angle: rotation,
                  child: _buildCardContent(fact, isTopCard: true),
                ),
              ),
            ),
          ),
        );
      } else if (i == 1) {
        // MIDDLE CARD (reveals as top card slides away)
        final double scale = 0.94 + (progress * 0.06);
        final double translateY = 16.0 - (progress * 16.0);
        final double opacity = (0.85 + (progress * 0.15)).clamp(0.0, 1.0);

        cards.add(
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(0.0, translateY),
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: opacity,
                  child: _buildCardContent(fact, isTopCard: false),
                ),
              ),
            ),
          ),
        );
      } else if (i == 2) {
        // BOTTOM CARD
        final double scale = 0.88 + (progress * 0.06);
        final double translateY = 32.0 - (progress * 16.0);
        final double opacity = (0.5 + (progress * 0.35)).clamp(0.0, 1.0);

        cards.add(
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(0.0, translateY),
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: opacity,
                  child: _buildCardContent(fact, isTopCard: false),
                ),
              ),
            ),
          ),
        );
      }
    }

    return cards;
  }

  Widget _buildCardContent(FunFactData fact, {required bool isTopCard}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primaryPurple.withOpacity(isTopCard ? 0.25 : 0.15),
          width: isTopCard ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(isTopCard ? 0.15 : 0.06),
            blurRadius: isTopCard ? 24 : 12,
            spreadRadius: isTopCard ? 4 : 0,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(isTopCard ? 0.08 : 0.03),
            blurRadius: isTopCard ? 12 : 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Illustration Box
          Expanded(
            flex: 5,
            child: Center(
              child: SvgPicture.asset(fact.svgAsset, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 16),
          // Fact Title
          Text(
            fact.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryText,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          // Fact Description
          Expanded(
            flex: 4,
            child: Scrollbar(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Text(
                  fact.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondaryText,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionView(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primaryPurple.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Mascot Image on left
              Image.asset(
                'assets/Mascot Mascot.png',
                width: 80,
                height: 80,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('🐰', style: TextStyle(fontSize: 48));
                },
              ),
              const SizedBox(width: 16),
              // Congratulations Text on right
              const Expanded(
                child: Text(
                  'Great! You discovered 5 Korean Fun Facts!',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryText,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Rewards container
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3EEFB),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // XP Reward
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/Vector 46.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFFFB300),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '+20 XP',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ],
                ),
                Container(width: 1, height: 20, color: AppColors.disableBorder),
                // Badge Reward
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/game-icons_achievement.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primaryPurple,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '+1 Badge',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Action Buttons: Back & Continue to Final Quiz
          Row(
            children: [
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.primaryPurple,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _currentIndex = 4; // Reset to show the last card
                      });
                    },
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 7,
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      QuizProgress.setUnlockedPart(5);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const QuizScreen(part: 5),
                        ),
                      );
                    },
                    child: const Text(
                      'Continue to Final Quiz',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
