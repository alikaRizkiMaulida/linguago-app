import 'dart:math' as math;
import 'package:flutter/material.dart';

enum MascotPose { teaching, listening, success, fail, confused, reading }

class MascotWidget extends StatefulWidget {
  final MascotPose pose;
  final double size;

  const MascotWidget({
    super.key,
    required this.pose,
    this.size = 150,
  });

  @override
  State<MascotWidget> createState() => _MascotWidgetState();
}

class _MascotWidgetState extends State<MascotWidget> with TickerProviderStateMixin {
  late AnimationController _wingController;
  late AnimationController _pulseController;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    // Wing flapping animation
    _wingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    // Pulse animation for sound waves (listening)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    // Bobbing/floating animation for mascot
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _wingController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_wingController, _pulseController, _floatController]),
      builder: (context, child) {
        final floatOffset = math.sin(_floatController.value * math.pi) * 6.0;
        final wingAngle = -0.15 + (_wingController.value * 0.35); // Wing flap angle in radians

        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: MascotPainter(
              pose: widget.pose,
              wingAngle: wingAngle,
              pulseValue: _pulseController.value,
            ),
          ),
        );
      },
    );
  }
}

class MascotPainter extends CustomPainter {
  final MascotPose pose;
  final double wingAngle;
  final double pulseValue;

