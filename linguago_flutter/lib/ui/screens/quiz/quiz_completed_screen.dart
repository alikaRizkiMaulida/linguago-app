import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/quiz_state.dart';
import 'package:linguago_flutter/core/constants/language_preference.dart';

class QuizCompletedScreen extends StatefulWidget {
  final int part;
  final int correctCount;
  final int totalQuestions;
  final int xpEarned;
  /// Jika true, tombol Exit akan kembali ke level map (popUntil first).
  /// Jika false (default), tombol Exit hanya pop ke QuizIntroScreen.
  final bool isLastPart;

  const QuizCompletedScreen({
    super.key,
    this.part = 1,
    required this.correctCount,
    required this.totalQuestions,
    required this.xpEarned,
    this.isLastPart = false,
  });

  @override
  State<QuizCompletedScreen> createState() => _QuizCompletedScreenState();
}

class _QuizCompletedScreenState extends State<QuizCompletedScreen> with TickerProviderStateMixin {
  late AnimationController _confettiController;
  late AnimationController _zoomController;
  
  bool _isZoomed = false; // switches mascot from small to large (exciting)
  List<_ConfettiParticle> _particles = [];
  final math.Random _random = math.Random();

  String _getSmallMascotAsset() {
    switch (widget.part) {
      case 2:
        return 'assets/Group 36776.svg';
      case 3:
        return 'assets/Group 36780.svg';
      default:
        return 'assets/Group 36716.svg';
    }
  }

  String _getExcitingMascotAsset() {
    switch (widget.part) {
      case 2:
        return 'assets/Group 36776-1.svg';
      case 3:
        return 'assets/Group 36781.svg';
      default:
        return 'assets/Group 61.svg';
    }
  }

