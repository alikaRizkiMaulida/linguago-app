import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';

class _ChatMessage {
  final String text;
  final bool isMe;
  final DateTime time;

  const _ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });
}

class ChatScreen extends StatefulWidget {
  final String friendName;
  final String friendAvatarUrl;

  const ChatScreen({
    super.key,
    required this.friendName,
    required this.friendAvatarUrl,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  final List<_ChatMessage> _messages = [];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(
        text: text,
        isMe: true,
        time: DateTime.now(),
      ));
      _controller.clear();
    });

    // Scroll to bottom after sending
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EEFB),
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ──────────────────────────────────────────────
            Container(
              color: const Color(0xFFF3EEFB),
              padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
              child: Row(
                children: [
                  // Back
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
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

                  // Avatar + Name (centered)
                  Expanded(
                    child: Column(
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
                            image: DecorationImage(
                              image: NetworkImage(widget.friendAvatarUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.friendName,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Call icon
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPurple.withOpacity(0.10),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.phone_rounded,
                      size: 18,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
            ),

            // ── Messages Area ────────────────────────────────────────
            Expanded(
              child: _messages.isEmpty
                  ? const SizedBox() // empty state — same as design (blank)
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        return _MessageBubble(message: msg);
                      },
                    ),
            ),

            // ── Input Bar ────────────────────────────────────────────
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                top: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 10 : 20,
              ),
              child: Row(
                children: [
                  // Camera icon
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3EEFB),
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

                  // Emoji icon
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3EEFB),
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

                  // Text field
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3EEFB),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.primaryText,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Type Message...',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: AppColors.disableText,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              if (_controller.text.trim().isNotEmpty) {
                                _sendMessage();
                              }
                            },
                            child: Icon(
                              _controller.text.trim().isNotEmpty
                                  ? Icons.send_rounded
                                  : Icons.mic_none_rounded,
                              size: 18,
                              color: _controller.text.trim().isNotEmpty
                                  ? AppColors.primaryPurple
                                  : AppColors.secondaryText,
                            ),
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                        onSubmitted: (_) => _sendMessage(),
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
  }
}

// ─── Message Bubble ───────────────────────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.70,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryPurple : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            fontSize: 13,
            color: isMe ? Colors.white : AppColors.primaryText,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
