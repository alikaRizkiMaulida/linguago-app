import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/data/script/models/script_category.dart' show HangulCategory;
import 'package:linguago_flutter/ui/bloc/script/script_bloc.dart';
import 'package:linguago_flutter/ui/script/widgets/script_card.dart';

class ScriptPage extends StatefulWidget {
  const ScriptPage({super.key});

  @override
  State<ScriptPage> createState() => _ScriptPageState();
}

class _ScriptPageState extends State<ScriptPage> {
  @override
  void initState() {
    super.initState();
    context.read<ScriptBloc>().add(const ScriptEvent.started());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FF),
      body: BlocBuilder<ScriptBloc, ScriptState>(
        builder: (context, state) {
          final categories = state.map(
            initial: (_) => <HangulCategory>[],
            loading: (_) => <HangulCategory>[],
            loaded: (l) => l.koreanCategories,
          );

          return SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Let's Begin!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryPurple,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Learn Hangul from beginner to advanced! ✨',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 48),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 50,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      return ScriptCard(
                        title: cat.title,
                        desc: cat.desc,
                        emoji: cat.emoji,
                        bg: cat.bg,
                        unlocked: cat.unlocked,
                        lockLevel: cat.lockLevel,
                      );
                    },
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
