import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/data/streak/streak_repository.dart';
import 'package:linguago_flutter/ui/bloc/streak/streak_bloc.dart';
import 'package:linguago_flutter/ui/streak/widgets/streak_task_item.dart';

class StreakPage extends StatefulWidget {
  const StreakPage({super.key});

  @override
  State<StreakPage> createState() => _StreakPageState();
}

class _StreakPageState extends State<StreakPage> {
  @override
  void initState() {
    super.initState();
    context.read<StreakBloc>().add(const StreakEvent.started());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSoft,
      body: BlocBuilder<StreakBloc, StreakState>(
        builder: (context, state) {
          return state.map(
            initial: (_) => const SizedBox(),
            loading: (_) => const Center(child: CircularProgressIndicator()),
            loaded: (loaded) => SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                    SvgPicture.asset(
                      'assets/noto_fire.svg',
                      width: 110,
                      height: 110,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${loaded.streakCount} Day',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFFF6B1A),
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (i) {
                          final isActive = i == loaded.activeDay;
                          return Text(
                            StreakRepository.weekDays[i],
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
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
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: loaded.progress,
                                minHeight: 10,
                                backgroundColor: const Color(0xFFE0DAEE),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFFFF6B1A),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: loaded.tasks
                                .map((task) => StreakTaskItem(task: task))
                                .toList(),
                          ),
                          const SizedBox(height: 16),
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
        },
      ),
    );
  }
}
