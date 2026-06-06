import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/quiz_state.dart';
import 'package:linguago_flutter/ui/screens/streak/streak_screen.dart';
import 'package:linguago_flutter/ui/screens/listening/listening_category_screen.dart' as linguago_flutter_listening;
import 'package:linguago_flutter/ui/screens/script/script_category_screen.dart' as linguago_flutter_script;
import 'package:linguago_flutter/ui/screens/quiz/quiz_intro_screen.dart';
import 'package:linguago_flutter/ui/pages/lesson_detail_screen.dart';
import 'package:linguago_flutter/ui/screens/quiz/fun_fact_screen.dart';
import 'package:linguago_flutter/ui/screens/quiz/quiz_screen.dart';

/// Home Page — konten tab pertama di HomeScreen.
/// Dipisah dari home_screen.dart supaya lebih mudah dibaca dan dikelola.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _UserHeader(context: context),
          const SizedBox(height: 12),
          const _ExpBar(current: 400, total: 1000),
          const SizedBox(height: 16),
          const _StatsRow(),
          const SizedBox(height: 16),
          const _DailyCheckInCard(),
          const SizedBox(height: 16),
          const _ContinueStudyingCard(),
          const SizedBox(height: 24),
          _SectionHeader(
            title: 'Friends',
            action: const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.primaryText,
              size: 22,
            ),
          ),
          const SizedBox(height: 12),
          const _FriendsList(),
          const SizedBox(height: 24),
          _SectionHeader(title: 'Quick Actions'),
          const SizedBox(height: 12),
          _QuickActions(onRefresh: () => setState(() {})),
          const SizedBox(height: 24),
          const _LevelMapCard(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// USER HEADER
// ─────────────────────────────────────────────────────────────────────────────
class _UserHeader extends StatelessWidget {
  final BuildContext context;
  const _UserHeader({required this.context});

  @override
  Widget build(BuildContext _) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryPurple, width: 2.5),
            gradient: const LinearGradient(
              colors: [Color(0xFFCBB8F0), Color(0xFF9B75DC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Text(
              'E',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'evan',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('🎧', style: TextStyle(fontSize: 16)),
                  const Text('♪',
                      style: TextStyle(fontSize: 14, color: Color(0xFF9B75DC))),
                  const Text(' ☆',
                      style: TextStyle(
                          fontSize: 14, color: Color(0xFFFFB300))),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Level ${QuizProgress.unlockedPart}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('🇰🇷', style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
        ),
        // Bell button
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withOpacity(0.10),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  'assets/lucide_bell.svg',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryText,
                    BlendMode.srcIn,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF5350),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EXP BAR
// ─────────────────────────────────────────────────────────────────────────────
class _ExpBar extends StatelessWidget {
  final int current;
  final int total;

  const _ExpBar({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    final progress = current / total;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryPurple.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Text('⬆', style: TextStyle(fontSize: 11)),
              const SizedBox(width: 4),
              Text(
                'EXP',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryPurple,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: const Color(0xFFE5E0EF),
              valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primaryPurple),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$current/$total',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATS ROW
// ─────────────────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (_) => const StreakScreen()),
      ),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withOpacity(0.08),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatChip(
              icon: '❤️',
              label: 'Heart',
              value: '5 / 5',
              iconBg: const Color(0xFFFFF0F0),
            ),
            _VertDivider(),
            _StatChip(
              icon: '🔥',
              label: 'Streak',
              value: '1 Days',
              iconBg: const Color(0xFFFFF4EC),
            ),
            _VertDivider(),
            _StatChip(
              icon: '🪙',
              label: 'Reward',
              value: '10 Coins',
              iconBg: const Color(0xFFFFFBEC),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color iconBg;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 18))),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 11, color: AppColors.secondaryText)),
            Text(value,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText)),
          ],
        ),
      ],
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 36, color: AppColors.disableBorder);
}

