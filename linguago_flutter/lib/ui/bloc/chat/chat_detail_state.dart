part of 'chat_detail_bloc.dart';

@freezed
class ChatDetailState with _$ChatDetailState {
  const factory ChatDetailState.initial() = _Initial;
  const factory ChatDetailState.loading() = _Loading;
  const factory ChatDetailState.loaded({
    required List<ChatMessage> messages,
    required String friendName,
    required String friendAvatarUrl,
    required Color avatarColor,
    required String initial,
  }) = _Loaded;
}
