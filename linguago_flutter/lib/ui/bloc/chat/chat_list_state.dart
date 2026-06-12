part of 'chat_list_bloc.dart';

@freezed
class ChatListState with _$ChatListState {
  const factory ChatListState.initial() = _Initial;
  const factory ChatListState.loading() = _Loading;
  const factory ChatListState.loaded({
    required List<ChatConversation> conversations,
    required String searchQuery,
  }) = _Loaded;
}
