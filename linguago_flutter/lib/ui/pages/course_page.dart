import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/quiz_state.dart';
import 'package:linguago_flutter/ui/pages/lesson_detail_screen.dart';
import 'package:linguago_flutter/ui/screens/quiz/fun_fact_screen.dart';
import 'package:linguago_flutter/ui/screens/quiz/quiz_intro_screen.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _pinFloatController;
  final int totalSteps = 30;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && context.mounted) {
        final double screenHeight = MediaQuery.of(context).size.height;
        final double totalHeight = 150 + (totalSteps * 82.0);
        
        final int unlockedPart = QuizProgress.unlockedPart;
        final int targetIndex = (unlockedPart - 1).clamp(0, totalSteps - 1);
        
        // Node's Y position in the Stack
        final double yPos = totalHeight - 150 - (targetIndex * 82.0);
        
        // Calculate the exact offset to center the node
        // 40 is top padding of SingleChildScrollView
        // 22.5 is half of tileHeight (45/2)
        double nodeCenterY = 40 + yPos + 22.5; 
        double targetOffset = nodeCenterY - (screenHeight / 2);
        
        targetOffset = targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent);
        
        _scrollController.jumpTo(targetOffset);
      }
    });

    // Pin floating animation
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
    
    final double totalHeight = 150 + (totalSteps * 82.0);

    return Container(
      color: AppColors.backgroundSoft, // matching #F3EEFB
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 120, top: 40), // extra padding for bottom nav
              child: SizedBox(
                height: totalHeight,
                width: screenWidth,
                child: ValueListenableBuilder<int>(
                  valueListenable: QuizProgress.unlockedPartNotifier,
                  builder: (context, unlockedPart, child) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // ─────────────────────────────────────────────────────────
                        // START TEXT & DIVIDER LINES (Below the first tile)
                        // ─────────────────────────────────────────────────────────
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
                                color: const Color(0xFFD4C4F0),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'START',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.secondaryText,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              Container(
                                width: screenWidth * 0.3,
                                height: 1.5,
                                color: const Color(0xFFD4C4F0),
                              ),
                            ],
                          ),
                        ),

                        // ─────────────────────────────────────────────────────────
                        // ZIG-ZAG STEPPING STONES PATH
                        // ─────────────────────────────────────────────────────────
                        ...List.generate(totalSteps, (index) {
                          // Calculate path positions using a math curve
                          final double y = totalHeight - 220 - (index * 82.0);
                          // Zig-zag offset function
                          final double xOffset = math.sin(index * 0.8) * 85.0;
                          final double x = (screenWidth / 2) - (tileWidth / 2) + xOffset;

                          final bool isStartNode = index == 0;
                          final bool isActiveNode = index == (unlockedPart - 1);
                          final bool isLocked = index >= unlockedPart;

                          return Positioned(
                            left: x,
                            top: y,
                            child: _InteractiveTile(
                              width: tileWidth,
                              height: tileHeight,
                              isLocked: isLocked,
                              isActive: isActiveNode,
                              showArrow: isStartNode,
                              onTap: () {
                                if (!isLocked) {
                                  final int stepNum = index + 1;
                                  final int stepType = stepNum % 5;
                                  final int levelNum = (index ~/ 5) + 1;

                                  if (stepType == 1) {
                                    // Step 1: Lesson Summary
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (_) => LessonDetailScreen(part: stepNum),
                                      ),
                                    ).then((_) => setState(() {}));
                                  } else if (stepType == 2 || stepType == 3 || stepType == 0) {
                                    // Step 2, 3, 5: Quiz Intro Screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (_) => QuizIntroScreen(level: levelNum),
                                      ),
                                    ).then((_) => setState(() {}));
                                  } else if (stepType == 4) {
                                    // Step 4: Fun Fact Screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (_) => FunFactScreen(part: stepNum),
                                      ),
                                    ).then((_) => setState(() {}));
                                  }
                                }
                              },
                            ),
                          );
                        }),

                        // ─────────────────────────────────────────────────────────
                        // BOBBING MAP PIN MARKER (On the active Level 1 node)
                        // ─────────────────────────────────────────────────────────
                        AnimatedBuilder(
                          animation: _pinFloatController,
                          builder: (context, child) {
                            final int pinIndex = (unlockedPart - 1).clamp(0, totalSteps - 1);
                            final double y = totalHeight - 220 - (pinIndex * 82.0);
                            final double xOffset = math.sin(pinIndex * 0.8) * 85.0;
                            final double x = (screenWidth / 2) + xOffset;

                            // Bobbing offset
                            final floatOffset = math.sin(_pinFloatController.value * math.pi) * 8.0;

                            return Positioned(
                              left: x - 18, // center horizontally on tile (half of 36)
                              top: y - 36 + floatOffset, // sit right on the tile
                              child: GestureDetector(
                                onTap: () {
                                  final int unlocked = QuizProgress.unlockedPart;
                                  final int stepType = unlocked % 5;
                                  final int levelNum = ((unlocked - 1) ~/ 5) + 1;

                                  if (stepType == 1) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (_) => LessonDetailScreen(part: unlocked),
                                      ),
                                    ).then((_) => setState(() {}));
                                  } else if (stepType == 2 || stepType == 3 || stepType == 0) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (_) => QuizIntroScreen(level: levelNum),
                                      ),
                                    ).then((_) => setState(() {}));
                                  } else if (stepType == 4) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (_) => FunFactScreen(part: unlocked),
                                      ),
                                    ).then((_) => setState(() {}));
                                  }
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const Icon(
                                      Icons.location_on_rounded,
                                      size: 36,
                                      color: AppColors.primaryPurple,
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
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InteractiveTile extends StatefulWidget {
  final double width;
  final double height;
  final bool isLocked;
  final bool isActive;
  final bool showArrow;
  final VoidCallback onTap;

  const _InteractiveTile({
    required this.width,
    required this.height,
    required this.isLocked,
    required this.isActive,
    required this.showArrow,
    required this.onTap,
  });

  @override
  State<_InteractiveTile> createState() => _InteractiveTileState();
}

class _InteractiveTileState extends State<_InteractiveTile> with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(_pressController);
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => widget.isLocked ? null : _pressController.forward(),
        onTapUp: (_) {
          if (!widget.isLocked) {
            _pressController.reverse();
            widget.onTap();
          }
        },
        onTapCancel: () => widget.isLocked ? null : _pressController.reverse(),
        child: CustomPaint(
          size: Size(widget.width, widget.height + 15), // add extra height for 3D depth
          painter: _IsometricTilePainter(
            isLocked: widget.isLocked,
            isActive: widget.isActive,
            showArrow: widget.showArrow,
          ),
        ),
      ),
    );
  }
}

