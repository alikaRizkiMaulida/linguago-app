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

  const _Player({
    required this.rank,
    required this.name,
    required this.avatarUrl,
    required this.level,
    required this.exp,
    this.isMe = false,
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
  _Player(rank: 1, name: '1009-eism',   avatarUrl: 'https://i.pravatar.cc/150?img=1', level: 56, exp: 85278),
  _Player(rank: 2, name: 'sunofllers',  avatarUrl: 'https://i.pravatar.cc/150?img=2', level: 56, exp: 81653),
  _Player(rank: 3, name: 'milk.도토리',  avatarUrl: 'https://i.pravatar.cc/150?img=3', level: 51, exp: 83692, isMe: true),
  _Player(rank: 4, name: 'heesour',     avatarUrl: 'https://i.pravatar.cc/150?img=4', level: 40, exp: 80718),
  _Player(rank: 5, name: 'riklusiier',  avatarUrl: 'https://i.pravatar.cc/150?img=5', level: 40, exp: 80631),
  _Player(rank: 6, name: 'jwonusie',    avatarUrl: 'https://i.pravatar.cc/150?img=6', level: 41, exp: 80094),
  _Player(rank: 7, name: 'ciellunooo',  avatarUrl: 'https://i.pravatar.cc/150?img=7', level: 38, exp: 80076),
  _Player(rank: 8, name: 'Potato_9595', avatarUrl: 'https://i.pravatar.cc/150?img=8', level: 33, exp: 77420),
  _Player(rank: 9, name: 'ikeufie',     avatarUrl: 'https://i.pravatar.cc/150?img=9', level: 33, exp: 64279),
];

const _friendPlayers = [
  _Player(rank: 1, name: '1009-eism',   avatarUrl: 'https://i.pravatar.cc/150?img=1', level: 56, exp: 85278),
  _Player(rank: 2, name: 'sunofllers',  avatarUrl: 'https://i.pravatar.cc/150?img=2', level: 56, exp: 81653),
  _Player(rank: 3, name: 'milk.도토리',  avatarUrl: 'https://i.pravatar.cc/150?img=3', level: 31, exp: 83692, isMe: true),
  _Player(rank: 4, name: 'heesour',     avatarUrl: 'https://i.pravatar.cc/150?img=4', level: 40, exp: 80718),
  _Player(rank: 5, name: 'riklusiier',  avatarUrl: 'https://i.pravatar.cc/150?img=5', level: 40, exp: 80631),
  _Player(rank: 6, name: 'jwonusie',    avatarUrl: 'https://i.pravatar.cc/150?img=6', level: 41, exp: 80094),
  _Player(rank: 7, name: 'ciellunooo',  avatarUrl: 'https://i.pravatar.cc/150?img=7', level: 38, exp: 80076),
  _Player(rank: 8, name: 'Potato_9595', avatarUrl: 'https://i.pravatar.cc/150?img=8', level: 35, exp: 77420),
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
  _Friend(name: 'RICKY 泫奕',  avatarUrl: 'https://i.pravatar.cc/150?img=13', level: 40, isFriend: false),
  _Friend(name: '_paewswhis',  avatarUrl: 'https://i.pravatar.cc/150?img=14', level: 40, isFriend: false),
  _Friend(name: 'jayvvhns',    avatarUrl: 'https://i.pravatar.cc/150?img=15', level: 40, isFriend: false),
];

final _recommendations = [
  _Friend(name: 'nunu',   avatarUrl: 'https://i.pravatar.cc/150?img=20', level: 12),
  _Friend(name: 'wonnie', avatarUrl: 'https://i.pravatar.cc/150?img=21', level: 8),
  _Friend(name: 'jakey',  avatarUrl: 'https://i.pravatar.cc/150?img=22', level: 15),
  _Friend(name: 'hoon',   avatarUrl: 'https://i.pravatar.cc/150?img=23', level: 9),
  _Friend(name: 'ulle',   avatarUrl: 'https://i.pravatar.cc/150?img=24', level: 6),
  _Friend(name: 'jayy',   avatarUrl: 'https://i.pravatar.cc/150?img=25', level: 11),
];

// ─── Main Screen ─────────────────────────────────────────────────────────────
class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _showFriendList = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FF),
      body: SafeArea(
        bottom: false,
        child: _showFriendList
            ? _FriendListPage(onBack: () => setState(() => _showFriendList = false))
            : _LeaderboardPage(
                tabController: _tabController,
                onFriendListTap: () => setState(() => _showFriendList = true),
              ),
      ),
    );
  }
}

// ─── Leaderboard Page ─────────────────────────────────────────────────────────
class _LeaderboardPage extends StatelessWidget {
  final TabController tabController;
  final VoidCallback onFriendListTap;

