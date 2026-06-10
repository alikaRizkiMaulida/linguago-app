import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/core/constants/chat_store.dart';
import 'package:linguago_flutter/ui/pages/chat_page.dart';

// ─── Model ───────────────────────────────────────────────────────────────────
class _Player {
  final int rank;
  final String name;
  final String avatarUrl;
  final int level;
  final int exp;
  final bool isMe;
  final int trend; // +1 for up, -1 for down, 0 for stable

  const _Player({
    required this.rank,
    required this.name,
    required this.avatarUrl,
    required this.level,
    required this.exp,
    this.isMe = false,
    this.trend = 0,
  });
}

class _Friend {
  final String name;
  final String avatarUrl;
  final int level;
  bool isFriend;

  _Friend({
    required this.name,
    required this.avatarUrl,
    required this.level,
    this.isFriend = true,
  });
}

// ─── Data ────────────────────────────────────────────────────────────────────
const _worldPlayers = [
  _Player(rank: 1, name: '1009-eism',   avatarUrl: 'https://i.pravatar.cc/150?img=1', level: 58, exp: 85278, trend: 0),
  _Player(rank: 2, name: 'sunoflers',  avatarUrl: 'https://i.pravatar.cc/150?img=2', level: 56, exp: 83653, trend: 0),
  _Player(rank: 3, name: 'milk.도토리',  avatarUrl: 'https://i.pravatar.cc/150?img=3', level: 51, exp: 83692, isMe: true, trend: 0),
  _Player(rank: 4, name: 'heesour',     avatarUrl: 'https://i.pravatar.cc/150?img=4', level: 48, exp: 80716, trend: 1),
  _Player(rank: 5, name: 'rikiusier',  avatarUrl: 'https://i.pravatar.cc/150?img=5', level: 45, exp: 80631, trend: 1),
  _Player(rank: 6, name: 'jwonusie',    avatarUrl: 'https://i.pravatar.cc/150?img=6', level: 41, exp: 80094, trend: 1),
  _Player(rank: 7, name: 'ciellunoo',  avatarUrl: 'https://i.pravatar.cc/150?img=7', level: 36, exp: 80076, trend: -1),
  _Player(rank: 8, name: 'Potato_9595', avatarUrl: 'https://i.pravatar.cc/150?img=8', level: 33, exp: 77420, trend: 1),
];

final _allFriends = [
  _Friend(name: '1009-eism',   avatarUrl: 'https://i.pravatar.cc/150?img=1',  level: 40, isFriend: true),
  _Friend(name: 'sunooflers',  avatarUrl: 'https://i.pravatar.cc/150?img=2',  level: 40, isFriend: true),
  _Friend(name: 'milk.도토리',  avatarUrl: 'https://i.pravatar.cc/150?img=3',  level: 8,  isFriend: true),
  _Friend(name: 'heesour',     avatarUrl: 'https://i.pravatar.cc/150?img=4',  level: 40, isFriend: true),
  _Friend(name: 'rikiusier',   avatarUrl: 'https://i.pravatar.cc/150?img=5',  level: 40, isFriend: true),
  _Friend(name: 'jwonusie',    avatarUrl: 'https://i.pravatar.cc/150?img=6',  level: 40, isFriend: true),
  _Friend(name: 'ciellunoo',   avatarUrl: 'https://i.pravatar.cc/150?img=7',  level: 40, isFriend: true),
  _Friend(name: 'Potato_9595', avatarUrl: 'https://i.pravatar.cc/150?img=8',  level: 40, isFriend: false),
  _Friend(name: 'ikeufie',     avatarUrl: 'https://i.pravatar.cc/150?img=9',  level: 40, isFriend: false),
  _Friend(name: 'hoonst4rs',   avatarUrl: 'https://i.pravatar.cc/150?img=10', level: 40, isFriend: false),
  _Friend(name: 'jung.jpeg',   avatarUrl: 'https://i.pravatar.cc/150?img=11', level: 40, isFriend: false),
  _Friend(name: 'bleujay',     avatarUrl: 'https://i.pravatar.cc/150?img=12', level: 40, isFriend: false),
  _Friend(name: 'RICKY沈泉锐',  avatarUrl: 'https://i.pravatar.cc/150?img=13', level: 40, isFriend: false),
  _Friend(name: '_paewswhis',  avatarUrl: 'https://i.pravatar.cc/150?img=14', level: 40, isFriend: false),
  _Friend(name: 'jayvvhxs',    avatarUrl: 'https://i.pravatar.cc/150?img=15', level: 40, isFriend: false),
];

