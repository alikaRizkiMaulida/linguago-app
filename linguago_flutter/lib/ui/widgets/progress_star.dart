import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';

class ProgressStar extends StatelessWidget {
  final int total;
  final int current;

  const ProgressStar({
    super.key,
    required this.total,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final bool isActive = index < current;
        final bool isCurrent = index == current - 1;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: isCurrent
              ? _starIcon(size: 20, color: AppColors.primaryPurple)
              : isActive
                  ? _starIcon(size: 16, color: AppColors.secondary)
                  : _dotIcon(),
        );
      }),
    );
  }

  Widget _starIcon({required double size, required Color color}) {
    return Icon(Icons.star_rounded, size: size, color: color);
  }

  Widget _dotIcon() {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AppColors.disableBorder,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Progress bar — grey track, purple fill, yellow star at progress tip (Figma).
class OnboardingStepProgressBar extends StatelessWidget {
  final int step;
  final int totalSteps;

  const OnboardingStepProgressBar({
    super.key,
    required this.step,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (step / totalSteps).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 4, 32, 0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final trackWidth = constraints.maxWidth;
          final fillWidth = trackWidth * progress;
          const starSize = 20.0;

          return SizedBox(
            height: starSize,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 8,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E0EF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOutCubic,
                  left: 0,
                  top: 8,
                  width: fillWidth,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8C65D1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOutCubic,
                  left: (fillWidth - starSize / 2).clamp(0.0, trackWidth - starSize),
                  top: 0,
                  child: SvgPicture.asset(
                    'assets/ic_round-star.svg',
                    width: starSize,
                    height: starSize,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFFFE031),
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

class ProgressBar extends StatelessWidget {
  final int total;
  final int current;

  const ProgressBar({
    super.key,
    required this.total,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final bool isActive = index < current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 28 : 8,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryPurple : AppColors.disableBorder,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}
