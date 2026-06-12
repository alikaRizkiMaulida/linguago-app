import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/data/achievement/models/achievement.dart';
import 'package:linguago_flutter/ui/bloc/achievement/achievement_bloc.dart';

class AchievementPage extends StatefulWidget {
  const AchievementPage({super.key});

  @override
  State<AchievementPage> createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  @override
  void initState() {
    super.initState();
    context.read<AchievementBloc>().add(const AchievementEvent.started());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AchievementBloc, AchievementState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => const SizedBox.shrink(),
          loading: (_) => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          loaded: (s) => Scaffold(
            backgroundColor: AppColors.backgroundSoft,
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.maybePop(context),
                          child: const Icon(Icons.chevron_left_rounded,
                              size: 30, color: AppColors.primaryText),
                        ),
                        Expanded(
                          child: Text(
                            'Achievement',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryText,
                            ),
                          ),
                        ),
                        const SizedBox(width: 30),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 24,
                        childAspectRatio: 0.62,
                      ),
                      itemCount: s.achievements.length,
                      itemBuilder: (context, index) {
                        final a = s.achievements[index];
                        return _AchievementItem(
                          svgAsset: a.svgAsset,
                          title: a.title,
                          unlocked: a.unlocked,
                          progress: a.progress,
                          bgColor: a.color,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AchievementItem extends StatelessWidget {
  final String svgAsset;
  final String title;
  final bool unlocked;
  final double progress;
  final Color bgColor;

  const _AchievementItem({
    required this.svgAsset,
    required this.title,
    required this.unlocked,
    required this.progress,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 82,
          height: 82,
          child: SvgPicture.asset(svgAsset, fit: BoxFit.contain),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 3,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
              height: 1.3,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 4,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E0EF),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryPurple,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
