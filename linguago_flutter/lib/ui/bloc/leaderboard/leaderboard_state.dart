part of 'leaderboard_bloc.dart';

@freezed
class LeaderboardState with _$LeaderboardState {
  const factory LeaderboardState.initial() = _Initial;
  const factory LeaderboardState.loading() = _Loading;
  const factory LeaderboardState.loaded({
    required int selectedTab,
    required List<Player> worldPlayers,
    required List<Player> friendPlayers,
    required List<Friend> friends,
    required List<Friend> recommendations,
    String? searchQuery,
  }) = _Loaded;
  const factory LeaderboardState.error(String message) = _Error;
}
