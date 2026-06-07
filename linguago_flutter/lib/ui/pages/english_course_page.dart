import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/quiz_state.dart';
import 'package:linguago_flutter/ui/pages/english_lesson_detail_screen.dart';
import 'package:linguago_flutter/ui/screens/quiz/fun_fact_screen.dart';
import 'package:linguago_flutter/ui/screens/quiz/quiz_intro_screen.dart';

/// Course page for English — same isometric map layout as the Korean one
/// but with English-themed colours (blue accent) and English lesson screens.
class EnglishCoursePage extends StatefulWidget {
  const EnglishCoursePage({super.key});

  @override
  State<EnglishCoursePage> createState() => _EnglishCoursePageState();
}

class _EnglishCoursePageState extends State<EnglishCoursePage>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _pinFloatController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });

    _pinFloatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pinFloatController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double tileWidth = 90;
    const double tileHeight = 45;
    const int totalSteps = 13;

    return Container(
      color: const Color(0xFFF0F4FF), // English blue-tinted background
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 120, top: 40),
              child: SizedBox(
                height: 1250,
                width: screenWidth,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // ── START label ──────────────────────────────────────────
                    Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: screenWidth * 0.3,
                            height: 1.5,
                            color: const Color(0xFFB8C7F0),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'START',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF8FA3D0),
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          Container(
                            width: screenWidth * 0.3,
                            height: 1.5,
                            color: const Color(0xFFB8C7F0),
                          ),
                        ],
                      ),
                    ),

                    // ── Zig-zag tiles ────────────────────────────────────────
                    ...List.generate(totalSteps, (index) {
                      final double y = 1100 - (index * 82.0);
                      final double xOffset = math.sin(index * 0.8) * 85.0;
                      final double x =
                          (screenWidth / 2) - (tileWidth / 2) + xOffset;

                      final int unlockedPart = QuizProgress.unlockedPart;
                      final int mapUnlocked = QuizProgress.getMapUnlocked(unlockedPart);

                      final bool isStartNode = index == 0;
                      final bool isActiveNode = index == (mapUnlocked - 1);
                      final bool isLocked = index >= mapUnlocked;

                      return Positioned(
                        left: x,
                        top: y,
                        child: _EnglishTile(
                          width: tileWidth,
                          height: tileHeight,
                          isLocked: isLocked,
                          isActive: isActiveNode,
                          showArrow: isStartNode,
                          onTap: () {
                            if (!isLocked) {
                              if (index == 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                      builder: (_) => const EnglishLessonDetailScreen(part: 1)),
                                ).then((_) => setState(() {}));
                              } else if (index == 1) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(builder: (_) => const QuizIntroScreen(boxLevel: 2)),
                                ).then((_) => setState(() {}));
                              } else if (index == 2) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(builder: (_) => const QuizIntroScreen(boxLevel: 3)),
                                ).then((_) => setState(() {}));
                              } else if (index == 3) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(builder: (_) => const FunFactScreen(part: 4)),
                                ).then((_) => setState(() {}));
                              } else if (index == 4) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(builder: (_) => const QuizIntroScreen(boxLevel: 5)),
                                ).then((_) => setState(() {}));
                              } else if (index == 5) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(builder: (_) => const QuizIntroScreen(boxLevel: 6)),
                                ).then((_) => setState(() {}));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Coming soon! Stay tuned!'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      );
                    }),

                    // ── Bobbing map pin ──────────────────────────────────────
                    AnimatedBuilder(
                      animation: _pinFloatController,
                      builder: (context, child) {
                        final int unlocked = QuizProgress.unlockedPart;
                        final int mapUnlocked = QuizProgress.getMapUnlocked(unlocked);
                        final int pinIndex = mapUnlocked - 1;

                        final double y = 1100 - (pinIndex * 82.0);
                        final double xOffset =
                            math.sin(pinIndex * 0.8) * 85.0;
                        final double x = (screenWidth / 2) + xOffset;
                        final floatOffset =
                            math.sin(_pinFloatController.value * math.pi) *
                                8.0;

                        return Positioned(
                          left: x - 18,
                          top: y - 36 + floatOffset,
                          child: GestureDetector(
                            onTap: () {
                              if (unlocked == 1) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                      builder: (_) => const EnglishLessonDetailScreen(part: 1)),
                                ).then((_) => setState(() {}));
                              } else if (unlocked >= 2 && unlocked <= 4) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(builder: (_) => const QuizIntroScreen(boxLevel: 2)),
                                ).then((_) => setState(() {}));
                              } else if (unlocked >= 5 && unlocked <= 7) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(builder: (_) => const QuizIntroScreen(boxLevel: 3)),
                                ).then((_) => setState(() {}));
                              } else if (unlocked == 8) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(builder: (_) => const FunFactScreen(part: 4)),
                                ).then((_) => setState(() {}));
                              } else if (unlocked >= 9 && unlocked <= 11) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(builder: (_) => const QuizIntroScreen(boxLevel: 5)),
                                ).then((_) => setState(() {}));
                              } else if (unlocked >= 12 && unlocked <= 14) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(builder: (_) => const QuizIntroScreen(boxLevel: 6)),
                                ).then((_) => setState(() {}));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Coming soon! Stay tuned!'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  size: 36,
                                  color: Color(0xFF3B5BDB),
                                ),
                                Positioned(
                                  top: 7,
                                  child: Container(
                                    width: 9,
                                    height: 9,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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

// ─────────────────────────────────────────────────────────────────────────────
// English tile — same geometry as Korean but with blue palette
// ─────────────────────────────────────────────────────────────────────────────
class _EnglishTile extends StatefulWidget {
  final double width;
  final double height;
  final bool isLocked;
  final bool isActive;
  final bool showArrow;
  final VoidCallback onTap;

  const _EnglishTile({
    required this.width,
    required this.height,
    required this.isLocked,
    required this.isActive,
    required this.showArrow,
    required this.onTap,
  });

  @override
  State<_EnglishTile> createState() => _EnglishTileState();
}

class _EnglishTileState extends State<_EnglishTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(_pressCtrl);
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => widget.isLocked ? null : _pressCtrl.forward(),
        onTapUp: (_) {
          if (!widget.isLocked) {
            _pressCtrl.reverse();
            widget.onTap();
          }
        },
        onTapCancel: () => widget.isLocked ? null : _pressCtrl.reverse(),
        child: CustomPaint(
          size: Size(widget.width, widget.height + 15),
          painter: _EnglishTilePainter(
            isLocked: widget.isLocked,
            isActive: widget.isActive,
            showArrow: widget.showArrow,
          ),
        ),
      ),
    );
  }
}

