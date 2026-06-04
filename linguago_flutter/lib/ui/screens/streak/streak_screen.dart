import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';

/// Layar Streak — menampilkan streak harian user.
class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  static const List<String> _weekDays = [
    'Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'
  ];

  // index hari aktif (0 = Sunday)
  static const int _activeDay = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── App bar ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        size: 30,
                        color: AppColors.primaryText,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'My Streak',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // ── Fire image ───────────────────────────────────────────
              SvgPicture.asset(
                'assets/noto_fire.svg',
                width: 110,
                height: 110,
              ),

              const SizedBox(height: 12),

              // ── "1 Day" label ────────────────────────────────────────
              Text(
                '1 Day',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFFFF6B1A),
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 32),

              // ── Week days row ────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (i) {
                    final isActive = i == _activeDay;
                    return Text(
                      _weekDays[i],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isActive
                            ? FontWeight.w800
                            : FontWeight.w500,
                        color: isActive
                            ? const Color(0xFFFF6B1A)
                            : AppColors.secondaryText,
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 14),

              // ── Progress bar with star ◉ left and fire 🔥 right ──────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    // Left icon — gold star circle
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.star_rounded,
                            color: Colors.white, size: 18),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Progress bar
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: 1 / 7,
                          minHeight: 10,
                          backgroundColor: const Color(0xFFE0DAEE),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFFF6B1A),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Right icon — grey fire
                    SvgPicture.asset(
                      'assets/noto_fire.svg',
                      width: 28,
                      height: 28,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFCDC8DC),
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── Motivational text ────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text:
                        'Do a lessons every day this week to\nearn a perfect streak ',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryText,
                      height: 1.7,
                    ),
                    children: [
                      TextSpan(
                        text: 'on Saturday.',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFFFF6B1A),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Daily Streak Tasks card ──────────────────────────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Streak Tasks',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 3 task items
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _TaskItem(
                          label: 'Login to the\napplication',
                          points: '+2 study point',
                          done: false,
                        ),
                        _TaskItem(
                          label: 'Watch 1 video\nlesson',
                          points: '+4 study point',
                          done: false,
                        ),
                        _TaskItem(
                          label: 'Complete 3 quiz\nsuccessfully',
                          points: '+4 study point',
                          done: false,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Bottom note
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 9),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFDE8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFFD700).withOpacity(0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('⚡',
                              style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(
                            'Complete all tasks to keep your streak alive!',
                            style: TextStyle(
                              fontSize: 11,
                              color: const Color(0xFF8B7500),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TASK ITEM WIDGET
// ─────────────────────────────────────────────────────────────────────────────
class _TaskItem extends StatelessWidget {
  final String label;
  final String points;
  final bool done;

  const _TaskItem({
    required this.label,
    required this.points,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Star icon
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done
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
                    done ? AppColors.primaryPurple : const Color(0xFFC5C0D8),
                    BlendMode.srcIn,
                  ),
                ),
                if (done)
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
          label,
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
          points,
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
