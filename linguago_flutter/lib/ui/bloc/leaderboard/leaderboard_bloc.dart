import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:linguago_flutter/data/leaderboard/leaderboard_repository.dart';
import 'package:linguago_flutter/data/leaderboard/models/player.dart';
import 'package:linguago_flutter/data/leaderboard/models/friend.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';
part 'leaderboard_bloc.freezed.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final LeaderboardRepository _repo;

  LeaderboardBloc({LeaderboardRepository? repo})
      : _repo = repo ?? LeaderboardRepository(),
        super(const LeaderboardState.initial()) {
    on<LeaderboardEvent>((event, emit) async {
      await event.map(
        started: (_) async {
          emit(const LeaderboardState.loading());
          emit(LeaderboardState.loaded(
            selectedTab: 0,
            worldPlayers: _repo.getWorldPlayers(),
            friendPlayers: _repo.getFriendPlayers(),
            friends: _repo.getFriends(),
            recommendations: _repo.getRecommendations(),
          ));
        },
        tabChanged: (e) {
          state.mapOrNull(
            loaded: (s) {
              emit(s.copyWith(selectedTab: e.index));
            },
          );
        },
        toggleFriend: (e) {
          state.mapOrNull(
            loaded: (s) {
              _repo.toggleFriend(e.name);
              final updated = s.friends.map((f) {
                if (f.name == e.name) {
                  return Friend(
                    name: f.name,
                    avatarUrl: f.avatarUrl,
                    level: f.level,
                    isFriend: !f.isFriend,
                  );
                }
                return f;
              }).toList();
              emit(s.copyWith(friends: updated));
            },
          );
        },
        searchUsers: (e) {
          state.mapOrNull(
            loaded: (s) {
              emit(s.copyWith(searchQuery: e.query));
            },
          );
        },
      );
    });
  }
}
