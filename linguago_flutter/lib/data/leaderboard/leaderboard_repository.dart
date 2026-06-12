import 'package:linguago_flutter/data/leaderboard/models/player.dart';
import 'package:linguago_flutter/data/leaderboard/models/friend.dart';

class LeaderboardRepository {
  static const _worldPlayers = [
    Player(rank: 1, name: '1009-eism', avatarUrl: 'https://i.pravatar.cc/150?img=1', level: 58, exp: 85278),
    Player(rank: 2, name: 'sunoflers', avatarUrl: 'https://i.pravatar.cc/150?img=2', level: 56, exp: 83653),
    Player(rank: 3, name: 'milk.도토리', avatarUrl: 'https://i.pravatar.cc/150?img=3', level: 51, exp: 83692, isMe: true),
    Player(rank: 4, name: 'heesour', avatarUrl: 'https://i.pravatar.cc/150?img=4', level: 48, exp: 80716, trend: 1),
    Player(rank: 5, name: 'rikiusier', avatarUrl: 'https://i.pravatar.cc/150?img=5', level: 45, exp: 80631, trend: 1),
    Player(rank: 6, name: 'jwonusie', avatarUrl: 'https://i.pravatar.cc/150?img=6', level: 41, exp: 80094, trend: 1),
    Player(rank: 7, name: 'ciellunoo', avatarUrl: 'https://i.pravatar.cc/150?img=7', level: 36, exp: 80076, trend: -1),
    Player(rank: 8, name: 'Potato_9595', avatarUrl: 'https://i.pravatar.cc/150?img=8', level: 33, exp: 77420, trend: 1),
  ];

  static const _friendPlayers = [
    Player(rank: 1, name: '1009-eism', avatarUrl: 'https://i.pravatar.cc/150?img=1', level: 58, exp: 85278),
    Player(rank: 2, name: 'sunoflers', avatarUrl: 'https://i.pravatar.cc/150?img=2', level: 56, exp: 83653),
    Player(rank: 3, name: 'milk.도토리', avatarUrl: 'https://i.pravatar.cc/150?img=3', level: 51, exp: 83692, isMe: true),
    Player(rank: 4, name: 'heesour', avatarUrl: 'https://i.pravatar.cc/150?img=4', level: 48, exp: 80716, trend: 1),
    Player(rank: 5, name: 'rikiusier', avatarUrl: 'https://i.pravatar.cc/150?img=5', level: 45, exp: 80631, trend: 1),
    Player(rank: 6, name: 'jwonusie', avatarUrl: 'https://i.pravatar.cc/150?img=6', level: 41, exp: 80094, trend: 1),
    Player(rank: 7, name: 'ciellunoo', avatarUrl: 'https://i.pravatar.cc/150?img=7', level: 36, exp: 80076, trend: -1),
    Player(rank: 8, name: 'Potato_9595', avatarUrl: 'https://i.pravatar.cc/150?img=8', level: 33, exp: 77420, trend: 1),
  ];

  static final _allFriends = [
    Friend(name: '1009-eism', avatarUrl: 'https://i.pravatar.cc/150?img=1', level: 40, isFriend: true),
    Friend(name: 'sunooflers', avatarUrl: 'https://i.pravatar.cc/150?img=2', level: 40, isFriend: true),
    Friend(name: 'milk.도토리', avatarUrl: 'https://i.pravatar.cc/150?img=3', level: 8, isFriend: true),
    Friend(name: 'heesour', avatarUrl: 'https://i.pravatar.cc/150?img=4', level: 40, isFriend: true),
    Friend(name: 'rikiusier', avatarUrl: 'https://i.pravatar.cc/150?img=5', level: 40, isFriend: true),
    Friend(name: 'jwonusie', avatarUrl: 'https://i.pravatar.cc/150?img=6', level: 40, isFriend: true),
    Friend(name: 'ciellunoo', avatarUrl: 'https://i.pravatar.cc/150?img=7', level: 40, isFriend: true),
    Friend(name: 'Potato_9595', avatarUrl: 'https://i.pravatar.cc/150?img=8', level: 40, isFriend: false),
    Friend(name: 'ikeufie', avatarUrl: 'https://i.pravatar.cc/150?img=9', level: 40, isFriend: false),
    Friend(name: 'hoonst4rs', avatarUrl: 'https://i.pravatar.cc/150?img=10', level: 40, isFriend: false),
    Friend(name: 'jung.jpeg', avatarUrl: 'https://i.pravatar.cc/150?img=11', level: 40, isFriend: false),
    Friend(name: 'bleujay', avatarUrl: 'https://i.pravatar.cc/150?img=12', level: 40, isFriend: false),
    Friend(name: 'RICKY沈泉锐', avatarUrl: 'https://i.pravatar.cc/150?img=13', level: 40, isFriend: false),
    Friend(name: '_paewswhis', avatarUrl: 'https://i.pravatar.cc/150?img=14', level: 40, isFriend: false),
    Friend(name: 'jayvvhxs', avatarUrl: 'https://i.pravatar.cc/150?img=15', level: 40, isFriend: false),
  ];

  static final _recommendations = [
    Friend(name: 'nunu', avatarUrl: 'https://i.pravatar.cc/150?img=20', level: 12),
    Friend(name: 'wonnie', avatarUrl: 'https://i.pravatar.cc/150?img=21', level: 8),
    Friend(name: 'jakey', avatarUrl: 'https://i.pravatar.cc/150?img=22', level: 15),
    Friend(name: 'hoon', avatarUrl: 'https://i.pravatar.cc/150?img=23', level: 9),
    Friend(name: 'riki', avatarUrl: 'https://i.pravatar.cc/150?img=24', level: 6),
    Friend(name: 'jayy', avatarUrl: 'https://i.pravatar.cc/150?img=25', level: 11),
  ];

  List<Player> getWorldPlayers() => List.unmodifiable(_worldPlayers);
  List<Player> getFriendPlayers() => List.unmodifiable(_friendPlayers);
  List<Friend> getFriends() => _allFriends.map((f) => Friend(name: f.name, avatarUrl: f.avatarUrl, level: f.level, isFriend: f.isFriend)).toList();
  List<Friend> getRecommendations() => _recommendations.map((f) => Friend(name: f.name, avatarUrl: f.avatarUrl, level: f.level, isFriend: f.isFriend)).toList();

  void toggleFriend(String name) {
    final idx = _allFriends.indexWhere((f) => f.name == name);
    if (idx != -1) {
      _allFriends[idx].isFriend = !_allFriends[idx].isFriend;
    }
  }
}
