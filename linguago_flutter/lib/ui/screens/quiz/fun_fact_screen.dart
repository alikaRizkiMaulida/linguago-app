import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/quiz_state.dart';
import 'package:linguago_flutter/ui/screens/quiz/quiz_intro_screen.dart';

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

  static const List<FunFactData> _factsKorea = [
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
  ];

  static const List<FunFactData> _factsEnglish = [
    FunFactData(
      title: "English is a Germanic Language!",
      description:
          "Although many English words come from French or Latin, English is actually a Germanic language closely related to German and Dutch!",
      svgAsset: "assets/card 22.svg",
    ),
    FunFactData(
      title: "The Most Common Letter is 'E'",
      description:
          "The letter 'E' is the most commonly used letter in the English language, appearing in about 11% of all words, while 'Q' is the rarest!",
      svgAsset: "assets/card 24.svg",
    ),
    FunFactData(
      title: "Shakespeare Added 1,700 Words!",
      description:
          "William Shakespeare invented or introduced over 1,700 words to the English language, including words like 'fashionable', 'lonely', and 'gloomy'!",
      svgAsset: "assets/card 26.svg",
    ),
    FunFactData(
      title: "A Sentence with All 26 Letters!",
      description:
          "A sentence that contains every letter in the alphabet is called a 'pangram'. The most famous example is:\n'The quick brown fox jumps over the lazy dog'!",
      svgAsset: "assets/card 28.svg",
    ),
    FunFactData(
      title: "The Shortest Complete Sentence",
      description:
          "The shortest grammatically correct and complete sentence in English is 'I am.', followed closely by commands like 'Go!' which have an understood subject.",
      svgAsset: "assets/card 30.svg",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _facts = QuizProgress.learningLanguage == 'Korea'
        ? _factsKorea
        : _factsEnglish;

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
          _currentIndex++;
          _dragOffset = Offset.zero;
        });
        _swipeAnimationController.reset();
        if (_currentIndex >= _facts.length) {
          _navigateToQuizIntro();
        }
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

  void _navigateToQuizIntro() {
    if (!mounted) return;
    if (QuizProgress.unlockedPart == widget.part) {
      QuizProgress.setUnlockedPart(widget.part + 1);
    }
    final int levelNum = ((widget.part - 1) ~/ 5) + 1;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (_) => QuizIntroScreen(level: levelNum),
      ),
    );
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
                            QuizProgress.learningLanguage == 'Korea'
                                ? 'Lets learn interesting things about korea ✨'
                                : 'Lets learn interesting things about English ✨',
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
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(left: 36, right: 36, top: 60, bottom: 20),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: _buildCards(progress),
                        ),
                      ),
              ),

              // Bottom Button
              if (!isCompleted)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      onPressed: _navigateToQuizIntro,
                      child: const Text(
                        'Continue to Final Quiz',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCards(double progress) {
    List<Widget> cards = [];
    final int remaining = _facts.length - _currentIndex;

    // Build from bottom of stack (highest index) to top (index 0)
    for (int i = remaining - 1; i >= 0; i--) {
      final int factIndex = _currentIndex + i;
      final FunFactData fact = _facts[factIndex];

      if (i == 0) {
        // TOP CARD: Draggable
        Offset currentOffset = _dragOffset;
        if (_swipeAnimationController.isAnimating) {
          currentOffset = _swipeAnimation.value;
        }

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
                  child: _buildCardContent(fact),
                ),
              ),
            ),
          ),
        );
      } else {
        // CARDS BEHIND
        final double effectiveI = i - progress;
        final double scale = (1.0 - (effectiveI * 0.05)).clamp(0.8, 1.0);
        final double translateY = - (effectiveI * 14.0);
        
        // Alternating rotation for a messy stack effect
        final double targetRot = (factIndex % 2 != 0) ? 0.03 : -0.03;

        cards.add(
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(0.0, translateY),
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.topCenter,
                child: Transform.rotate(
                  angle: targetRot,
                  child: _buildCardContent(fact),
                ),
              ),
            ),
          ),
        );
      }
    }

    return cards;
  }

  Widget _buildCardContent(FunFactData fact) {
    return Center(
      child: AspectRatio(
        aspectRatio: 257 / 340,
        child: SvgPicture.asset(
          fact.svgAsset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