final _recommendations = [
  _Friend(name: 'nunu',   avatarUrl: 'https://i.pravatar.cc/150?img=20', level: 12),
  _Friend(name: 'wonnie', avatarUrl: 'https://i.pravatar.cc/150?img=21', level: 8),
  _Friend(name: 'jakey',  avatarUrl: 'https://i.pravatar.cc/150?img=22', level: 15),
  _Friend(name: 'hoon',   avatarUrl: 'https://i.pravatar.cc/150?img=23', level: 9),
  _Friend(name: 'riki',   avatarUrl: 'https://i.pravatar.cc/150?img=24', level: 6),
  _Friend(name: 'jayy',   avatarUrl: 'https://i.pravatar.cc/150?img=25', level: 11),
];

// ─── Main Screen ─────────────────────────────────────────────────────────────
class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late List<_Friend> _friends;
  late List<_Friend> _recs;

  @override
  void initState() {
    super.initState();

    _friends = _allFriends
        .map((f) => _Friend(
              name: f.name,
              avatarUrl: f.avatarUrl,
              level: f.level,
              isFriend: f.isFriend,
            ))
        .toList();

    _recs = _recommendations
        .map((f) => _Friend(
              name: f.name,
              avatarUrl: f.avatarUrl,
              level: f.level,
              isFriend: f.isFriend,
            ))
        .toList();
  }

  void _toggleFriend(_Friend friend) {
    setState(() {
      friend.isFriend = !friend.isFriend;
      // Sync back to static list if present to preserve state transitions
      final idx = _allFriends.indexWhere((element) => element.name == friend.name);
      if (idx != -1) {
        _allFriends[idx].isFriend = friend.isFriend;
      }
    });
  }

  void _onPlayerRowTap(BuildContext context, _Player player) {
    // Look up existing friend state or build temporary
    final friendIndex = _friends.indexWhere((f) => f.name == player.name);
    _Friend friend;
    if (friendIndex != -1) {
      friend = _friends[friendIndex];
    } else {
      final recIndex = _recs.indexWhere((f) => f.name == player.name);
      if (recIndex != -1) {
        friend = _recs[recIndex];
      } else {
        friend = _Friend(
          name: player.name,
          avatarUrl: player.avatarUrl,
          level: player.level,
          isFriend: false,
        );
      }
    }
    _showProfileCard(context, friend);
  }

  void _showProfileCard(BuildContext ctx, _Friend friend) {
    showGeneralDialog(
      context: ctx,
      barrierDismissible: true,
      barrierLabel: 'profile',
      barrierColor: Colors.black.withValues(alpha: 0.4),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (dialogCtx, anim1, anim2) {
        return _ProfileCard(
          friend: friend,
          onToggleFriend: () => _toggleFriend(friend),
          onChatTap: () {
            ChatStore.instance.getOrCreate(
              friendName: friend.name,
              friendAvatarUrl: friend.avatarUrl,
              avatarColor: AppColors.primaryPurple,
              initial: friend.name.isNotEmpty
                  ? friend.name[0].toUpperCase()
                  : '?',
            );
            Navigator.of(dialogCtx).pop();
            Navigator.push(
              ctx,
              MaterialPageRoute<void>(
                builder: (_) => ChatDetailPage(
                  friendName: friend.name,
                  friendAvatarUrl: friend.avatarUrl,
                  avatarColor: AppColors.primaryPurple,
                  initial: friend.name.isNotEmpty
                      ? friend.name[0].toUpperCase()
                      : '?',
                ),
              ),
            );
          },
        );
      },
      transitionBuilder: (ctx, anim1, anim2, child) {
        // Slide down from offscreen top to screen center with elastic/spring effect
        final slideAnim = Tween<Offset>(
          begin: const Offset(0, -1.5),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: anim1,
            curve: const _SpringBounceCurve(),
          ),
        );
        final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: anim1,
            curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
          ),
        );
        return FadeTransition(
          opacity: fadeAnim,
          child: SlideTransition(position: slideAnim, child: child),
        );
      },
    );
  }

  List<_Player> get _friendPlayers {
    final friends = _friends.where((f) => f.isFriend).toList();
    friends.sort((a, b) => b.level.compareTo(a.level));
    return List.generate(friends.length, (i) {
      final f = friends[i];
      return _Player(
        rank: i + 1,
        name: f.name,
        avatarUrl: f.avatarUrl,
        level: f.level,
        exp: f.level * 1500,
        isMe: f.name == 'milk.도토리',
        trend: 0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FF),
      body: SafeArea(
        bottom: false,
        child: _LeaderboardPage(
          friendPlayers: _friendPlayers,
          onPlayerTap: (p) => _onPlayerRowTap(context, p),
        ),
      ),
    );
  }
}

