part of 'leaderboard_bloc.dart';

@freezed
class LeaderboardEvent with _$LeaderboardEvent {
  const factory LeaderboardEvent.started() = _Started;
  const factory LeaderboardEvent.tabChanged({required int index}) = _TabChanged;
  const factory LeaderboardEvent.toggleFriend({required String name}) = _ToggleFriend;
  const factory LeaderboardEvent.searchUsers({required String query}) = _SearchUsers;
}