  MascotPainter({
    required this.pose,
    required this.wingAngle,
    required this.pulseValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cX = w / 2;
    final double cY = h / 2 + 5; // offset body down slightly to fit wings/waves
    final double r = w * 0.28; // main body radius

    final Paint fillPaint = Paint()..style = PaintingStyle.fill;
    final Paint strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.02
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF1C1135);

    // ─────────────────────────────────────────────────────────────────────────
    // DRAW SOUNDWAVES (Listening Pose)
    // ─────────────────────────────────────────────────────────────────────────
    if (pose == MascotPose.listening) {
      final Paint wavePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.015
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < 3; i++) {
        final double wavePulse = (pulseValue + i / 3.0) % 1.0;
        final double waveRadius = r * 1.2 + (wavePulse * r * 0.6);
        final double opacity = 1.0 - wavePulse;
        wavePaint.color = const Color(0xFFAA86E7).withOpacity(opacity * 0.6);

        // Left ear waves
        canvas.drawArc(
          Rect.fromCircle(center: Offset(cX - r, cY - r * 0.5), radius: waveRadius),
          math.pi * 0.95,
          math.pi * 0.5,
          false,
          wavePaint,
        );

        // Right ear waves
        canvas.drawArc(
          Rect.fromCircle(center: Offset(cX + r, cY - r * 0.5), radius: waveRadius),
          -math.pi * 0.45,
          math.pi * 0.5,
          false,
          wavePaint,
        );
      }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // DRAW WINGS
    // ─────────────────────────────────────────────────────────────────────────
    final wingColor = const Color(0xFF8C65D1);
    final wingColorDark = const Color(0xFF7C55C5);

    // Left Wing
    canvas.save();
    canvas.translate(cX - r * 0.8, cY);
    // Adjust flapping angle based on pose
    double finalLeftAngle = -wingAngle;
    if (pose == MascotPose.fail) {
      finalLeftAngle = 0.3; // droopy
    } else if (pose == MascotPose.reading) {
      finalLeftAngle = -0.1; // reading book, wings slightly wrapped forward
    }
    canvas.rotate(finalLeftAngle);

    final Path leftWingPath = Path()
      ..moveTo(0, 0)
      ..cubicTo(-r * 0.8, -r * 0.7, -r * 1.6, -r * 0.3, -r * 1.7, r * 0.2)
      ..cubicTo(-r * 1.3, r * 0.5, -r * 0.9, r * 0.2, -r * 0.8, r * 0.5)
      ..cubicTo(-r * 0.5, r * 0.5, -r * 0.3, r * 0.2, 0, 0)
      ..close();

    fillPaint.color = wingColor;
    canvas.drawPath(leftWingPath, fillPaint);
    canvas.drawPath(leftWingPath, strokePaint);

    // Inner detail
    final Path leftWingDetail = Path()
      ..moveTo(-r * 0.2, -r * 0.1)
      ..cubicTo(-r * 0.7, -r * 0.5, -r * 1.3, -r * 0.2, -r * 1.4, r * 0.1)
      ..cubicTo(-r * 1.1, r * 0.3, -r * 0.8, r * 0.1, -r * 0.7, r * 0.3)
      ..close();
    fillPaint.color = wingColorDark;
    canvas.drawPath(leftWingDetail, fillPaint);
    canvas.restore();

    // Right Wing
    canvas.save();
    canvas.translate(cX + r * 0.8, cY);
    double finalRightAngle = wingAngle;
    if (pose == MascotPose.fail) {
      finalRightAngle = -0.3;
    } else if (pose == MascotPose.reading) {
      finalRightAngle = 0.1;
    }
    canvas.rotate(finalRightAngle);

    final Path rightWingPath = Path()
      ..moveTo(0, 0)
      ..cubicTo(r * 0.8, -r * 0.7, r * 1.6, -r * 0.3, r * 1.7, r * 0.2)
      ..cubicTo(r * 1.3, r * 0.5, r * 0.9, r * 0.2, r * 0.8, r * 0.5)
      ..cubicTo(r * 0.5, r * 0.5, r * 0.3, r * 0.2, 0, 0)
      ..close();

    fillPaint.color = wingColor;
    canvas.drawPath(rightWingPath, fillPaint);
    canvas.drawPath(rightWingPath, strokePaint);

    // Inner detail
    final Path rightWingDetail = Path()
      ..moveTo(r * 0.2, -r * 0.1)
      ..cubicTo(r * 0.7, -r * 0.5, r * 1.3, -r * 0.2, r * 1.4, r * 0.1)
      ..cubicTo(r * 1.1, r * 0.3, r * 0.8, r * 0.1, r * 0.7, r * 0.3)
      ..close();
    fillPaint.color = wingColorDark;
    canvas.drawPath(rightWingDetail, fillPaint);
    canvas.restore();

    // ─────────────────────────────────────────────────────────────────────────
    // HEAD TILT / ROTATION BLOCK
    // Apply Head tilt for confused pose
    // Confused pose has a slightly tilted head
    // ─────────────────────────────────────────────────────────────────────────
    canvas.save();
    if (pose == MascotPose.confused) {
      canvas.translate(cX, cY);
      canvas.rotate(-0.06); // tilt head slightly to the left
      canvas.translate(-cX, -cY);
    }

    // ── Bat Ears ─────────────────────────────────────────────────────────────
    // Left Ear
    final Path leftEar = Path()
      ..moveTo(cX - r * 0.8, cY - r * 0.5)
      ..lineTo(cX - r * 0.85, cY - r * 1.25)
      ..quadraticBezierTo(cX - r * 0.5, cY - r * 1.15, cX - r * 0.2, cY - r * 0.95);
    fillPaint.color = const Color(0xFF9B75DC);
    canvas.drawPath(leftEar, fillPaint);
    canvas.drawPath(leftEar, strokePaint);

    final Path innerLeftEar = Path()
      ..moveTo(cX - r * 0.75, cY - r * 0.6)
      ..lineTo(cX - r * 0.8, cY - r * 1.1)
      ..quadraticBezierTo(cX - r * 0.55, cY - r * 1.05, cX - r * 0.3, cY - r * 0.85);
    fillPaint.color = const Color(0xFFCBB8F0);
    canvas.drawPath(innerLeftEar, fillPaint);

    // Right Ear
    final Path rightEar = Path()
      ..moveTo(cX + r * 0.8, cY - r * 0.5)
      ..lineTo(cX + r * 0.85, cY - r * 1.25)
      ..quadraticBezierTo(cX + r * 0.5, cY - r * 1.15, cX + r * 0.2, cY - r * 0.95);
    fillPaint.color = const Color(0xFF9B75DC);
    canvas.drawPath(rightEar, fillPaint);
    canvas.drawPath(rightEar, strokePaint);

    final Path innerRightEar = Path()
      ..moveTo(cX + r * 0.75, cY - r * 0.6)
      ..lineTo(cX + r * 0.8, cY - r * 1.1)
      ..quadraticBezierTo(cX + r * 0.55, cY - r * 1.05, cX + r * 0.3, cY - r * 0.85);
    fillPaint.color = const Color(0xFFCBB8F0);
    canvas.drawPath(innerRightEar, fillPaint);

    // ── Main Body Ball ───────────────────────────────────────────────────────
    fillPaint.color = const Color(0xFF9B75DC);
    canvas.drawCircle(Offset(cX, cY), r, fillPaint);
    canvas.drawCircle(Offset(cX, cY), r, strokePaint);

    // Star mark on the forehead
    final Path starPath = Path();
    final double starCX = cX - r * 0.45;
    final double starCY = cY - r * 0.45;
    final double starR1 = w * 0.05;
    final double starR2 = w * 0.022;
    for (int i = 0; i < 5; i++) {
      final double angle1 = -math.pi / 2 + i * 2 * math.pi / 5;
      final double angle2 = -math.pi / 2 + (i * 2 + 1) * math.pi / 5;
      if (i == 0) {
        starPath.moveTo(starCX + starR1 * math.cos(angle1), starCY + starR1 * math.sin(angle1));
      } else {
        starPath.lineTo(starCX + starR1 * math.cos(angle1), starCY + starR1 * math.sin(angle1));
      }
      starPath.lineTo(starCX + starR2 * math.cos(angle2), starCY + starR2 * math.sin(angle2));
    }
    starPath.close();
    fillPaint.color = const Color(0xFFCBB8F0);
    canvas.drawPath(starPath, fillPaint);

    // ── Eyes & Glasses ───────────────────────────────────────────────────────
    final double eyeRadius = w * 0.07;
    final double eyeSpacing = w * 0.12;
    final Offset leftEyeCenter = Offset(cX - eyeSpacing, cY - w * 0.02);
    final Offset rightEyeCenter = Offset(cX + eyeSpacing, cY - w * 0.02);

    final Paint pupilPaint = Paint()..color = const Color(0xFF1C1135);
    final Paint whitePaint = Paint()..color = Colors.white;

    if (pose == MascotPose.listening) {
      // Closed curved eyes
      final Paint curvePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.02
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF1C1135);

      canvas.drawArc(Rect.fromCircle(center: leftEyeCenter, radius: eyeRadius * 0.8), 0.1, math.pi * 0.8, false, curvePaint);
      canvas.drawArc(Rect.fromCircle(center: rightEyeCenter, radius: eyeRadius * 0.8), 0.1, math.pi * 0.8, false, curvePaint);
    } else if (pose == MascotPose.success) {
      // One open eye, one wink
      canvas.drawCircle(leftEyeCenter, eyeRadius, whitePaint);
      canvas.drawCircle(leftEyeCenter, eyeRadius, strokePaint);
      canvas.drawCircle(leftEyeCenter, eyeRadius * 0.7, pupilPaint);
      canvas.drawCircle(leftEyeCenter - Offset(eyeRadius * 0.25, eyeRadius * 0.25), eyeRadius * 0.22, whitePaint);

      final Paint curvePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.025
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF1C1135);
      canvas.drawArc(Rect.fromCircle(center: rightEyeCenter + Offset(0, -w * 0.01), radius: eyeRadius * 0.8), 0.1, math.pi * 0.8, false, curvePaint);
    } else if (pose == MascotPose.fail) {
      // Sad crying eyes (> < shape)
      final Paint sadPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.025
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF1C1135);

      canvas.drawLine(leftEyeCenter - Offset(eyeRadius * 0.7, -eyeRadius * 0.3), leftEyeCenter, sadPaint);
      canvas.drawLine(leftEyeCenter - Offset(eyeRadius * 0.7, eyeRadius * 0.3), leftEyeCenter, sadPaint);
      canvas.drawLine(rightEyeCenter + Offset(eyeRadius * 0.7, -eyeRadius * 0.3), rightEyeCenter, sadPaint);
      canvas.drawLine(rightEyeCenter + Offset(eyeRadius * 0.7, eyeRadius * 0.3), rightEyeCenter, sadPaint);

      final Paint tearPaint = Paint()..color = const Color(0xFF7EC8E3);
      final Path leftTear = Path()
        ..moveTo(leftEyeCenter.dx - w * 0.02, leftEyeCenter.dy + w * 0.02)
        ..cubicTo(leftEyeCenter.dx - w * 0.04, leftEyeCenter.dy + w * 0.08, leftEyeCenter.dx, leftEyeCenter.dy + w * 0.08, leftEyeCenter.dx, leftEyeCenter.dy + w * 0.02)
        ..close();
      canvas.drawPath(leftTear, tearPaint);

      final Path rightTear = Path()
        ..moveTo(rightEyeCenter.dx + w * 0.02, rightEyeCenter.dy + w * 0.02)
        ..cubicTo(rightEyeCenter.dx + w * 0.04, rightEyeCenter.dy + w * 0.08, rightEyeCenter.dx, rightEyeCenter.dy + w * 0.08, rightEyeCenter.dx, rightEyeCenter.dy + w * 0.02)
        ..close();
      canvas.drawPath(rightTear, tearPaint);
    } else if (pose == MascotPose.reading) {
      // Reading: Looking down with furrowed eyebrows
      // Draw white eye backgrounds
      canvas.drawCircle(leftEyeCenter, eyeRadius, whitePaint);
      canvas.drawCircle(leftEyeCenter, eyeRadius, strokePaint);
      canvas.drawCircle(rightEyeCenter, eyeRadius, whitePaint);
      canvas.drawCircle(rightEyeCenter, eyeRadius, strokePaint);

      // Pupils shifted down
      canvas.drawCircle(leftEyeCenter + Offset(0, eyeRadius * 0.35), eyeRadius * 0.6, pupilPaint);
      canvas.drawCircle(rightEyeCenter + Offset(0, eyeRadius * 0.35), eyeRadius * 0.6, pupilPaint);

      // Furrowed eyebrows
      final Paint browPaint = Paint()
        ..color = const Color(0xFF1C1135)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.022
        ..strokeCap = StrokeCap.round;
      
      canvas.drawLine(leftEyeCenter - Offset(eyeRadius * 0.8, eyeRadius * 0.7), leftEyeCenter - Offset(-eyeRadius * 0.3, eyeRadius * 0.5), browPaint);
      canvas.drawLine(rightEyeCenter + Offset(eyeRadius * 0.8, -eyeRadius * 0.7), rightEyeCenter + Offset(-eyeRadius * 0.3, -eyeRadius * 0.5), browPaint);
    } else {
      // Default / Teaching / Confused: Wide open eyes with highlights
      canvas.drawCircle(leftEyeCenter, eyeRadius, whitePaint);
      canvas.drawCircle(leftEyeCenter, eyeRadius, strokePaint);
      canvas.drawCircle(leftEyeCenter, eyeRadius * 0.7, pupilPaint);
      canvas.drawCircle(leftEyeCenter - Offset(eyeRadius * 0.25, eyeRadius * 0.25), eyeRadius * 0.22, whitePaint);

      canvas.drawCircle(rightEyeCenter, eyeRadius, whitePaint);
      canvas.drawCircle(rightEyeCenter, eyeRadius, strokePaint);
      canvas.drawCircle(rightEyeCenter, eyeRadius * 0.7, pupilPaint);
      canvas.drawCircle(rightEyeCenter - Offset(eyeRadius * 0.25, eyeRadius * 0.25), eyeRadius * 0.22, whitePaint);
    }

    // Glasses frame (only in teaching and confused/default)
    if (pose == MascotPose.teaching || pose == MascotPose.confused) {
      final Paint glassesPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.02
        ..color = const Color(0xFF1C1135);

      canvas.drawCircle(leftEyeCenter, eyeRadius * 1.15, glassesPaint);
      canvas.drawCircle(rightEyeCenter, eyeRadius * 1.15, glassesPaint);
      canvas.drawLine(
        Offset(leftEyeCenter.dx + eyeRadius * 1.15, leftEyeCenter.dy),
        Offset(rightEyeCenter.dx - eyeRadius * 1.15, rightEyeCenter.dy),
        glassesPaint,
      );
    }

    // ── Mouth ────────────────────────────────────────────────────────────────
    final double mouthY = cY + w * 0.09;
    if (pose == MascotPose.success) {
      final Path mouthPath = Path()
        ..moveTo(cX - w * 0.06, mouthY)
        ..quadraticBezierTo(cX, mouthY + w * 0.08, cX + w * 0.06, mouthY)
        ..quadraticBezierTo(cX, mouthY, cX - w * 0.06, mouthY)
        ..close();
      final Paint redPaint = Paint()..color = const Color(0xFFEF5350);
      canvas.drawPath(mouthPath, redPaint);
      canvas.drawPath(mouthPath, strokePaint);

      final Path leftFang = Path()
        ..moveTo(cX - w * 0.03, mouthY)
        ..lineTo(cX - w * 0.02, mouthY + w * 0.022)
        ..lineTo(cX - w * 0.01, mouthY)
        ..close();
      canvas.drawPath(leftFang, whitePaint);
      final Path rightFang = Path()
        ..moveTo(cX + w * 0.01, mouthY)
        ..lineTo(cX + w * 0.02, mouthY + w * 0.022)
        ..lineTo(cX + w * 0.03, mouthY)
        ..close();
      canvas.drawPath(rightFang, whitePaint);
    } else if (pose == MascotPose.fail || pose == MascotPose.confused) {
      // Sad frown
      final Path frownPath = Path()
        ..moveTo(cX - w * 0.05, mouthY + w * 0.02)
        ..quadraticBezierTo(cX, mouthY - w * 0.01, cX + w * 0.05, mouthY + w * 0.02);
      canvas.drawPath(frownPath, strokePaint);
    } else if (pose == MascotPose.listening || pose == MascotPose.reading) {
      // Simple neutral smile
      final Path smilePath = Path()
        ..moveTo(cX - w * 0.05, mouthY)
        ..quadraticBezierTo(cX, mouthY + w * 0.03, cX + w * 0.05, mouthY);
      canvas.drawPath(smilePath, strokePaint);
    } else {
      // Teaching: smile with fangs
      final Path smilePath = Path()
        ..moveTo(cX - w * 0.05, mouthY)
        ..quadraticBezierTo(cX, mouthY + w * 0.04, cX + w * 0.05, mouthY);
      canvas.drawPath(smilePath, strokePaint);

      final Path leftFang = Path()
        ..moveTo(cX - w * 0.03, mouthY + w * 0.005)
        ..lineTo(cX - w * 0.02, mouthY + w * 0.025)
        ..lineTo(cX - w * 0.015, mouthY + w * 0.005)
        ..close();
      canvas.drawPath(leftFang, whitePaint);
      canvas.drawPath(leftFang, strokePaint);

      final Path rightFang = Path()
        ..moveTo(cX + w * 0.015, mouthY + w * 0.005)
        ..lineTo(cX + w * 0.02, mouthY + w * 0.025)
        ..lineTo(cX + w * 0.03, mouthY + w * 0.005)
        ..close();
      canvas.drawPath(rightFang, whitePaint);
      canvas.drawPath(rightFang, strokePaint);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Restore head rotation / tilt context
    // ─────────────────────────────────────────────────────────────────────────
    canvas.restore();

    // ─────────────────────────────────────────────────────────────────────────
    // DRAW TEACHING POINTER STICK
    // ─────────────────────────────────────────────────────────────────────────
    if (pose == MascotPose.teaching) {
      final Paint stickPaint = Paint()
        ..color = const Color(0xFF8B5E3C)
        ..strokeWidth = w * 0.02
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(cX + r * 0.6, cY + w * 0.1),
        Offset(cX + r * 1.5, cY - w * 0.1),
        stickPaint,
      );

      final Paint handPaint = Paint()..color = const Color(0xFFCBB8F0);
      canvas.drawCircle(Offset(cX + r * 0.65, cY + w * 0.1), w * 0.035, handPaint);
      canvas.drawCircle(Offset(cX + r * 0.65, cY + w * 0.1), w * 0.035, strokePaint);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // DRAW CONFUSED HAND & QUESTION MARK
    // ─────────────────────────────────────────────────────────────────────────
    if (pose == MascotPose.confused) {
      // Floating purple ? to the right
      final textPainter = TextPainter(
        text: TextSpan(
          text: '?',
          style: TextStyle(
            fontSize: w * 0.15,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF8C65D1),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(cX + r * 0.95, cY - r * 1.05));

      // Confused hand raising to head (round hand on right cheek/ear area)
      final Paint handPaint = Paint()..color = const Color(0xFFCBB8F0);
      final Offset handPos = Offset(cX + r * 0.85, cY + r * 0.2);
      canvas.drawCircle(handPos, w * 0.04, handPaint);
      canvas.drawCircle(handPos, w * 0.04, strokePaint);

      // Small finger pointing up
      final Paint fingerPaint = Paint()
        ..color = const Color(0xFF1C1135)
        ..strokeWidth = w * 0.015
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(handPos, handPos + Offset(0, -w * 0.05), fingerPaint);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // DRAW BOOK & HANDS (Reading Pose)
    // ─────────────────────────────────────────────────────────────────────────
    if (pose == MascotPose.reading) {
      // Book centered at the bottom of the body
      final double bookCX = cX;
      final double bookCY = cY + r * 0.7;
      final double bookW = w * 0.46;
      final double bookH = w * 0.32;

      // 1. Draw Purple Book Cover underneath
      final Paint coverPaint = Paint()..color = const Color(0xFF8C65D1);
      final RRect coverRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(bookCX, bookCY + 2), width: bookW, height: bookH),
        const Radius.circular(6),
      );
      canvas.drawRRect(coverRect, coverPaint);
      canvas.drawRRect(coverRect, strokePaint);

      // 2. Draw White Open Pages
      final Paint pagePaint = Paint()..color = Colors.white;
      // Left Page (slanted)
      final Path leftPage = Path()
        ..moveTo(bookCX - 2, bookCY + bookH / 2 - 2)
        ..lineTo(bookCX - bookW / 2 + 4, bookCY + bookH / 2 - 4)
        ..lineTo(bookCX - bookW / 2 + 2, bookCY - bookH / 2 + 2)
        ..lineTo(bookCX - 2, bookCY - bookH / 2 + 4)
        ..close();
      canvas.drawPath(leftPage, pagePaint);
      canvas.drawPath(leftPage, strokePaint);

      // Right Page (slanted)
      final Path rightPage = Path()
        ..moveTo(bookCX + 2, bookCY + bookH / 2 - 2)
        ..lineTo(bookCX + bookW / 2 - 4, bookCY + bookH / 2 - 4)
        ..lineTo(bookCX + bookW / 2 - 2, bookCY - bookH / 2 + 2)
        ..lineTo(bookCX + 2, bookCY - bookH / 2 + 4)
        ..close();
      canvas.drawPath(rightPage, pagePaint);
      canvas.drawPath(rightPage, strokePaint);

      // 3. Draw lines on pages representing text
      final Paint linePaint = Paint()
        ..color = const Color(0xFFCBB8F0)
        ..strokeWidth = w * 0.008
        ..strokeCap = StrokeCap.round;

      // Left page lines
      canvas.drawLine(Offset(bookCX - bookW * 0.35, bookCY - bookH * 0.2), Offset(bookCX - bookW * 0.1, bookCY - bookH * 0.2), linePaint);
      canvas.drawLine(Offset(bookCX - bookW * 0.38, bookCY), Offset(bookCX - bookW * 0.12, bookCY), linePaint);
      canvas.drawLine(Offset(bookCX - bookW * 0.35, bookCY + bookH * 0.2), Offset(bookCX - bookW * 0.15, bookCY + bookH * 0.2), linePaint);

      // Right page lines
      canvas.drawLine(Offset(bookCX + bookW * 0.1, bookCY - bookH * 0.2), Offset(bookCX + bookW * 0.35, bookCY - bookH * 0.2), linePaint);
      canvas.drawLine(Offset(bookCX + bookW * 0.12, bookCY), Offset(bookCX + bookW * 0.38, bookCY), linePaint);
      canvas.drawLine(Offset(bookCX + bookW * 0.15, bookCY + bookH * 0.2), Offset(bookCX + bookW * 0.35, bookCY + bookH * 0.2), linePaint);

      // 4. Draw Hands holding the book edges
      final Paint handPaint = Paint()..color = const Color(0xFFCBB8F0);
      final Offset leftHandPos = Offset(bookCX - bookW * 0.45, bookCY + bookH * 0.1);
      final Offset rightHandPos = Offset(bookCX + bookW * 0.45, bookCY + bookH * 0.1);

      canvas.drawCircle(leftHandPos, w * 0.035, handPaint);
      canvas.drawCircle(leftHandPos, w * 0.035, strokePaint);

      canvas.drawCircle(rightHandPos, w * 0.035, handPaint);
      canvas.drawCircle(rightHandPos, w * 0.035, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant MascotPainter oldDelegate) {
    return oldDelegate.pose != pose ||
        oldDelegate.wingAngle != wingAngle ||
        oldDelegate.pulseValue != pulseValue;
  }
}
