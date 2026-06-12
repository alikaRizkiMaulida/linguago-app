part of 'achievement_bloc.dart';

@freezed
class AchievementState with _$AchievementState {
  const factory AchievementState.initial() = _Initial;
  const factory AchievementState.loading() = _Loading;
  const factory AchievementState.loaded({
    required List<Achievement> achievements,
    required int unlockedCount,
    required int totalCount,
  }) = _Loaded;
}
