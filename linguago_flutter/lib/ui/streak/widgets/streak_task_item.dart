import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/data/streak/models/streak_task.dart';

class StreakTaskItem extends StatelessWidget {
  final StreakTask task;

  const StreakTaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: task.done
                ? AppColors.primaryPurple.withOpacity(0.10)
                : const Color(0xFFF0EEF8),
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  'assets/ic_round-star.svg',
                  width: 28,
                  height: 28,
                  colorFilter: ColorFilter.mode(
                    task.done
                        ? AppColors.primaryPurple
                        : const Color(0xFFC5C0D8),
                    BlendMode.srcIn,
                  ),
                ),
                if (task.done)
                  const Positioned(
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          task.label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.primaryText,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          task.points,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.secondaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
