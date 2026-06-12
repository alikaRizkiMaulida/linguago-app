import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:linguago_flutter/data/chat/chat_repository.dart';
import 'package:linguago_flutter/data/chat/models/chat_message.dart';

part 'chat_detail_event.dart';
part 'chat_detail_state.dart';
part 'chat_detail_bloc.freezed.dart';

class ChatDetailBloc extends Bloc<ChatDetailEvent, ChatDetailState> {
  final ChatRepository _repo;
  StreamSubscription? _sub;
  String _friendName = '';
  String _friendAvatarUrl = '';
  Color _avatarColor = const Color(0xFFAA86E7);
  String _initial = '?';

  ChatDetailBloc({ChatRepository? repo})
      : _repo = repo ?? ChatRepository(),
        super(const ChatDetailState.initial()) {
    on<ChatDetailEvent>((event, emit) async {
      await event.map(
        started: (e) async {
          _friendName = e.friendName;
          _friendAvatarUrl = e.friendAvatarUrl;
          _avatarColor = e.avatarColor;
          _initial = e.initial;

          _repo.getOrCreate(
            friendName: _friendName,
            friendAvatarUrl: _friendAvatarUrl,
            avatarColor: _avatarColor,
            initial: _initial,
          );
          _repo.markRead(_friendName);

          emit(const ChatDetailState.loading());
          _sub?.cancel();
          _sub = _repo.changes().listen((_) => _emitLoaded(emit));
          _emitLoaded(emit);
        },
        sendMessage: (e) async {
          if (e.text.trim().isEmpty) return;
          _repo.sendMessage(_friendName, e.text.trim(), isMe: true);
        },
        deleteMessage: (e) async {
          _repo.deleteMessage(_friendName, e.index);
        },
        clearChat: (_) async {
          _repo.clearMessages(_friendName);
        },
      );
    });
  }

  void _emitLoaded(Emitter<ChatDetailState> emit) {
    final messages = _repo.messagesFor(_friendName);
    emit(ChatDetailState.loaded(
      messages: messages,
      friendName: _friendName,
      friendAvatarUrl: _friendAvatarUrl,
      avatarColor: _avatarColor,
      initial: _initial,
    ));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
