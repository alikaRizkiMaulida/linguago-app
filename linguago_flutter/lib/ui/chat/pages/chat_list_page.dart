import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/data/chat/models/chat_conversation.dart';
import 'package:linguago_flutter/ui/bloc/chat/chat_list_bloc.dart';
import 'package:linguago_flutter/ui/chat/pages/chat_detail_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatListBloc>().add(const ChatListEvent.started());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EEFB),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text(
                'Chat',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryText,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withValues(alpha: 0.07),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => context
                      .read<ChatListBloc>()
                      .add(ChatListEvent.searchChanged(v)),
                  style: TextStyle(fontSize: 13, color: AppColors.primaryText),
                  decoration: InputDecoration(
                    hintText: 'Search friends...',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: AppColors.secondaryText.withValues(alpha: 0.6),
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.secondaryText,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<ChatListBloc, ChatListState>(
                builder: (context, state) {
                  return state.map(
                    initial: (_) => const SizedBox(),
                    loading: (_) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    loaded: (loaded) {
                      final convs = loaded.conversations;
                      if (convs.isEmpty) {
                        return _EmptyState();
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                        itemCount: convs.length,
                        separatorBuilder: (_, __) => Divider(
                          color: AppColors.disableBorder.withValues(alpha: 0.5),
                          height: 1,
                          indent: 72,
                        ),
                        itemBuilder: (context, i) {
                          final conv = convs[i];
                          return _ConvTile(
                            conv: conv,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => ChatDetailPage(
                                    friendName: conv.friendName,
                                    friendAvatarUrl: conv.friendAvatarUrl,
                                    avatarColor: conv.avatarColor,
                                    initial: conv.initial,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
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

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_bubble_outline_rounded,
              size: 56, color: AppColors.secondaryText.withValues(alpha: 0.3)),
          const SizedBox(height: 14),
          Text(
            'Belum ada percakapan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.secondaryText.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Kunjungi Leaderboard & tap profil teman\nlalu kirim pesan! 💬',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.secondaryText.withValues(alpha: 0.4),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConvTile extends StatelessWidget {
  final ChatConversation conv;
  final VoidCallback onTap;

  const _ConvTile({required this.conv, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: conv.avatarColor,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: conv.avatarColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: conv.friendAvatarUrl.isNotEmpty
                        ? Image.network(
                            conv.friendAvatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text(
                                  conv.initial,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              conv.initial,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: const Color(0xFF66BB6A),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conv.friendName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    conv.lastMessage.isEmpty
                        ? 'Tap untuk mulai chat!'
                        : conv.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: conv.unread > 0
                          ? AppColors.primaryPurple
                          : AppColors.secondaryText,
                      fontWeight: conv.unread > 0
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  conv.lastTime,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.secondaryText,
                  ),
                ),
                if (conv.unread > 0) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryPurple,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${conv.unread}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
