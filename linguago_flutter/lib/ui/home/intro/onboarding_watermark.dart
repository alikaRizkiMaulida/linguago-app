import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class _WatermarkMark {
  const _WatermarkMark({
    required this.x,
    required this.y,
    required this.size,
    required this.rotation,
  });

  /// Position as fraction of screen width/height.
  final double x;
  final double y;
  final double size;
  final double rotation;
}

/// Large, sparse 文+A watermark — layout berbeda tiap halaman onboarding.
class LinguagoWatermark extends StatelessWidget {
  const LinguagoWatermark({super.key, required this.pageIndex});

  final int pageIndex;

  static const _assetPath = 'assets/Vector (1) copy.svg';

  static const _pageLayouts = <int, List<_WatermarkMark>>{
    0: [
      _WatermarkMark(x: -0.06, y: 0.06, size: 240, rotation: -0.18),
      _WatermarkMark(x: 0.52, y: 0.02, size: 200, rotation: 0.14),
      _WatermarkMark(x: 0.68, y: 0.38, size: 185, rotation: -0.10),
      _WatermarkMark(x: 0.04, y: 0.48, size: 215, rotation: 0.08),
      _WatermarkMark(x: 0.38, y: 0.68, size: 195, rotation: -0.06),
    ],
    1: [
      _WatermarkMark(x: 0.58, y: 0.04, size: 230, rotation: 0.12),
      _WatermarkMark(x: -0.04, y: 0.22, size: 205, rotation: -0.14),
      _WatermarkMark(x: 0.72, y: 0.52, size: 190, rotation: 0.06),
      _WatermarkMark(x: 0.12, y: 0.58, size: 220, rotation: -0.08),
      _WatermarkMark(x: 0.42, y: 0.78, size: 175, rotation: 0.16),
    ],
    2: [
      _WatermarkMark(x: 0.08, y: 0.08, size: 225, rotation: 0.10),
      _WatermarkMark(x: 0.62, y: 0.18, size: 198, rotation: -0.12),
      _WatermarkMark(x: -0.02, y: 0.42, size: 210, rotation: 0.05),
      _WatermarkMark(x: 0.55, y: 0.55, size: 188, rotation: -0.15),
      _WatermarkMark(x: 0.28, y: 0.74, size: 205, rotation: 0.09),
      _WatermarkMark(x: 0.78, y: 0.72, size: 170, rotation: -0.07),
    ],
  };

  List<_WatermarkMark> get _marks =>
      _pageLayouts[pageIndex] ?? _pageLayouts[0]!;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          return Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              for (final mark in _marks)
                Positioned(
                  left: mark.x * w,
                  top: mark.y * h,
                  child: Transform.rotate(
                    angle: mark.rotation,
                    child: SvgPicture.asset(
                      _assetPath,
                      width: mark.size,
                      height: mark.size * 1.18,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Purple loading bar at top — matches Figma onboarding progress.
class OnboardingLoadingBar extends StatelessWidget {
  const OnboardingLoadingBar({
    super.key,
    required this.step,
    required this.totalSteps,
  });

  final int step;
  final int totalSteps;

  static const _trackColor = Color(0xFFF7F8FA);
  static const _fillColor = Color(0xFF8C65D1);
  static const _starColor = Color(0xFFFFE031);

  @override
  Widget build(BuildContext context) {
    final double progress;
    if (totalSteps <= 1) {
      progress = 1.0;
    } else {
      progress = 0.25 + (step - 1) * (0.75 / (totalSteps - 1));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final trackWidth = constraints.maxWidth;

          const starSize = 26.0;
          const barHeight = 8.0;

          final starLeft = progress * (trackWidth - starSize);
          final fillWidth = progress == 1.0 ? trackWidth : (starLeft + starSize / 2);

          return SizedBox(
            height: starSize,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                // 1. TRACK BACKGROUND
                Positioned(
                  left: 0,
                  right: 0,
                  top: (starSize - barHeight) / 2,
                  child: Container(
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: _trackColor,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),

                // 2. FILL PROGRESS (Garis Ungu)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeInOutCubic,
                  left: 0,
                  top: (starSize - barHeight) / 2,
                  width: fillWidth,
                  child: Container(
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: _fillColor,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),

                // 3. BINTANG PENANDA
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeInOutCubic,
                  left: starLeft,
                  top: 0,
                  child: SvgPicture.asset(
                    'assets/ic_round-star.svg',
                    width: starSize,
                    height: starSize,
                    colorFilter: const ColorFilter.mode(
                      _starColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Legacy export — prefer [OnboardingLoadingBar].
typedef OnboardingStepProgressBar = OnboardingLoadingBar;
