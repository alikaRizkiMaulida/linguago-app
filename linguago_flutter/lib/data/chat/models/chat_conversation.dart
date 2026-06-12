import 'package:flutter/material.dart';

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
