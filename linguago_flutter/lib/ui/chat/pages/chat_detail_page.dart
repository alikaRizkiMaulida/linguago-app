import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linguago_flutter/core/constants/colors.dart';
import 'package:linguago_flutter/data/chat/models/chat_message.dart';
import 'package:linguago_flutter/ui/bloc/chat/chat_detail_bloc.dart';

class ChatDetailPage extends StatefulWidget {
  final String friendName;
  final String friendAvatarUrl;
  final Color avatarColor;
  final String initial;

  const ChatDetailPage({
    super.key,
    required this.friendName,
    required this.friendAvatarUrl,
    required this.avatarColor,
    required this.initial,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _msgCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<ChatDetailBloc>().add(ChatDetailEvent.started(
          friendName: widget.friendName,
          friendAvatarUrl: widget.friendAvatarUrl,
          avatarColor: widget.avatarColor,
          initial: widget.initial,
        ));
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    context.read<ChatDetailBloc>().add(ChatDetailEvent.sendMessage(text));
    _msgCtrl.clear();
  }

  void _showClearDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hapus Obrolan',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: Text(
          'Hapus semua pesan dengan ${widget.friendName}?',
          style: TextStyle(color: AppColors.secondaryText, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal',
                style: TextStyle(color: AppColors.secondaryText)),
          ),
          TextButton(
            onPressed: () {
              context.read<ChatDetailBloc>().add(const ChatDetailEvent.clearChat());
              Navigator.pop(ctx);
            },
            child: const Text('Hapus',
                style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showDeleteMessageDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.delete_outline_rounded, size: 64, color: Colors.redAccent),
                const SizedBox(height: 16),
                const Text(
                  'Hapus Pesan?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Apakah Anda yakin ingin menghapus pesan ini? Tindakan ini tidak dapat dibatalkan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.secondaryText,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          side: const BorderSide(color: AppColors.disableBorder),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<ChatDetailBloc>()
                              .add(ChatDetailEvent.deleteMessage(index));
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pesan dihapus'),
                              backgroundColor: AppColors.primaryPurple,
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Hapus',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEmojiPicker() {
    final List<String> popularEmojis = [
      '😀', '😃', '😄', '😁', '😆', '😅', '😂', '🤣', '😊', '😇',
      '🙂', '🙃', '😉', '😌', '😍', '🥰', '😘', '😗', '😙', '😚',
      '😋', '😛', '😝', '😜', '🤪', '🤨', '🧐', '🤓', '😎', '🥸',
      '🤩', '🥳', '😏', '😒', '😞', '😔', '😟', '😕', '🙁', '☹️',
      '😣', '😖', '😫', '😩', '🥺', '😢', '😭', '😤', '😠', '😡',
      '👍', '👎', '👊', '✊', '🤛', '🤜', '🤞', '✌️', '🤟', '🤘',
      '👌', '🤌', '🤏', '👈', '👉', '👆', '👇', '☝️', '✋', '🤚',
      '🔥', '✨', '🎉', '💖', '❤️', '💔', '💩', '💯', '👏', '🙏'
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Emoji',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: popularEmojis.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        final text = _msgCtrl.text;
                        final selection = _msgCtrl.selection;
                        final cursorPosition = selection.baseOffset;

                        if (cursorPosition < 0) {
                          _msgCtrl.text = text + popularEmojis[index];
                        } else {
                          _msgCtrl.text = text.replaceRange(
                            selection.start,
                            selection.end,
                            popularEmojis[index],
                          );
                          _msgCtrl.selection = TextSelection.fromPosition(
                            TextPosition(offset: cursorPosition + popularEmojis[index].length),
                          );
                        }
                        Navigator.pop(context);
                        _focusNode.requestFocus();
                      },
                      child: Center(
                        child: Text(
                          popularEmojis[index],
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatDetailBloc, ChatDetailState>(
      builder: (context, state) {
        final messages = state.map(
          initial: (_) => <ChatMessage>[],
          loading: (_) => <ChatMessage>[],
          loaded: (l) => l.messages,
        );

        return Scaffold(
          backgroundColor: const Color(0xFFF3EEFB),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryPurple.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.chevron_left_rounded,
                            size: 30,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primaryPurple.withOpacity(0.4),
                                  width: 2,
                                ),
                                color: widget.avatarColor,
                              ),
                              child: ClipOval(
                                child: widget.friendAvatarUrl.isNotEmpty
                                    ? Image.network(
                                        widget.friendAvatarUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Center(
                                            child: Text(
                                              widget.initial,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Center(
                                        child: Text(
                                          widget.initial,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.friendName,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_vert_rounded,
                          color: AppColors.primaryText,
                          size: 26,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        onSelected: (val) {
                          if (val == 'clear') {
                            _showClearDialog();
                          }
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            value: 'clear',
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.redAccent,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Clear Chat',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: messages.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.chat_bubble_outline_rounded,
                                  size: 48,
                                  color: AppColors.secondaryText
                                      .withOpacity(0.3)),
                              const SizedBox(height: 12),
                              Text(
                                'Say hi to ${widget.friendName}! 👋',
                                style: TextStyle(
                                  color: AppColors.secondaryText
                                      .withOpacity(0.5),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollCtrl,
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          itemCount: messages.length,
                          itemBuilder: (context, i) => _MsgBubble(
                            msg: messages[i],
                            onLongPress: () => _showDeleteMessageDialog(i),
                          ),
                        ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 12,
                    right: 12,
                    top: 10,
                    bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 10 : 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryPurple.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3EEFB),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 18,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _showEmojiPicker,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3EEFB),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.emoji_emotions_outlined,
                            size: 18,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3EEFB),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: TextField(
                            controller: _msgCtrl,
                            focusNode: _focusNode,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _sendMessage(),
                            style: const TextStyle(
                                fontSize: 13, color: AppColors.primaryText),
                            decoration: const InputDecoration(
                              hintText: 'Type Message...',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                color: AppColors.disableText,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _sendMessage,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _msgCtrl.text.trim().isNotEmpty
                                ? AppColors.primaryPurple
                                : const Color(0xFFEDE7F8),
                            shape: BoxShape.circle,
                            boxShadow: _msgCtrl.text.trim().isNotEmpty
                                ? [
                                    BoxShadow(
                                      color: AppColors.primaryPurple.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.send_rounded,
                              color: _msgCtrl.text.trim().isNotEmpty
                                  ? Colors.white
                                  : AppColors.disableText,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MsgBubble extends StatelessWidget {
  final ChatMessage msg;
  final VoidCallback onLongPress;
  const _MsgBubble({required this.msg, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    final bool isMe = msg.isMe;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onLongPress: onLongPress,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth:
                          MediaQuery.of(context).size.width * 0.72,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe
                          ? AppColors.primaryPurple
                          : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft:
                            Radius.circular(isMe ? 18 : 4),
                        bottomRight:
                            Radius.circular(isMe ? 4 : 18),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isMe
                              ? AppColors.primaryPurple
                                  .withOpacity(0.25)
                              : Colors.black.withOpacity(0.06),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        fontSize: 13,
                        color: isMe
                            ? Colors.white
                            : AppColors.primaryText,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  msg.time,
                  style: TextStyle(
                    fontSize: 10,
                    color:
                        AppColors.secondaryText.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
