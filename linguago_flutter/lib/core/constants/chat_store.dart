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
  ChatStore._() {
    _initMockData();
  }

  void _initMockData() {
    final list = [
      ChatConversation(
        friendName: '1009-eism',
        friendAvatarUrl: 'https://i.pravatar.cc/150?img=1',
        avatarColor: const Color(0xFFAA86E7),
        initial: '1',
        lastMessage: 'iya aku juga gtu',
        lastTime: '07.30 pm',
        unread: 0,
      ),
      ChatConversation(
        friendName: 'sunooflers',
        friendAvatarUrl: 'https://i.pravatar.cc/150?img=2',
        avatarColor: const Color(0xFFAA86E7),
        initial: 'S',
        lastMessage: 'trimakasih bykk',
        lastTime: '05.12 pm',
        unread: 0,
      ),
      ChatConversation(
        friendName: 'milk.도토리',
        friendAvatarUrl: 'https://i.pravatar.cc/150?img=3',
        avatarColor: const Color(0xFFAA86E7),
        initial: 'M',
        lastMessage: 'bener gksih',
        lastTime: '01.58 pm',
        unread: 0,
      ),
      ChatConversation(
        friendName: 'heesour',
        friendAvatarUrl: 'https://i.pravatar.cc/150?img=4',
        avatarColor: const Color(0xFFAA86E7),
        initial: 'H',
        lastMessage: 'ktny gtuu',
        lastTime: '11.46 am',
        unread: 0,
      ),
      ChatConversation(
        friendName: 'rikiusier',
        friendAvatarUrl: 'https://i.pravatar.cc/150?img=5',
        avatarColor: const Color(0xFFAA86E7),
        initial: 'R',
        lastMessage: 'oiya kh?',
        lastTime: '06.32 am',
        unread: 0,
      ),
    ];

    conversations.addAll(list);

    _messages['1009-eism'] = [
      const ChatMessage(text: 'iya aku juga gtu', isMe: false, time: '07.30 pm'),
    ];
    _messages['sunooflers'] = [
      const ChatMessage(text: 'trimakasih bykk', isMe: false, time: '05.12 pm'),
    ];
    _messages['milk.도토리'] = [
      const ChatMessage(text: 'bener gksih', isMe: false, time: '01.58 pm'),
    ];
    _messages['heesour'] = [
      const ChatMessage(text: 'ktny gtuu', isMe: false, time: '11.46 am'),
    ];
    _messages['rikiusier'] = [
      const ChatMessage(text: 'oiya kh?', isMe: false, time: '06.32 am'),
    ];
  }

  final List<ChatConversation> conversations = [];
  final Map<String, List<ChatMessage>> _messages = {};

  VoidCallback? onNewMessage;

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
      conv.lastMessage = text;
      conv.lastTime = time;
      if (!isMe) {
        conv.unread++;
        onNewMessage?.call();
      }
      conversations.removeAt(idx);
      conversations.insert(0, conv);
    }
    notifyListeners();

    if (isMe) {
      // Trigger a mock reply from the friend after 1.5 seconds
      Future.delayed(const Duration(milliseconds: 1500), () {
        String replyText = 'okayyy';
        if (text.toLowerCase().contains('bener')) {
          replyText = 'bener gksih';
        } else {
          switch (friendName) {
            case '1009-eism':
              replyText = 'iya aku juga gtu';
              break;
            case 'sunooflers':
              replyText = 'trimakasih bykk';
              break;
            case 'milk.도토리':
              replyText = 'bener gksih';
              break;
            case 'heesour':
              replyText = 'okayyy';
              break;
            case 'rikiusier':
              replyText = 'oiya kh?';
              break;
          }
        }
        sendMessage(friendName, replyText, isMe: false);
      });
    }
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
