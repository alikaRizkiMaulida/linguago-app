import 'dart:async';
import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/chat_store.dart' as store;
import 'package:linguago_flutter/data/chat/models/chat_conversation.dart';
import 'package:linguago_flutter/data/chat/models/chat_message.dart';

ChatConversation _mapConv(store.ChatConversation c) => ChatConversation(
      friendName: c.friendName,
      friendAvatarUrl: c.friendAvatarUrl,
      avatarColor: c.avatarColor,
      initial: c.initial,
      lastMessage: c.lastMessage,
      lastTime: c.lastTime,
      unread: c.unread,
    );

class ChatRepository {
  static final ChatRepository _instance = ChatRepository._();
  ChatRepository._();
  factory ChatRepository() => _instance;

  final _store = store.ChatStore.instance;

  List<ChatConversation> get conversations =>
      _store.conversations.map(_mapConv).toList();

  List<ChatMessage> messagesFor(String friendName) =>
      _store.messagesFor(friendName)
          .map((m) => ChatMessage(text: m.text, isMe: m.isMe, time: m.time))
          .toList();

  ChatConversation getOrCreate({
    required String friendName,
    required String friendAvatarUrl,
    Color avatarColor = const Color(0xFFAA86E7),
    String initial = '?',
  }) {
    return _mapConv(_store.getOrCreate(
      friendName: friendName,
      friendAvatarUrl: friendAvatarUrl,
      avatarColor: avatarColor,
      initial: initial,
    ));
  }

  void sendMessage(String friendName, String text, {bool isMe = true}) {
    _store.sendMessage(friendName, text, isMe: isMe);
  }

  void deleteMessage(String friendName, int index) {
    _store.deleteMessage(friendName, index);
  }

  void clearMessages(String friendName) {
    _store.clearMessages(friendName);
  }

  void markRead(String friendName) {
    _store.markRead(friendName);
  }

  void addListener(VoidCallback listener) {
    _store.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    _store.removeListener(listener);
  }

  Stream<void> changes() {
    final controller = StreamController<void>.broadcast();
    _store.addListener(() => controller.add(null));
    return controller.stream;
  }
}
