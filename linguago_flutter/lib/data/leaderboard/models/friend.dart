class Friend {
  final String name;
  final String avatarUrl;
  final int level;
  bool isFriend;

  Friend({
    required this.name,
    required this.avatarUrl,
    required this.level,
    this.isFriend = true,
  });
}
