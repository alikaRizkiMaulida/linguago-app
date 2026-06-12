class Player {
  final int rank;
  final String name;
  final String avatarUrl;
  final int level;
  final int exp;
  final bool isMe;
  final int trend;

  const Player({
    required this.rank,
    required this.name,
    required this.avatarUrl,
    required this.level,
    required this.exp,
    this.isMe = false,
    this.trend = 0,
  });
}