  const _LeaderboardPage({
    required this.tabController,
    required this.onFriendListTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          'Leadboard',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 20),

        // Tab Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80),
          child: Container(
            height: 40,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF3EEFB),
              borderRadius: BorderRadius.circular(24),
            ),
            child: TabBar(
              controller: tabController,
              indicator: BoxDecoration(
                color: AppColors.primaryPurple,
                borderRadius: BorderRadius.circular(20),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.secondaryText,
              tabs: const [
                Tab(text: 'World'),
                Tab(text: 'Friends'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              _RankList(players: _worldPlayers, onFriendListTap: onFriendListTap),
              _RankList(players: _friendPlayers, onFriendListTap: onFriendListTap),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Rank List ────────────────────────────────────────────────────────────────
class _RankList extends StatelessWidget {
  final List<_Player> players;
  final VoidCallback onFriendListTap;

  const _RankList({required this.players, required this.onFriendListTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final p = players[index];
        return _RankRow(player: p, onFriendListTap: onFriendListTap);
      },
    );
  }
}

// ─── Rank Row ─────────────────────────────────────────────────────────────────
class _RankRow extends StatelessWidget {
  final _Player player;
  final VoidCallback onFriendListTap;

  const _RankRow({required this.player, required this.onFriendListTap});

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
      onTap: player.rank == 1 ? onFriendListTap : null,
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
              width: 30,
              child: isTop3
                  ? Text(
                      ['🥇', '🥈', '🥉'][player.rank - 1],
                      style: const TextStyle(fontSize: 20),
                    )
                  : Text(
                      '${player.rank}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondaryText,
                      ),
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
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'lv. ${player.level}',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Exp ${player.exp.toString().replaceAllMapped(
                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                    (m) => '${m[1]},',
                  )}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Friend List Page ─────────────────────────────────────────────────────────
class _FriendListPage extends StatefulWidget {
  final VoidCallback onBack;

  const _FriendListPage({required this.onBack});

  @override
  State<_FriendListPage> createState() => _FriendListPageState();
}

class _FriendListPageState extends State<_FriendListPage> {
  late final List<_Friend> _friends;
  late final List<_Friend> _recs;

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
    });
  }

  // ── Profile card: muncul dari atas dengan animasi bounce/tuing ─────────────
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
            // Daftar ke ChatStore supaya masuk ke ChatPage
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
        // Slide dari atas + spring bounce (tuing!)
        final slideAnim = Tween<Offset>(
          begin: const Offset(0, -1.3),
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
                onTap: widget.onBack,
                child: const Icon(
                  Icons.chevron_left_rounded,
                  size: 30,
                  color: AppColors.primaryText,
                ),
              ),
              Expanded(
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
              ..._friends.map((f) => _FriendRow(
                    friend: f,
                    onToggleFriend: () => _toggleFriend(f),
                    onAvatarTap: () => _showProfileCard(context, f),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Friend rekomendations',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: AppColors.primaryText,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 64,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _recs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final r = _recs[i];
                    return GestureDetector(
                      onTap: () => _showProfileCard(context, r),
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
                            style: TextStyle(
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

  const _FriendRow({
    required this.friend,
    required this.onToggleFriend,
    this.onAvatarTap,
    this.onChatTap,
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
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'lv. ${friend.level}',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Friend / Unfriend button
          GestureDetector(
            onTap: onToggleFriend,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isFriend
                    ? Colors.red.withValues(alpha: 0.10)
                    : AppColors.primaryPurple.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isFriend
                      ? Colors.red.withValues(alpha: 0.25)
                      : AppColors.primaryPurple.withValues(alpha: 0.25),
                ),
              ),
              child: Text(
                isFriend ? 'Unfriend' : 'Add Friend',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isFriend ? Colors.red : AppColors.primaryPurple,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Profile Card (muncul dari atas, animasi bounce/tuing) ────────────────────
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
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          right: 16,
          bottom: 32,
        ),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withValues(alpha: 0.18),
                  blurRadius: 28,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.disableBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                // Header: avatar + info + stats
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryPurple.withValues(alpha: 0.5),
                            width: 2.5,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(widget.friend.avatarUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Name + UID + bio
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundSoft,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Main Page',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.friend.name,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryText,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'UID : 1009012',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.copy_rounded,
                                    size: 11,
                                    color: AppColors.secondaryText),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'lagi gaming anak',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.disableText,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Stats
                      Column(
                        children: [
                          _MiniStat(
                            icon: '🌍',
                            label: 'World Level',
                            value: '${widget.friend.level}',
                          ),
                          const SizedBox(height: 10),
                          const _MiniStat(
                            icon: '🏆',
                            label: 'Achievement',
                            value: '2',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Action buttons
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Row(
                    children: [
                      // Friend / Unfriend
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isFriend = !_isFriend;
                              widget.friend.isFriend = _isFriend;
                            });
                            widget.onToggleFriend();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 44,
                            decoration: BoxDecoration(
                              color: _isFriend
                                  ? Colors.red.withValues(alpha: 0.08)
                                  : AppColors.primaryPurple.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: _isFriend
                                    ? Colors.red.withValues(alpha: 0.25)
                                    : AppColors.primaryPurple.withValues(alpha: 0.30),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _isFriend
                                      ? Icons.person_remove_rounded
                                      : Icons.person_add_rounded,
                                  size: 16,
                                  color: _isFriend
                                      ? Colors.red
                                      : AppColors.primaryPurple,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _isFriend ? 'Unfriend' : 'Add Friend',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: _isFriend
                                        ? Colors.red
                                        : AppColors.primaryPurple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Chat button — buka ChatDetailPage via ChatStore
                      GestureDetector(
                        onTap: widget.onChatTap,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primaryPurple,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryPurple.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
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
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryText,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}

// ─── Spring Bounce Curve ──────────────────────────────────────────────────────
/// Animasi: slide dari atas + tuing/bounce di akhir
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
