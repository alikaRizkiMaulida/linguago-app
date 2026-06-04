import 'dart:math';
import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';

/// Circular dots loading indicator — replaces the default
/// [CircularProgressIndicator] throughout the app.
///
/// Usage:
/// ```dart
/// const DotLoadingIndicator()
/// DotLoadingIndicator(size: 48, dotCount: 10, color: Colors.blue)
/// ```
class DotLoadingIndicator extends StatefulWidget {
  const DotLoadingIndicator({
    super.key,
    this.size = 40.0,
    this.dotCount = 8,
    this.color,
    this.inactiveColor,
    this.dotSize,
  });

  /// Overall diameter of the circular indicator.
  final double size;

  /// Number of dots arranged around the circle.
  final int dotCount;

  /// Colour of the "active" (highlighted) dots.
  /// Defaults to [AppColors.primary].
  final Color? color;

  /// Colour of the "inactive" (dimmed) dots.
  /// Defaults to a 25 % opacity version of [color].
  final Color? inactiveColor;

  /// Diameter of each individual dot.
  /// Defaults to `size / 7`.
  final double? dotSize;

  @override
  State<DotLoadingIndicator> createState() => _DotLoadingIndicatorState();
}

class _DotLoadingIndicatorState extends State<DotLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.color ?? AppColors.primary;
    final inactiveColor =
        widget.inactiveColor ?? activeColor.withValues(alpha: 0.2);
    final dotDiameter = widget.dotSize ?? (widget.size / 7);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          // Which dot is "leading" the highlight trail.
          final progress = _controller.value * widget.dotCount;

          return CustomPaint(
            painter: _DotCirclePainter(
              dotCount: widget.dotCount,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              dotDiameter: dotDiameter,
              progress: progress,
              trailLength: 4, // number of trailing dots that fade
            ),
          );
        },
      ),
    );
  }
}

class _DotCirclePainter extends CustomPainter {
  _DotCirclePainter({
    required this.dotCount,
    required this.activeColor,
    required this.inactiveColor,
    required this.dotDiameter,
    required this.progress,
    required this.trailLength,
  });

  final int dotCount;
  final Color activeColor;
  final Color inactiveColor;
  final double dotDiameter;
  final double progress; // 0 → dotCount (continuous)
  final int trailLength;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) - dotDiameter) / 2;
    final angleStep = (2 * pi) / dotCount;

    // Start from top (‑π/2) and go clockwise.
    const startAngle = -pi / 2;

    for (int i = 0; i < dotCount; i++) {
      final angle = startAngle + (i * angleStep);
      final dx = center.dx + radius * cos(angle);
      final dy = center.dy + radius * sin(angle);

      // How far this dot is behind the leading index (wrapping).
      final leading = progress % dotCount;
      double distance = (leading - i) % dotCount;

      // Compute opacity: dots in the "trail" get a gradient, the rest are dim.
      double t; // 0 = fully dim, 1 = fully bright
      if (distance < trailLength) {
        t = 1.0 - (distance / trailLength);
      } else {
        t = 0.0;
      }

      final color = Color.lerp(inactiveColor, activeColor, t)!;
      final paint = Paint()..color = color;

      // Slight size variation: leading dot is a bit larger.
      final currentDotSize = dotDiameter * (1.0 + 0.15 * t);

      canvas.drawCircle(Offset(dx, dy), currentDotSize / 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DotCirclePainter old) =>
      old.progress != progress;
}