// ─── Leaderboard Page ─────────────────────────────────────────────────────────
class _LeaderboardPage extends StatefulWidget {
  final Function(_Player) onPlayerTap;
  final List<_Player> friendPlayers;

  const _LeaderboardPage({
    required this.onPlayerTap,
    required this.friendPlayers,
  });

  @override
  State<_LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<_LeaderboardPage> {
  bool isFriendsTab = false;

  @override
  Widget build(BuildContext context) {
    final players =
        isFriendsTab ? widget.friendPlayers : _worldPlayers;

    return Column(
      children: [
        const SizedBox(height: 16),

        const Text(
          'Leaderboard',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryText,
          ),
        ),

        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFriendsTab = false;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: !isFriendsTab
                            ? AppColors.primaryPurple
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.public_rounded,
                              size: 16,
                              color: !isFriendsTab
                                  ? Colors.white
                                  : AppColors.primaryText,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'World',
                              style: TextStyle(
                                color: !isFriendsTab
                                    ? Colors.white
                                    : AppColors.primaryText,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFriendsTab = true;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isFriendsTab
                            ? AppColors.primaryPurple
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_rounded,
                              size: 16,
                              color: isFriendsTab
                                  ? Colors.white
                                  : AppColors.primaryText,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Friends',
                              style: TextStyle(
                                color: isFriendsTab
                                    ? Colors.white
                                    : AppColors.primaryText,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        Expanded(
          child: _RankList(
            players: players,
            onPlayerTap: widget.onPlayerTap,
            isFriendsTab: isFriendsTab,
          ),
        ),
      ],
    );
  }
}

// ─── Rank List ────────────────────────────────────────────────────────────────
class _RankList extends StatelessWidget {
  final List<_Player> players;
  final Function(_Player) onPlayerTap;
  final bool isFriendsTab;

  const _RankList({
    required this.players,
    required this.onPlayerTap,
    this.isFriendsTab = false,
  });

  @override
  Widget build(BuildContext context) {
    final itemCount = players.length;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final p = players[index];
        return _RankRow(
          player: p,
          onTap: () => onPlayerTap(p),
        );
      },
    );
  }
}

// ─── Rank Row ─────────────────────────────────────────────────────────────────
class _RankRow extends StatelessWidget {
  final _Player player;
  final VoidCallback onTap;