// ─────────────────────────────────────────────────────────────────────────────
// DAILY CHECK-IN CARD
// ─────────────────────────────────────────────────────────────────────────────
class _DailyCheckInCard extends StatelessWidget {
  const _DailyCheckInCard();

  static const List<Map<String, dynamic>> _days = [
    {'day': 'Day 1', 'reward': '10 XP', 'icon': '🪙', 'done': true},
    {'day': 'Day 2', 'reward': '1', 'icon': '❤️', 'done': false},
    {'day': 'Day 3', 'reward': '20 XP', 'icon': '🪙', 'done': false},
    {'day': 'Day 4', 'reward': '10 XP', 'icon': '🪙', 'done': false},
    {'day': 'Day 5', 'reward': '1', 'icon': '❤️', 'done': false},
    {'day': 'Day 6', 'reward': '10 XP', 'icon': '🪙', 'done': false},
    {'day': 'Day 7', 'reward': '1', 'icon': '❤️', 'done': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🎁', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Daily Check-in',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryText)),
                  Text('Login every day and get rewards!',
                      style: TextStyle(
                          fontSize: 11, color: AppColors.secondaryText)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _days
                .map((d) => _DayTile(
                      day: d['day'] as String,
                      reward: d['reward'] as String,
                      icon: d['icon'] as String,
                      done: d['done'] as bool,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _DayTile extends StatelessWidget {
  final String day;
  final String reward;
  final String icon;
  final bool done;

  const _DayTile(
      {required this.day,
      required this.reward,
      required this.icon,
      required this.done});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(day,
            style: TextStyle(
                fontSize: 9,
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done
                ? AppColors.primaryPurple.withOpacity(0.12)
                : AppColors.backgroundSoft,
            border: Border.all(
              color: done ? AppColors.primaryPurple : AppColors.disableBorder,
              width: 1.5,
            ),
          ),
          child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 16))),
        ),
        const SizedBox(height: 4),
        Text(reward,
            style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: done
                    ? AppColors.primaryPurple
                    : AppColors.secondaryText)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CONTINUE STUDYING CARD
// ─────────────────────────────────────────────────────────────────────────────
class _ContinueStudyingCard extends StatelessWidget {
  const _ContinueStudyingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8C65D1), Color(0xFFAA86E7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Continue Studying',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white)),
                const SizedBox(height: 2),
                Text('Study regularly every day to become better!',
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.80))),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 14),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SvgPicture.asset(
                    'assets/Frame 1000002206.svg',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('Lesson 3',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryPurple)),
                      ),
                      const SizedBox(height: 6),
                      const Text('Daily Conversation',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: 0.50,
                                minHeight: 5,
                                backgroundColor:
                                    Colors.white.withOpacity(0.25),
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('50% complete',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.85))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          final int unlocked = QuizProgress.unlockedPart;
                          if (unlocked == 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => const LessonDetailScreen(part: 1),
                              ),
                            );
                          } else if (unlocked == 2) {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => const QuizScreen(part: 1),
                              ),
                            );
                          } else if (unlocked == 3) {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => const QuizScreen(part: 2),
                              ),
                            );
                          } else if (unlocked == 4) {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => const FunFactScreen(part: 4),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => const QuizScreen(part: 5),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Continue',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryPurple)),
                              const SizedBox(width: 4),
                              const Icon(Icons.play_arrow_rounded,
                                  color: AppColors.primaryPurple, size: 14),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? action;

  const _SectionHeader({required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryText),
        ),
        if (action != null) action!,
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FRIENDS LIST
// ─────────────────────────────────────────────────────────────────────────────
class _FriendsList extends StatelessWidget {
  const _FriendsList();

  static const List<Map<String, dynamic>> _friends = [
    {'name': 'nunu', 'color': Color(0xFF9B75DC)},
    {'name': 'wonnie', 'color': Color(0xFF7EC8E3)},
    {'name': 'jakey', 'color': Color(0xFFFFB3BA)},
    {'name': 'hoon', 'color': Color(0xFF95D5B2)},
    {'name': 'riki', 'color': Color(0xFFFFDFA0)},
    {'name': 'jayy', 'color': Color(0xFFC8A2C8)},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _friends.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, i) {
          final f = _friends[i];
          return _FriendItem(
            name: f['name'] as String,
            color: f['color'] as Color,
          );
        },
      ),
    );
  }
}

