import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/quiz_state.dart';
import 'package:linguago_flutter/core/constants/language_preference.dart';

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

  late final List<FunFactData> _facts;

  static const List<FunFactData> _koreanFacts = [
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

  static const List<FunFactData> _englishFacts = [
    FunFactData(
      title: "English Has Silent Letters",
      description:
          "Some English words have letters that are not pronounced, like:\n• Knee\n• Hour\n• Knife\n\nSilent letters are tricky.",
      svgAsset: "assets/Frame1000001918.svg",
    ),
    FunFactData(
      title: "\"E\" Is the Most Used Letter",
      description:
          "The letter E is the most commonly used letter in English words.\n\nYou can find it in words like:\n• See\n• People",
      svgAsset: "assets/Frame1000001904.svg",
    ),
    FunFactData(
      title: "English Words from Many Languages",
      description:
          "English has borrowed words from many languages like French, Latin, Korean, and Japanese. That's why some English words can sound and look very different.",
      svgAsset: "assets/Frame1000001911.svg",
    ),
    FunFactData(
      title: "One Letter Can Have Many Sounds",
      description:
          "English letters can sound different depending on the word.\n\nExample:\n• A in \"Name\"\n• A in \"Car\"",
      svgAsset: "assets/Frame1000001900.svg",
    ),
    FunFactData(
      title: "English Is Spoken Worldwide",
      description:
          "English is used by millions of people worldwide for communication, school, travel, and entertainment. That's why it is one of the most important international languages today.",
      svgAsset: "assets/Frame1000001909.svg",
    ),
    FunFactData(
      title: "Shortest Complete Sentence",
      description:
          "The shortest complete sentence in English is \"I am.\" It has a subject (I) and a verb (am) and makes complete sense!",
      svgAsset: "assets/Frame1000001900.svg",
    ),
    FunFactData(
      title: "Language of the Air",
      description:
          "All pilots and flight controllers must speak in English during international flights, regardless of their native country.",
      svgAsset: "assets/Frame1000001911.svg",
    ),
    FunFactData(
      title: "New Word Every 2 Hours",
      description:
          "Dictionary editors add around 4,000 new words to the English dictionary every year! That is about one new word every two hours.",
      svgAsset: "assets/Frame1000001909.svg",
    ),
    FunFactData(
      title: "The Word \"Set\" Has Many Meanings",
      description:
          "The word \"set\" has one of the highest numbers of definitions in the English dictionary, with over 400 different meanings!",
      svgAsset: "assets/Frame1000001904.svg",
    ),
    FunFactData(
      title: "Pangram Sentence",
      description:
          "The sentence \"The quick brown fox jumps over the lazy dog\" is a pangram, which means it uses every single letter of the English alphabet!",
      svgAsset: "assets/Frame1000001918.svg",
    ),
  ];

  @override
  void initState() {
    super.initState();
    final bool isEnglish = LanguagePreference.current == 'English';
    _facts = isEnglish ? _englishFacts : _koreanFacts;

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

    _swipeAnimationController.addListener(() {
      setState(() {});
    });

    _swipeAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          if (_currentIndex < _facts.length) {
            _currentIndex++;
          }
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
        _resetAnimationController.isAnimating) {
      return;
    }
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_swipeAnimationController.isAnimating ||
        _resetAnimationController.isAnimating) {
      return;
    }

    final velocity = details.velocity.pixelsPerSecond.dx;
    if (_dragOffset.dx > 120.0 || velocity > 800.0) {
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

  void _goToNext() {
    if (_currentIndex < _facts.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // Last card → complete
      setState(() {
        _currentIndex = _facts.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = _currentIndex >= _facts.length;

    // Calculate drag progress
    double progress = 0.0;
    if (_swipeAnimationController.isAnimating) {
      progress = _swipeAnimationController.value;
    } else {
      progress = (_dragOffset.dx.abs() / 150.0).clamp(0.0, 1.0);
    }

    return Scaffold(
      body: Container(
        // Soft gradient purple background — matching the screenshot
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEDE7F8),
              Color(0xFFF7F3FD),
              Color(0xFFFBF9FF),
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top Header ───────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.disableBorder,
                            width: 1.0,
                          ),
                        ),
                        child: const Icon(
                          Icons.chevron_left_rounded,
                          size: 26,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Fun Fact',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryText,
                            ),
                          ),
                          Text(
                            LanguagePreference.current == 'English'
                                ? 'Lets learn interesting things about English ✨'
                                : 'Lets learn interesting things about korea ✨',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Card Stack or Completion View ────────────────────────────────
              Expanded(
                child: isCompleted
                    ? _buildCompletionView(context)
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: _buildCards(progress),
                        ),
                      ),
              ),

              const SizedBox(height: 24),
            ],
          ),
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

        final double rotation =
            (currentOffset.dx / 1000.0).clamp(-0.15, 0.15);

        cards.add(
          Positioned.fill(
            child: GestureDetector(
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: Transform.translate(
                offset: currentOffset,
                child: Transform.rotate(
                  angle: rotation,
                  child: _buildCardContent(
                    fact,
                    isTopCard: true,
                    factIndex: factIndex,
                  ),
                ),
              ),
            ),
          ),
        );
      } else if (i == 1) {
        final double scale = 0.95 + (progress * 0.05);
        final double translateY = 14.0 - (progress * 14.0);
        final double opacity = (0.88 + (progress * 0.12)).clamp(0.0, 1.0);

        cards.add(
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(0.0, translateY),
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: opacity,
                  child: _buildCardContent(
                    fact,
                    isTopCard: false,
                    factIndex: factIndex,
                  ),
                ),
              ),
            ),
          ),
        );
      } else if (i == 2) {
        final double scale = 0.90 + (progress * 0.05);
        final double translateY = 28.0 - (progress * 14.0);
        final double opacity = (0.55 + (progress * 0.33)).clamp(0.0, 1.0);

        cards.add(
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(0.0, translateY),
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: opacity,
                  child: _buildCardContent(
                    fact,
                    isTopCard: false,
                    factIndex: factIndex,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }

    return cards;
  }

  Widget _buildCardContent(
    FunFactData fact, {
    required bool isTopCard,
    required int factIndex,
  }) {
    final bool isLastCard = factIndex == _facts.length - 1;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.primaryPurple
              .withValues(alpha: isTopCard ? 0.18 : 0.08),
          width: isTopCard ? 1.5 : 1.0,
        ),
        boxShadow: isTopCard
            ? [
                BoxShadow(
                  color: AppColors.primaryPurple.withValues(alpha: 0.12),
                  blurRadius: 28,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: AppColors.primaryPurple.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Column(
        children: [
          // ── Illustration Area ─────────────────────────────────────────────
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EEFB),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    fact.svgAsset,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // ── Text Content + Button ─────────────────────────────────────────
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Dot Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_facts.length, (index) {
                      final bool isActive = index == factIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: isActive ? 20 : 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primaryPurple
                              : const Color(0xFFD4C8FA),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 12),

                  // Fact Title
                  Text(
                    fact.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryText,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Fact Description
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        fact.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondaryText,
                          height: 1.55,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Bottom Button ────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: isTopCard
                          ? () {
                              if (isLastCard) {
                                if (QuizProgress.unlockedPart == 8) {
                                  QuizProgress.setUnlockedPart(9);
                                }
                                setState(() {
                                  _currentIndex = _facts.length;
                                });
                              } else {
                                _goToNext();
                              }
                            }
                          : null,
                      child: Text(
                        isLastCard
                            ? 'Continue to Final Quiz'
                            : 'Continue to Final Quiz',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
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

  Widget _buildCompletionView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AppColors.primaryPurple.withValues(alpha: 0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withValues(alpha: 0.1),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration top area
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EEFB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/Mascot Mascot.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('🎉', style: TextStyle(fontSize: 64));
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'You\'re Amazing! 🎉',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              LanguagePreference.current == 'English'
                  ? 'Great! You discovered 5 English Fun Facts!'
                  : 'Great! You discovered 5 Korean Fun Facts!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.secondaryText,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 20),

            // Rewards row
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EEFB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                  Container(
                    width: 1,
                    height: 20,
                    color: AppColors.disableBorder,
                  ),
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

            const SizedBox(height: 24),

            // Buttons
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
                          _currentIndex = _facts.length - 1;
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
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        if (QuizProgress.unlockedPart == 8) {
                          QuizProgress.setUnlockedPart(9);
                        }
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Finish',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
