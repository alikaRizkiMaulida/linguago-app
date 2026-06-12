part of 'streak_bloc.dart';

@freezed
class StreakState with _$StreakState {
  const factory StreakState.initial() = _Initial;
  const factory StreakState.loading() = _Loading;
  const factory StreakState.loaded({
    required int streakCount,
    required double progress,
    required int activeDay,
    required List<StreakTask> tasks,
  }) = _Loaded;
}
