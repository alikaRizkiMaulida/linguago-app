import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/data/leaderboard/models/player.dart';
import 'package:linguago_flutter/data/leaderboard/models/friend.dart';
import 'package:linguago_flutter/ui/bloc/leaderboard/leaderboard_bloc.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaderboardBloc, LeaderboardState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => const SizedBox.shrink(),
          loading: (_) => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          loaded: (s) => _LeaderboardContent(
                selectedTab: s.selectedTab,
                worldPlayers: s.worldPlayers,
                friendPlayers: s.friendPlayers,
              ),
          error: (e) => Scaffold(
            body: Center(child: Text('Error: ${e.message}')),
          ),
        );
      },
    );
  }
}

class _LeaderboardContent extends StatefulWidget {
  final int selectedTab;
  final List<Player> worldPlayers;
  final List<Player> friendPlayers;

  const _LeaderboardContent({
    required this.selectedTab,
    required this.worldPlayers,
    required this.friendPlayers,
  });

  @override
  State<_LeaderboardContent> createState() => _LeaderboardContentState();
}

class _LeaderboardContentState extends State<_LeaderboardContent>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.selectedTab,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context
            .read<LeaderboardBloc>()
            .add(LeaderboardEvent.tabChanged(index: _tabController.index));
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget;
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FF),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Leadboard',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 20),
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
                  controller: _tabController,
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
                controller: _tabController,
                children: [
                  _RankList(
                    players: s.worldPlayers,
                    onPlayerTap: (p) {},
                  ),
                  _RankList(
                    players: s.friendPlayers,
                    onPlayerTap: (p) {},
                    onFriendListTap: () {},
                    isFriendsTab: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RankList extends StatelessWidget {
  final List<Player> players;
  final Function(Player) onPlayerTap;
  final VoidCallback? onFriendListTap;
  final bool isFriendsTab;

  const _RankList({
    required this.players,
    required this.onPlayerTap,
    this.onFriendListTap,
    this.isFriendsTab = false,
  });

  @override
  Widget build(BuildContext context) {
    final itemCount = players.length + (isFriendsTab ? 1 : 0);

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (isFriendsTab && index == 0) {
          return GestureDetector(
            onTap: onFriendListTap,
            child: Container(
              margin: const EdgeInsets.only(bottom: 14, top: 4),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color:
                    AppColors.primaryPurple.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryPurple
                      .withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple
                          .withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.people_alt_rounded,
                      color: AppColors.primaryPurple,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Friend Lists & Rekomendations',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'View all friends and find recommendations',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.primaryPurple,
                    size: 24,
                  ),
                ],
              ),
            ),
          );
        }

        final p = players[isFriendsTab ? index - 1 : index];
        return _RankRow(player: p, onTap: () => onPlayerTap(p));
      },
    );
  }
}

class _RankRow extends StatelessWidget {
  final Player player;
  final VoidCallback onTap;

  const _RankRow({required this.player, required this.onTap});

  Color _medalColor(int rank) {
    if (rank == 1) return const Color(0xFFF1C40F);
    if (rank == 2) return const Color(0xFFBDC3C7);
    if (rank == 3) return const Color(0xFFE67E22);
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final isTop3 = player.rank <= 3;
    final isMe = player.isMe;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe
              ? AppColors.primaryPurple.withValues(alpha: 0.10)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isMe
              ? Border.all(
                  color: AppColors.primaryPurple
                      .withValues(alpha: 0.4),
                  width: 1)
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
                  ? Icon(Icons.emoji_events_rounded,
                      color: _medalColor(player.rank), size: 24)
                  : Text(
                      '${player.rank}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryText,
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
                      ? _medalColor(player.rank)
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
