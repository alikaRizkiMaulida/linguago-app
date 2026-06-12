import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:linguago_flutter/data/chat/chat_repository.dart';
import 'package:linguago_flutter/data/chat/models/chat_conversation.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';
part 'chat_list_bloc.freezed.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatRepository _repo;
  StreamSubscription? _sub;

  ChatListBloc({ChatRepository? repo})
      : _repo = repo ?? ChatRepository(),
        super(const ChatListState.initial()) {
    on<ChatListEvent>((event, emit) async {
      await event.map(
        started: (_) async {
          emit(const ChatListState.loading());
          _sub?.cancel();
          _sub = _repo.changes().listen((_) => _onChanged());
          _emitLoaded(emit, '');
        },
        searchChanged: (e) async {
          _emitLoaded(emit, e.query);
        },
      );
    });
  }

  void _onChanged() {
    if (!isClosed) {
      add(const ChatListEvent.started());
    }
  }

  void _emitLoaded(Emitter<ChatListState> emit, String query) {
    final all = _repo.conversations;
    final filtered = query.isEmpty
        ? all
        : all
            .where((c) =>
                c.friendName.toLowerCase().contains(query.toLowerCase()) ||
                c.lastMessage.toLowerCase().contains(query.toLowerCase()))
            .toList();
    emit(ChatListState.loaded(
      conversations: filtered,
      searchQuery: query,
    ));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
