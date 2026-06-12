import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:linguago_flutter/data/achievement/achievement_repository.dart';
import 'package:linguago_flutter/data/achievement/models/achievement.dart';

part 'achievement_event.dart';
part 'achievement_state.dart';
part 'achievement_bloc.freezed.dart';

class AchievementBloc extends Bloc<AchievementEvent, AchievementState> {
  final AchievementRepository _repo;

  AchievementBloc({AchievementRepository? repo})
      : _repo = repo ?? AchievementRepository(),
        super(const AchievementState.initial()) {
    on<AchievementEvent>((event, emit) async {
      await event.map(
        started: (_) async {
          emit(const AchievementState.loading());
          final achievements = _repo.getAchievements();
          final unlocked = achievements.where((a) => a.unlocked).length;
          emit(AchievementState.loaded(
            achievements: achievements,
            unlockedCount: unlocked,
            totalCount: achievements.length,
          ));
        },
      );
    });
  }
}