  @override
  void initState() {
    super.initState();
    // Credit earned XP immediately
    QuizProgress.setXp(QuizProgress.xp + widget.xpEarned);
    
    // Zoom/excitement controller
    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Confetti physics controller
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // Trigger zoom & confetti transition after a delay of 800ms
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isZoomed = true;
        });
        _zoomController.forward();
        _generateConfetti();
        _confettiController.repeat();
      }
    });
  }

  @override
  void dispose() {
    _zoomController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _generateConfetti() {
    _particles = List.generate(80, (index) {
      return _ConfettiParticle(
        x: _random.nextDouble() * 400, // will scale during paint
        y: -_random.nextDouble() * 300,
        color: _getRandomColor(),
        size: _random.nextDouble() * 8 + 6,
        speedY: _random.nextDouble() * 3 + 2,
        speedX: _random.nextDouble() * 2 - 1,
        rotation: _random.nextDouble() * 2 * math.pi,
        rotationSpeed: _random.nextDouble() * 0.1 - 0.05,
        shape: _random.nextBool() ? _ConfettiShape.rectangle : _ConfettiShape.circle,
      );
    });
  }

  Color _getRandomColor() {
    final colors = [
      const Color(0xFFFF4081), // Pink
      const Color(0xFF00E5FF), // Cyan
      const Color(0xFFFFEA00), // Yellow
      const Color(0xFFFF9100), // Orange
      const Color(0xFF651FFF), // Purple
      const Color(0xFF00E676), // Green
    ];
    return colors[_random.nextInt(colors.length)];
  }

  void _showRewardsDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            width: 320,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Rewards from this quiz',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  LanguagePreference.current == 'English'
                      ? 'English Concept - Part ${widget.part}'
                      : 'Hangul Concept - Part ${widget.part}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryPurple,
                  ),
                ),
                const SizedBox(height: 20),

                // Rewards Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildRewardBadge('assets/Vector 46.svg', 'XP', '${widget.xpEarned}', const Color(0xFFFFB300)),
                    _buildRewardBadge('assets/noto_fire.svg', 'Streak', '1', Colors.transparent, useColorFilter: false),
                    _buildRewardBadge('assets/game-icons_achievement.svg', 'Badges', '5', const Color(0xFFFFC107)),
                    _buildRewardBadge('assets/icon-park-outline_love-and-help.svg', 'Heart', '3', const Color(0xFFE57373)),
                  ],
                ),
                const SizedBox(height: 24),
 
                // Exit Button
                 SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      // Pop dialog dulu
                      Navigator.pop(context);
                      if (widget.isLastPart) {
                        // Part terakhir selesai → kembali ke level map (first route)
                        Navigator.popUntil(context, (route) => route.isFirst);
                      } else {
                        // Part 1 / Part 2 selesai → kembali ke QuizIntroScreen
                        // Stack: QuizIntroScreen > QuizScreen > QuizCompletedScreen
                        // Pop QuizCompletedScreen, lalu pop QuizScreen → tiba di QuizIntroScreen
                        Navigator.pop(context); // pop QuizCompletedScreen
                        Navigator.pop(context); // pop QuizScreen
                      }
                    },
                    child: const Text(
                      'Exit',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
 
  Widget _buildRewardBadge(String svgAsset, String label, String value, Color color, {bool useColorFilter = true}) {
    return Container(
      width: 62,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDE7F8), width: 1),
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            svgAsset,
            width: 20,
            height: 20,
            colorFilter: useColorFilter ? ColorFilter.mode(color, BlendMode.srcIn) : null,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      body: SafeArea(
        child: Stack(
          children: [
            // ── Confetti Particle Canvas ─────────────────────────────────────
            if (_isZoomed)
              AnimatedBuilder(
                animation: _confettiController,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(screenWidth, double.infinity),
                    painter: _ConfettiPainter(
                      particles: _particles,
                      screenWidth: screenWidth,
                    ),
                  );
                },
              ),
 
            // ── Main Content ─────────────────────────────────────────────────
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                
                // Mascot Zoom Animation Block
                Center(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutBack,
                    child: SizedBox(
                      width: _isZoomed ? 248 : 170,
                      height: _isZoomed ? 160 : 110,
                      child: _isZoomed
                          ? SvgPicture.asset(
                              _getExcitingMascotAsset(),
                              fit: BoxFit.contain,
                            )
                          : SvgPicture.asset(
                              _getSmallMascotAsset(),
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Title Text
                Text(
                  'Quiz Completed',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 6),

                // Subtitle Text
                Text(
                  LanguagePreference.current == 'English'
                      ? 'English Concept - Part ${widget.part}'
                      : 'Hangul Concept - Part ${widget.part}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryPurple,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Accuracy: ${((widget.correctCount / widget.totalQuestions) * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.secondaryText,
                  ),
                ),

                const Spacer(flex: 3),

                // ── Claim Rewards Bottom Button ──────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _showRewardsDialog,
                      child: const Text(
                        'Claim Rewards',
                        style: TextStyle(
                          fontSize: 14,
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
      ),
    );
  }
}

enum _ConfettiShape { rectangle, circle }

class _ConfettiParticle {
  double x;
  double y;
  final Color color;
  final double size;
  final double speedY;
  final double speedX;
  double rotation;
  final double rotationSpeed;
  final _ConfettiShape shape;

  _ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.speedY,
    required this.speedX,
    required this.rotation,
    required this.rotationSpeed,
    required this.shape,
  });

  void update(double screenWidth) {
    y += speedY;
    x += speedX;
    rotation += rotationSpeed;

    // Reset if it goes off screen
    if (y > 900) {
      y = -50;
      x = math.Random().nextDouble() * screenWidth;
    }
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double screenWidth;

  _ConfettiPainter({required this.particles, required this.screenWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;

    for (var p in particles) {
      p.update(screenWidth);

      paint.color = p.color;

      canvas.save();
      canvas.translate(p.x, p.y);
      canvas.rotate(p.rotation);

      if (p.shape == _ConfettiShape.rectangle) {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
          paint,
        );
      } else {
        canvas.drawCircle(Offset.zero, p.size * 0.4, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