class _IsometricTilePainter extends CustomPainter {
  final bool isLocked;
  final bool isActive;
  final bool showArrow;

  _IsometricTilePainter({
    required this.isLocked,
    required this.isActive,
    required this.showArrow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height - 12; // reserving 12px for depth
    final double depth = 10;
    final double cX = w / 2;
    final double cY = h / 2;

    // Define colors based on state
    Color topColor;
    Color sideLeftColor;
    Color sideRightColor;

    if (isLocked) {
      // Locked/grey tile matching the mockup exactly
      topColor = const Color(0xFFC0B9D1);
      sideLeftColor = const Color(0xFFAEA7C0);
      sideRightColor = const Color(0xFF9E97B1);
    } else {
      // Unlocked or start/active node tile matching the mockup exactly
      topColor = const Color(0xFFB9ACE3);
      sideLeftColor = const Color(0xFFA79AD1);
      sideRightColor = const Color(0xFF9689C0);
    }

    final Paint fillPaint = Paint()..style = PaintingStyle.fill;
    
    // Glowing border styles (neon styling)
    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeJoin = StrokeJoin.round
      ..color = Colors.white.withValues(alpha: 0.95);

    final Paint edgeGlowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeJoin = StrokeJoin.round
      ..color = const Color(0xFFE4D9F6).withValues(alpha: 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);

    // ── Ambient Glow (Active/Unlocked) ───────────────────────────────────────
    if (!isLocked) {
      final Paint glowPaint = Paint()
        ..color = const Color(0xFFB9ACE3).withValues(alpha: 0.45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cX, cY + 4), width: w * 1.15, height: h * 1.15),
        glowPaint,
      );
    }

    // ── Drop Shadow (Standard) ───────────────────────────────────────────────
    final Paint shadowPaint = Paint()..color = const Color(0xFF1C1135).withValues(alpha: 0.06);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cX, cY + depth + 4), width: w * 0.95, height: h * 0.95),
      shadowPaint,
    );

    // ── Left Side Face (3D Depth) ────────────────────────────────────────────
    final Path leftSide = Path()
      ..moveTo(0, cY)
      ..lineTo(cX, h)
      ..lineTo(cX, h + depth)
      ..lineTo(0, cY + depth)
      ..close();
    fillPaint.color = sideLeftColor;
    canvas.drawPath(leftSide, fillPaint);

    // ── Right Side Face (3D Depth) ───────────────────────────────────────────
    final Path rightSide = Path()
      ..moveTo(cX, h)
      ..lineTo(w, cY)
      ..lineTo(w, cY + depth)
      ..lineTo(cX, h + depth)
      ..close();
    fillPaint.color = sideRightColor;
    canvas.drawPath(rightSide, fillPaint);

    // ── Top Face Rhombus ─────────────────────────────────────────────────────
    final Path topFace = Path()
      ..moveTo(cX, 0)
      ..lineTo(w, cY)
      ..lineTo(cX, h)
      ..lineTo(0, cY)
      ..close();
    fillPaint.color = topColor;
    canvas.drawPath(topFace, fillPaint);
    
    // Draw neon border glow first, then sharp border on top
    canvas.drawPath(topFace, edgeGlowPaint);
    canvas.drawPath(topFace, borderPaint);

    // ── Draw Bottom Glowing Highlight Edge ────────────────────────────────────
    final Paint bottomGlowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = isLocked
          ? const Color(0xFFD6D3DF).withValues(alpha: 0.2)
          : const Color(0xFFE4D9F6).withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);

    final Paint highlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = isLocked
          ? const Color(0xFFD6D3DF).withValues(alpha: 0.4)
          : const Color(0xFFE4D9F6).withValues(alpha: 0.9);

    final Path bottomHighlight = Path()
      ..moveTo(0, cY + depth)
      ..lineTo(cX, h + depth)
      ..lineTo(w, cY + depth);

    // Draw neon bottom glow, then sharp highlight line on top
    canvas.drawPath(bottomHighlight, bottomGlowPaint);
    canvas.drawPath(bottomHighlight, highlightPaint);

    // ── Draw Double Chevron inside first tile ─────────────────────────────────
    if (showArrow) {
      final Paint arrowPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      // Draw outer chevron pointing up-right
      final Path chevron1 = Path()
        ..moveTo(cX - 1, cY - 7)
        ..lineTo(cX + 7, cY - 3)
        ..lineTo(cX + 3, cY + 5);
      canvas.drawPath(chevron1, arrowPaint);

      // Draw inner chevron pointing up-right (nested behind)
      final Path chevron2 = Path()
        ..moveTo(cX - 9, cY - 3)
        ..lineTo(cX - 1, cY + 1)
        ..lineTo(cX - 5, cY + 9);
      canvas.drawPath(chevron2, arrowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
