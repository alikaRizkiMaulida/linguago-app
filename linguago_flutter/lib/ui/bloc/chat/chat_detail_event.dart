part of 'chat_detail_bloc.dart';

@freezed
class ChatDetailEvent with _$ChatDetailEvent {
  const factory ChatDetailEvent.started({
    required String friendName,
    required String friendAvatarUrl,
    @Default(Color(0xFFAA86E7)) Color avatarColor,
    @Default('?') String initial,
  }) = _Started;
  const factory ChatDetailEvent.sendMessage(String text) = _SendMessage;
  const factory ChatDetailEvent.deleteMessage(int index) = _DeleteMessage;
  const factory ChatDetailEvent.clearChat() = _ClearChat;
}
