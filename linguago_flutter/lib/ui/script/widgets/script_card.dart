import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';

class ScriptCard extends StatelessWidget {
  final String title;
  final String desc;
  final String emoji;
  final Color bg;
  final bool unlocked;
  final int? lockLevel;
  final bool isEnglish;

  const ScriptCard({
    super.key,
    required this.title,
    required this.desc,
    required this.emoji,
    required this.bg,
    required this.unlocked,
    this.lockLevel,
    this.isEnglish = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 36),
          padding: const EdgeInsets.fromLTRB(14, 48, 14, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isEnglish
                    ? const Color(0xFF5B7BE1).withOpacity(0.07)
                    : AppColors.primaryPurple.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.secondaryText,
                    height: 1.4,
                  ),
                  overflow: TextOverflow.visible,
                ),
              ),
              const SizedBox(height: 8),
              if (unlocked)
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEnglish
                          ? const Color(0xFF5B7BE1)
                          : AppColors.primaryPurple,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: isEnglish
                          ? const Color(0xFF5B7BE1)
                          : AppColors.primaryPurple,
                      disabledForegroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      'start',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EEFB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_rounded,
                          color: AppColors.navInActive, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Unlocked at Level $lockLevel',
                        style: TextStyle(
                          fontSize: 9,
                          color: AppColors.navInActive,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isEnglish
                  ? Text(emoji, style: const TextStyle(fontSize: 30))
                  : Text(
                      emoji,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFD61A54),
                        height: 1.2,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