  const _RankRow({required this.player, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isTop3 = player.rank <= 3;
    final isMe = player.isMe;

    final medalColors = [
      const Color(0xFFFFCC00),
      const Color(0xFFB0BEC5),
      const Color(0xFFCD7F32),
    ];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe
              ? AppColors.primaryPurple.withValues(alpha: 0.10)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isMe
              ? Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.4), width: 1)
              : null,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: isTop3
                  ? Center(child: _RankMedal(rank: player.rank))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${player.rank}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryText,
                          ),
                        ),
                        if (player.trend != 0) ...[
                          const SizedBox(height: 3),
                          _TrendTriangle(isUp: player.trend > 0),
                        ],
                      ],
                    ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isTop3
                      ? medalColors[player.rank - 1]
                      : AppColors.disableBorder,
                  width: isTop3 ? 2.5 : 1.5,
                ),
                image: DecorationImage(
                  image: NetworkImage(player.avatarUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'lv. ${player.level}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Exp ${player.exp}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Custom Ribbon Medal ──────────────────────────────────────────────────────
class _RankMedal extends StatelessWidget {
  final int rank;

  const _RankMedal({required this.rank});

  @override
  Widget build(BuildContext context) {
    final Color medalColor;
    if (rank == 1) {
      medalColor = const Color(0xFFF1C40F);
    } else if (rank == 2) {
      medalColor = const Color(0xFFBDC3C7);
    } else {
      medalColor = const Color(0xFFE67E22);
    }

    return SizedBox(
      width: 32,
      height: 36,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Ribbon tails behind the medal circle
          Positioned(
            bottom: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.rotate(
                  angle: -0.2,
                  child: Container(
                    width: 6,
                    height: 12,
                    color: medalColor.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(width: 2),
                Transform.rotate(
                  angle: 0.2,
                  child: Container(
                    width: 6,
                    height: 12,
                    color: medalColor.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          // Circular Medal Body
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: medalColor,
              border: Border.all(color: Colors.white, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: medalColor.withValues(alpha: 0.35),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              '$rank',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Trend Triangle ───────────────────────────────────────────────────────────
class _TrendTriangle extends StatelessWidget {
  final bool isUp;

  const _TrendTriangle({required this.isUp});

  @override
  Widget build(BuildContext context) {
    final color = isUp ? const Color(0xFF7CB342) : const Color(0xFFE53935);
    return CustomPaint(
      size: const Size(8, 6),
      painter: _TrianglePainter(color: color, isUp: isUp),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  final bool isUp;

  _TrianglePainter({required this.color, required this.isUp});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    if (isUp) {
      path.moveTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    } else {
      path.moveTo(size.width / 2, size.height);
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Friend List Page ─────────────────────────────────────────────────────────
class _FriendListPage extends StatelessWidget {
  final List<_Friend> friends;
  final List<_Friend> recs;
  final Function(_Friend) onToggleFriend;
  final Function(_Friend) onShowProfileCard;
  final VoidCallback onBack;

  const _FriendListPage({
    required this.friends,
    required this.recs,
    required this.onToggleFriend,
    required this.onShowProfileCard,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 20, 0),
          child: Row(
            children: [
              GestureDetector(
                onTap: onBack,
                child: const Icon(
                  Icons.chevron_left_rounded,
                  size: 30,
                  color: AppColors.primaryText,
                ),
              ),
              const Expanded(
                child: Text(
                  'Friend Lists',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
              const SizedBox(width: 30),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            children: [
              // Friend rows
              ...friends.map((f) => _FriendRow(
                    friend: f,
                    onToggleFriend: () => onToggleFriend(f),
                    onAvatarTap: () => onShowProfileCard(f),
                    onChatTap: () {
                      ChatStore.instance.getOrCreate(
                        friendName: f.name,
                        friendAvatarUrl: f.avatarUrl,
                        avatarColor: AppColors.primaryPurple,
                        initial: f.name.isNotEmpty
                            ? f.name[0].toUpperCase()
                            : '?',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => ChatDetailPage(
                            friendName: f.name,
                            friendAvatarUrl: f.avatarUrl,
                            avatarColor: AppColors.primaryPurple,
                            initial: f.name.isNotEmpty
                                ? f.name[0].toUpperCase()
                                : '?',
                          ),
                        ),
                      );
                    },
                  )),

              // Recommendations
              const SizedBox(height: 16),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FriendRecommendationScreen(
                        recs: recs,
                        onShowProfileCard: onShowProfileCard,
                      ),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Friend Recomendations',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryText,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: AppColors.primaryText,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 64,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: recs.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final r = recs[i];
                    return GestureDetector(
                      onTap: () => onShowProfileCard(r),
                      child: Column(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.disableBorder,
                                width: 1.5,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(r.avatarUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            r.name,
                            style: const TextStyle(
                              fontSize: 9,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Friend Row ───────────────────────────────────────────────────────────────
class _FriendRow extends StatelessWidget {
  final _Friend friend;
  final VoidCallback onToggleFriend;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onChatTap;
  final bool isRecommendation;

  const _FriendRow({
    required this.friend,
    required this.onToggleFriend,
    this.onAvatarTap,
    this.onChatTap,
    this.isRecommendation = false,
  });

  @override
  Widget build(BuildContext context) {
    final isFriend = friend.isFriend;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Avatar
          GestureDetector(
            onTap: onAvatarTap,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.disableBorder, width: 1.5),
                image: DecorationImage(
                  image: NetworkImage(friend.avatarUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name & level
          Expanded(
            child: GestureDetector(
              onTap: onAvatarTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'lv. ${friend.level}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Friend / Profile button
          GestureDetector(
            onTap: isRecommendation ? onAvatarTap : onToggleFriend,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isRecommendation 
                    ? 'Profile' 
                    : (isFriend ? 'Unfriend' : 'Add Friend'),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryPurple,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Profile Card (muncul dari atas, animasi bounce/tuing ke tengah) ─────────
class _ProfileCard extends StatefulWidget {
  final _Friend friend;
  final VoidCallback onToggleFriend;
  final VoidCallback? onChatTap;

  const _ProfileCard({
    required this.friend,
    required this.onToggleFriend,
    this.onChatTap,
  });

  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard> {
  late bool _isFriend;

  @override
  void initState() {
    super.initState();
    _isFriend = widget.friend.isFriend;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center, // Center aligned on screen
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withValues(alpha: 0.18),
                  blurRadius: 28,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Left Column (Avatar, Name, UID, Bio) - ALL CENTERED
                Expanded(
                  flex: 11,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Avatar
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.disableBorder,
                            width: 1.5,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(widget.friend.avatarUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Name
                      Text(
                        widget.friend.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryText,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // UID Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'UID : 1009012',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.copy_rounded,
                            size: 11,
                            color: AppColors.secondaryText.withValues(alpha: 0.7),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Bio
                      Text(
                        widget.friend.name == 'Potato_9595'
                            ? 'kentang goreng enak'
                            : widget.friend.name == 'ikeufie'
                                ? 'layla lovers'
                                : widget.friend.name == 'hoonst4rs'
                                    ? 'hah'
                                    : widget.friend.name == 'jung.jpeg'
                                        ? 'kentang goreng enak'
                                        : 'lagi gaming anak',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.disableText,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Thin vertical divider line (Figma purple/lavender)
                Container(
                  height: 110,
                  width: 1,
                  color: AppColors.disableBorder.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 12),
                // Right Column (Main Page, Stats, Actions)
                Expanded(
                  flex: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      const Text(
                        'Main Page',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _MiniStat(
                            icon: '🌍',
                            label: 'World Level',
                            value: '${widget.friend.level}',
                          ),
                          _MiniStat(
                            icon: '🏆',
                            label: 'Achivement', // exact spelling as Figma design
                            value: widget.friend.name == 'ikeufie'
                                ? '124'
                                : widget.friend.name == 'hoonst4rs'
                                    ? '44'
                                    : widget.friend.name == 'jung.jpeg'
                                        ? '93'
                                        : '2',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Action Row (Button + Chat Icon)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isFriend = !_isFriend;
                                widget.friend.isFriend = _isFriend;
                              });
                              widget.onToggleFriend();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.secondaryText,
                                  width: 1.2,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _isFriend
                                        ? Icons.remove_rounded
                                        : Icons.add_rounded,
                                    size: 12,
                                    color: AppColors.secondaryText,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    _isFriend ? 'Unfriend' : 'Add Friend',
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Raw double chat bubbles icon as in Figma
                          GestureDetector(
                            onTap: widget.onChatTap,
                            child: const Icon(
                              Icons.forum_rounded,
                              size: 20,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// ─── Mini Stat ────────────────────────────────────────────────────────────────
class _MiniStat extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _MiniStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 8,
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }
}

// ─── Spring Bounce Curve ──────────────────────────────────────────────────────
class _SpringBounceCurve extends Curve {
  const _SpringBounceCurve();

  @override
  double transformInternal(double t) {
    const c4 = (2 * math.pi) / 3;
    if (t == 0) return 0;
    if (t == 1) return 1;
    return -(math.pow(2, 10 * t - 10).toDouble() *
        math.sin((t * 10 - 10.75) * c4));
  }
}

// ─── Public Friend List Screen ────────────────────────────────────────────────
class FriendListScreen extends StatefulWidget {
  const FriendListScreen({super.key});

  @override
  State<FriendListScreen> createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
  late List<_Friend> _friends;
  late List<_Friend> _recs;

  @override
  void initState() {
    super.initState();
    _friends = _allFriends
        .map((f) => _Friend(
              name: f.name,
              avatarUrl: f.avatarUrl,
              level: f.level,
              isFriend: f.isFriend,
            ))
        .toList();
    _recs = _recommendations
        .map((f) => _Friend(
              name: f.name,
              avatarUrl: f.avatarUrl,
              level: f.level,
              isFriend: f.isFriend,
            ))
        .toList();
  }

  void _toggleFriend(_Friend friend) {
    setState(() {
      friend.isFriend = !friend.isFriend;
      // Sync back to static list if present to preserve state transitions
      final idx = _allFriends.indexWhere((element) => element.name == friend.name);
      if (idx != -1) {
        _allFriends[idx].isFriend = friend.isFriend;
      }
      final recIdx = _recommendations.indexWhere((element) => element.name == friend.name);
      if (recIdx != -1) {
        _recommendations[recIdx].isFriend = friend.isFriend;
      }
    });
  }

  void _showProfileCard(BuildContext ctx, _Friend friend) {
    showGeneralDialog(
      context: ctx,
      barrierDismissible: true,
      barrierLabel: 'ProfileCard',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (dialogCtx, anim1, anim2) {
        return _ProfileCard(
          friend: friend,
          onToggleFriend: () => _toggleFriend(friend),
        );
      },
      transitionBuilder: (dialogCtx, anim1, anim2, child) {
        final curve = CurvedAnimation(parent: anim1, curve: const _SpringBounceCurve());
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(curve),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FF),
      body: SafeArea(
        child: _FriendListPage(
          friends: _friends,
          recs: _recs,
          onToggleFriend: _toggleFriend,
          onShowProfileCard: (f) => _showProfileCard(context, f),
          onBack: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

// ─── Friend Recommendation Screen ──────────────────────────────────────────────
class FriendRecommendationScreen extends StatelessWidget {
  final List<_Friend> recs;
  final Function(_Friend) onShowProfileCard;

  const FriendRecommendationScreen({
    super.key,
    required this.recs,
    required this.onShowProfileCard,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      size: 30,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Friend Recomendations',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                itemCount: recs.length,
                itemBuilder: (context, index) {
                  final r = recs[index];
                  return _FriendRow(
                    friend: r,
                    isRecommendation: true,
                    onToggleFriend: () {}, // Not used
                    onAvatarTap: () => onShowProfileCard(r),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