class _EnglishTilePainter extends CustomPainter {
  final bool isLocked;
  final bool isActive;
  final bool showArrow;

  const _EnglishTilePainter({
    required this.isLocked,
    required this.isActive,
    required this.showArrow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height - 12;
    final double depth = 10;
    final double cX = w / 2;
    final double cY = h / 2;

    Color topColor;
    Color sideLeftColor;
    Color sideRightColor;

    if (isLocked) {
      // Grey-blue locked tiles
      topColor = const Color(0xFFBEC8E4);
      sideLeftColor = const Color(0xFFADB8D4);
      sideRightColor = const Color(0xFF9DAAC4);
    } else {
      // Unlocked — blue palette
      topColor = const Color(0xFF7FA7E8);
      sideLeftColor = const Color(0xFF6090D4);
      sideRightColor = const Color(0xFF5080C0);
    }

    final fillPaint = Paint()..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeJoin = StrokeJoin.round
      ..color = Colors.white.withOpacity(0.95);
    final edgeGlowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeJoin = StrokeJoin.round
      ..color = const Color(0xFFADC8F6).withOpacity(0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);

    // Ambient glow for unlocked tiles
    if (!isLocked) {
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cX, cY + 4), width: w * 1.15, height: h * 1.15),
        Paint()
          ..color = const Color(0xFF5B8AE8).withOpacity(0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
      );
    }

    // Drop shadow
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cX, cY + depth + 4),
          width: w * 0.95,
          height: h * 0.95),
      Paint()..color = const Color(0xFF1C1135).withOpacity(0.06),
    );

    // Left side
    final leftSide = Path()
      ..moveTo(0, cY)
      ..lineTo(cX, h)
      ..lineTo(cX, h + depth)
      ..lineTo(0, cY + depth)
      ..close();
    fillPaint.color = sideLeftColor;
    canvas.drawPath(leftSide, fillPaint);

    // Right side
    final rightSide = Path()
      ..moveTo(cX, h)
      ..lineTo(w, cY)
      ..lineTo(w, cY + depth)
      ..lineTo(cX, h + depth)
      ..close();
    fillPaint.color = sideRightColor;
    canvas.drawPath(rightSide, fillPaint);

    // Top face
    final topFace = Path()
      ..moveTo(cX, 0)
      ..lineTo(w, cY)
      ..lineTo(cX, h)
      ..lineTo(0, cY)
      ..close();
    fillPaint.color = topColor;
    canvas.drawPath(topFace, fillPaint);
    canvas.drawPath(topFace, edgeGlowPaint);
    canvas.drawPath(topFace, borderPaint);

    // Bottom highlight
    final bottomHL = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..color = isLocked
          ? const Color(0xFFD6DCEC).withOpacity(0.2)
          : const Color(0xFFADC8F6).withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
    final bottomLine = Path()
      ..moveTo(0, cY + depth)
      ..lineTo(cX, h + depth)
      ..lineTo(w, cY + depth);
    canvas.drawPath(bottomLine, bottomHL);
    canvas.drawPath(
      bottomLine,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..color = isLocked
            ? const Color(0xFFD6DCEC).withOpacity(0.4)
            : const Color(0xFFADC8F6).withOpacity(0.9),
    );

    // Chevron arrows on start tile
    if (showArrow) {
      final arrowPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(
        Path()
          ..moveTo(cX - 1, cY - 7)
          ..lineTo(cX + 7, cY - 3)
          ..lineTo(cX + 3, cY + 5),
        arrowPaint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(cX - 9, cY - 3)
          ..lineTo(cX - 1, cY + 1)
          ..lineTo(cX - 5, cY + 9),
        arrowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
