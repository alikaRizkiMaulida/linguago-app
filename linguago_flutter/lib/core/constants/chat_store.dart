import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────────────────────────────────────
class ChatConversation {
  final String friendName;
  final String friendAvatarUrl;
  final Color avatarColor;
  final String initial;
  String lastMessage;
  String lastTime;
  int unread;

  ChatConversation({
    required this.friendName,
    required this.friendAvatarUrl,
    required this.avatarColor,
    required this.initial,
    this.lastMessage = '',
    this.lastTime = '',
    this.unread = 0,
  });
}

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;

  const ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// SINGLETON STORE
// ─────────────────────────────────────────────────────────────────────────────
/// Shared state untuk semua percakapan.
/// Diakses dari LeaderboardScreen (saat buka chat dari profil)
/// dan ChatPage (menampilkan daftar & isi pesan).
class ChatStore extends ChangeNotifier {
  static final ChatStore instance = ChatStore._();
  ChatStore._();

  final List<ChatConversation> conversations = [];
  final Map<String, List<ChatMessage>> _messages = {};

  /// Ambil atau buat conversation baru untuk [friendName]
  ChatConversation getOrCreate({
    required String friendName,
    required String friendAvatarUrl,
    Color avatarColor = const Color(0xFFAA86E7),
    String initial = '?',
  }) {
    final idx =
        conversations.indexWhere((c) => c.friendName == friendName);
    if (idx != -1) return conversations[idx];

    final conv = ChatConversation(
      friendName: friendName,
      friendAvatarUrl: friendAvatarUrl,
      avatarColor: avatarColor,
      initial: initial,
    );
    conversations.insert(0, conv);
    notifyListeners();
    return conv;
  }

  List<ChatMessage> messagesFor(String friendName) =>
      _messages[friendName] ?? [];

  void sendMessage(String friendName, String text, {bool isMe = true}) {
    _messages.putIfAbsent(friendName, () => []);
    final time = _formattedTime();
    _messages[friendName]!
        .add(ChatMessage(text: text, isMe: isMe, time: time));

    // Update last message & move to top
    final idx =
        conversations.indexWhere((c) => c.friendName == friendName);
    if (idx != -1) {
      final conv = conversations[idx];
      conv.lastMessage = isMe ? text : text;
      conv.lastTime = time;
      if (!isMe) conv.unread++;
      conversations.removeAt(idx);
      conversations.insert(0, conv);
    }
    notifyListeners();
  }

  void clearMessages(String friendName) {
    _messages[friendName]?.clear();
    final idx = conversations.indexWhere((c) => c.friendName == friendName);
    if (idx != -1) {
      conversations[idx].lastMessage = '';
      conversations[idx].lastTime = '';
    }
    notifyListeners();
  }

  void deleteMessage(String friendName, int index) {
    if (_messages.containsKey(friendName) && index >= 0 && index < _messages[friendName]!.length) {
      _messages[friendName]!.removeAt(index);
      final idx = conversations.indexWhere((c) => c.friendName == friendName);
      if (idx != -1) {
        if (_messages[friendName]!.isEmpty) {
          conversations[idx].lastMessage = '';
          conversations[idx].lastTime = '';
        } else {
          final lastMsg = _messages[friendName]!.last;
          conversations[idx].lastMessage = lastMsg.text;
          conversations[idx].lastTime = lastMsg.time;
        }
      }
      notifyListeners();
    }
  }

  void markRead(String friendName) {
    final idx =
        conversations.indexWhere((c) => c.friendName == friendName);
    if (idx != -1) {
      conversations[idx].unread = 0;
      notifyListeners();
    }
  }

  String _formattedTime() {
    final now = DateTime.now();
    final h = now.hour > 12
        ? now.hour - 12
        : now.hour == 0
            ? 12
            : now.hour;
    final m = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'pm' : 'am';
    return '$h:$m $period';
  }
}