class _FriendItem extends StatelessWidget {
  final String name;
  final Color color;

  const _FriendItem({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.35),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(name[0].toUpperCase(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
          ),
        ),
        const SizedBox(height: 6),
        Text(name,
            style: TextStyle(
                fontSize: 11,
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// QUICK ACTIONS
// ─────────────────────────────────────────────────────────────────────────────
class _QuickActions extends StatelessWidget {
  final VoidCallback onRefresh;
  const _QuickActions({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final bool isListeningLocked = QuizProgress.unlockedPart < 2;

    return Row(
      children: [
        Expanded(
            child: _QuickActionCard(
                icon: 'assets/material-symbols_mic.svg',
                title: 'Listening',
                subtitle: 'Listening Practice',
                isLocked: isListeningLocked,
                onTap: () {
                  if (isListeningLocked) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please complete the Basic Quiz (Part 1) to unlock Listening!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (_) => const linguago_flutter_listening.ListeningCategoryScreen()),
                    ).then((_) => onRefresh());
                  }
                })),
        const SizedBox(width: 12),
        Expanded(
            child: _QuickActionCard(
                icon: 'assets/material-symbols_id-card-rounded.svg',
                title: 'Script',
                subtitle: 'Learning Letters',
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (_) => const linguago_flutter_script.ScriptCategoryScreen()),
                    ).then((_) => onRefresh()))),
        const SizedBox(width: 12),
        Expanded(
            child: _QuickActionCard(
                icon: 'assets/mingcute_game-2-fill.svg',
                title: 'Quiz',
                subtitle: 'Practice Test',
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (_) => const QuizIntroScreen()),
                    ).then((_) => onRefresh()))),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool isLocked;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isLocked = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        decoration: BoxDecoration(
          color: isLocked ? const Color(0xFFF5F3F7) : AppColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: isLocked
              ? null
              : [
                  BoxShadow(
                    color: AppColors.primaryPurple.withOpacity(0.07),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isLocked
                        ? const Color(0xFFE0DCE4)
                        : AppColors.primaryPurple.withOpacity(0.12),
                  ),
                  child: Center(
                    child: Opacity(
                      opacity: isLocked ? 0.4 : 1.0,
                      child: SvgPicture.asset(icon,
                          width: 26,
                          height: 26,
                          colorFilter: ColorFilter.mode(
                              isLocked ? AppColors.secondaryText : AppColors.primaryPurple,
                              BlendMode.srcIn)),
                    ),
                  ),
                ),
                if (isLocked)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.secondaryText,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_rounded,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(title,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isLocked ? AppColors.secondaryText : AppColors.primaryText)),
            const SizedBox(height: 2),
            Text(isLocked ? 'Locked' : subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10, color: AppColors.secondaryText)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LEVEL MAP CARD
// ─────────────────────────────────────────────────────────────────────────────
class _LevelMapCard extends StatefulWidget {
  const _LevelMapCard();

  @override
  State<_LevelMapCard> createState() => _LevelMapCardState();
}

class _LevelMapCardState extends State<_LevelMapCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _bobbingController;
  late Animation<double> _bobbingAnimation;

  // Labels for each node (shown on long press or as tooltip)
  static const List<String> _nodeLabels = [
    'Lesson Summary',
    'Basic Quiz',
    'Listening Quiz',
    'Fun Fact',
    'Final Quiz',
  ];

  @override
  void initState() {
    super.initState();
    _bobbingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _bobbingAnimation = Tween<double>(begin: -4.0, end: 4.0).animate(
      CurvedAnimation(parent: _bobbingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bobbingController.dispose();
    super.dispose();
  }

  void _onNodeTap(BuildContext context, int nodeIndex) {
    final int unlocked = QuizProgress.unlockedPart;
    final int levelNum = nodeIndex + 1;

    if (levelNum > unlocked) {
      // Node is locked — show snackbar
      final String requiredLabel = _nodeLabels[nodeIndex - 1];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Complete "$requiredLabel" first to unlock this!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Navigate based on node index
    if (nodeIndex == 0) {
      // Node 1 → Lesson Summary
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const LessonDetailScreen(part: 1),
        ),
      ).then((_) => setState(() {}));
    } else if (nodeIndex == 1) {
      // Node 2 → Basic Quiz (Part 1)
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const QuizScreen(part: 1),
        ),
      ).then((_) => setState(() {}));
    } else if (nodeIndex == 2) {
      // Node 3 → Listening Quiz (Part 2)
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const QuizScreen(part: 2),
        ),
      ).then((_) => setState(() {}));
    } else if (nodeIndex == 3) {
      // Node 4 → Fun Fact
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const FunFactScreen(part: 4),
        ),
      ).then((_) => setState(() {}));
    } else if (nodeIndex == 4) {
      // Node 5 → Final Quiz (Part 5)
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const QuizScreen(part: 5),
        ),
      ).then((_) => setState(() {}));
    }
  }

  @override
  Widget build(BuildContext context) {
    final int currentLevel = QuizProgress.unlockedPart;
    const int totalLevels = 5;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Row(
            children: [
              const Text('📘', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Level Map',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryText)),
                    Text('Keep learning n unlock all levels!',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.secondaryText)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Text('See map',
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.w600)),
                    const Icon(Icons.chevron_right_rounded,
                        color: AppColors.primaryPurple, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Nodes Row ────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(totalLevels, (i) {
              final levelNum = i + 1;
              final bool isActive = levelNum == currentLevel;
              final bool isLocked = levelNum > currentLevel;

              return GestureDetector(
                onTap: () => _onNodeTap(context, i),
                child: Column(
                  children: [
                    // ── Mascot (bobbing on active node) ─────────────────
                    if (isActive)
                      AnimatedBuilder(
                        animation: _bobbingAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _bobbingAnimation.value),
                            child: child,
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/Group_111.svg',
                          width: 36,
                          height: 36,
                        ),
                      )
                    else
                      const SizedBox(height: 36),
                    const SizedBox(height: 4),

                    // ── Circle Node ──────────────────────────────────────
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: isActive ? 48 : 40,
                      height: isActive ? 48 : 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isLocked
                            ? AppColors.backgroundAlt
                            : isActive
                                ? AppColors.primaryPurple
                                : AppColors.primaryPurple.withOpacity(0.35),
                        border: isActive
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: AppColors.primaryPurple.withOpacity(0.40),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: isLocked
                            ? const Icon(Icons.lock_outline,
                                color: AppColors.navInActive, size: 18)
                            : Text(
                                '$levelNum',
                                style: TextStyle(
                                    fontSize: isActive ? 17 : 14,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 16),

          // ── Progress Footer ─────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentLevel <= 5 ? 'Level 1' : 'Level 2',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryText,
                ),
              ),
              Text(
                currentLevel == 1
                    ? '200/1000'
                    : currentLevel == 2
                        ? '400/1000'
                        : currentLevel == 3
                            ? '600/1000'
                            : currentLevel == 4
                                ? '800/1000'
                                : '1000/1000',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryText),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: currentLevel == 1
                  ? 0.2
                  : currentLevel == 2
                      ? 0.4
                      : currentLevel == 3
                          ? 0.6
                          : currentLevel == 4
                              ? 0.8
                              : 1.0,
              minHeight: 8,
              backgroundColor: const Color(0xFFE5E0EF),
              valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primaryPurple),
            ),
          ),
        ],
      ),
    );
  }
}
