// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_detail_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatDetailEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatDetailEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatDetailEvent()';
}


}

/// @nodoc
class $ChatDetailEventCopyWith<$Res>  {
$ChatDetailEventCopyWith(ChatDetailEvent _, $Res Function(ChatDetailEvent) __);
}


/// Adds pattern-matching-related methods to [ChatDetailEvent].
extension ChatDetailEventPatterns on ChatDetailEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _SendMessage value)?  sendMessage,TResult Function( _DeleteMessage value)?  deleteMessage,TResult Function( _ClearChat value)?  clearChat,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _SendMessage() when sendMessage != null:
return sendMessage(_that);case _DeleteMessage() when deleteMessage != null:
return deleteMessage(_that);case _ClearChat() when clearChat != null:
return clearChat(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _SendMessage value)  sendMessage,required TResult Function( _DeleteMessage value)  deleteMessage,required TResult Function( _ClearChat value)  clearChat,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _SendMessage():
return sendMessage(_that);case _DeleteMessage():
return deleteMessage(_that);case _ClearChat():
return clearChat(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _SendMessage value)?  sendMessage,TResult? Function( _DeleteMessage value)?  deleteMessage,TResult? Function( _ClearChat value)?  clearChat,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _SendMessage() when sendMessage != null:
return sendMessage(_that);case _DeleteMessage() when deleteMessage != null:
return deleteMessage(_that);case _ClearChat() when clearChat != null:
return clearChat(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String friendName,  String friendAvatarUrl,  Color avatarColor,  String initial)?  started,TResult Function( String text)?  sendMessage,TResult Function( int index)?  deleteMessage,TResult Function()?  clearChat,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.friendName,_that.friendAvatarUrl,_that.avatarColor,_that.initial);case _SendMessage() when sendMessage != null:
return sendMessage(_that.text);case _DeleteMessage() when deleteMessage != null:
return deleteMessage(_that.index);case _ClearChat() when clearChat != null:
return clearChat();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String friendName,  String friendAvatarUrl,  Color avatarColor,  String initial)  started,required TResult Function( String text)  sendMessage,required TResult Function( int index)  deleteMessage,required TResult Function()  clearChat,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.friendName,_that.friendAvatarUrl,_that.avatarColor,_that.initial);case _SendMessage():
return sendMessage(_that.text);case _DeleteMessage():
return deleteMessage(_that.index);case _ClearChat():
return clearChat();case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String friendName,  String friendAvatarUrl,  Color avatarColor,  String initial)?  started,TResult? Function( String text)?  sendMessage,TResult? Function( int index)?  deleteMessage,TResult? Function()?  clearChat,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.friendName,_that.friendAvatarUrl,_that.avatarColor,_that.initial);case _SendMessage() when sendMessage != null:
return sendMessage(_that.text);case _DeleteMessage() when deleteMessage != null:
return deleteMessage(_that.index);case _ClearChat() when clearChat != null:
return clearChat();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements ChatDetailEvent {
  const _Started({required this.friendName, required this.friendAvatarUrl, this.avatarColor = const Color(0xFFAA86E7), this.initial = '?'});
  

 final  String friendName;
 final  String friendAvatarUrl;
@JsonKey() final  Color avatarColor;
@JsonKey() final  String initial;

/// Create a copy of ChatDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartedCopyWith<_Started> get copyWith => __$StartedCopyWithImpl<_Started>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started&&(identical(other.friendName, friendName) || other.friendName == friendName)&&(identical(other.friendAvatarUrl, friendAvatarUrl) || other.friendAvatarUrl == friendAvatarUrl)&&(identical(other.avatarColor, avatarColor) || other.avatarColor == avatarColor)&&(identical(other.initial, initial) || other.initial == initial));
}


@override
int get hashCode => Object.hash(runtimeType,friendName,friendAvatarUrl,avatarColor,initial);

@override
String toString() {
  return 'ChatDetailEvent.started(friendName: $friendName, friendAvatarUrl: $friendAvatarUrl, avatarColor: $avatarColor, initial: $initial)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $ChatDetailEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@useResult
$Res call({
 String friendName, String friendAvatarUrl, Color avatarColor, String initial
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of ChatDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? friendName = null,Object? friendAvatarUrl = null,Object? avatarColor = null,Object? initial = null,}) {
  return _then(_Started(
friendName: null == friendName ? _self.friendName : friendName // ignore: cast_nullable_to_non_nullable
as String,friendAvatarUrl: null == friendAvatarUrl ? _self.friendAvatarUrl : friendAvatarUrl // ignore: cast_nullable_to_non_nullable
as String,avatarColor: null == avatarColor ? _self.avatarColor : avatarColor // ignore: cast_nullable_to_non_nullable
as Color,initial: null == initial ? _self.initial : initial // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SendMessage implements ChatDetailEvent {
  const _SendMessage(this.text);
  

 final  String text;

/// Create a copy of ChatDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendMessageCopyWith<_SendMessage> get copyWith => __$SendMessageCopyWithImpl<_SendMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendMessage&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,text);

@override
String toString() {
  return 'ChatDetailEvent.sendMessage(text: $text)';
}


}

/// @nodoc
abstract mixin class _$SendMessageCopyWith<$Res> implements $ChatDetailEventCopyWith<$Res> {
  factory _$SendMessageCopyWith(_SendMessage value, $Res Function(_SendMessage) _then) = __$SendMessageCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class __$SendMessageCopyWithImpl<$Res>
    implements _$SendMessageCopyWith<$Res> {
  __$SendMessageCopyWithImpl(this._self, this._then);

  final _SendMessage _self;
  final $Res Function(_SendMessage) _then;

/// Create a copy of ChatDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(_SendMessage(
null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _DeleteMessage implements ChatDetailEvent {
  const _DeleteMessage(this.index);
  

 final  int index;

/// Create a copy of ChatDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteMessageCopyWith<_DeleteMessage> get copyWith => __$DeleteMessageCopyWithImpl<_DeleteMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteMessage&&(identical(other.index, index) || other.index == index));
}


@override
int get hashCode => Object.hash(runtimeType,index);

@override
String toString() {
  return 'ChatDetailEvent.deleteMessage(index: $index)';
}


}

/// @nodoc
abstract mixin class _$DeleteMessageCopyWith<$Res> implements $ChatDetailEventCopyWith<$Res> {
  factory _$DeleteMessageCopyWith(_DeleteMessage value, $Res Function(_DeleteMessage) _then) = __$DeleteMessageCopyWithImpl;
@useResult
$Res call({
 int index
});




}
/// @nodoc
class __$DeleteMessageCopyWithImpl<$Res>
    implements _$DeleteMessageCopyWith<$Res> {
  __$DeleteMessageCopyWithImpl(this._self, this._then);

  final _DeleteMessage _self;
  final $Res Function(_DeleteMessage) _then;

/// Create a copy of ChatDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,}) {
  return _then(_DeleteMessage(
null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _ClearChat implements ChatDetailEvent {
  const _ClearChat();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClearChat);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatDetailEvent.clearChat()';
}


}




/// @nodoc
mixin _$ChatDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatDetailState()';
}


}

/// @nodoc
class $ChatDetailStateCopyWith<$Res>  {
$ChatDetailStateCopyWith(ChatDetailState _, $Res Function(ChatDetailState) __);
}


/// Adds pattern-matching-related methods to [ChatDetailState].
extension ChatDetailStatePatterns on ChatDetailState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ChatMessage> messages,  String friendName,  String friendAvatarUrl,  Color avatarColor,  String initial)?  loaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.messages,_that.friendName,_that.friendAvatarUrl,_that.avatarColor,_that.initial);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ChatMessage> messages,  String friendName,  String friendAvatarUrl,  Color avatarColor,  String initial)  loaded,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.messages,_that.friendName,_that.friendAvatarUrl,_that.avatarColor,_that.initial);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ChatMessage> messages,  String friendName,  String friendAvatarUrl,  Color avatarColor,  String initial)?  loaded,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.messages,_that.friendName,_that.friendAvatarUrl,_that.avatarColor,_that.initial);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements ChatDetailState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatDetailState.initial()';
}


}




/// @nodoc


class _Loading implements ChatDetailState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatDetailState.loading()';
}


}




/// @nodoc


class _Loaded implements ChatDetailState {
  const _Loaded({required final  List<ChatMessage> messages, required this.friendName, required this.friendAvatarUrl, required this.avatarColor, required this.initial}): _messages = messages;
  

 final  List<ChatMessage> _messages;
 List<ChatMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

 final  String friendName;
 final  String friendAvatarUrl;
 final  Color avatarColor;
 final  String initial;

/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.friendName, friendName) || other.friendName == friendName)&&(identical(other.friendAvatarUrl, friendAvatarUrl) || other.friendAvatarUrl == friendAvatarUrl)&&(identical(other.avatarColor, avatarColor) || other.avatarColor == avatarColor)&&(identical(other.initial, initial) || other.initial == initial));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages),friendName,friendAvatarUrl,avatarColor,initial);

@override
String toString() {
  return 'ChatDetailState.loaded(messages: $messages, friendName: $friendName, friendAvatarUrl: $friendAvatarUrl, avatarColor: $avatarColor, initial: $initial)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $ChatDetailStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<ChatMessage> messages, String friendName, String friendAvatarUrl, Color avatarColor, String initial
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? messages = null,Object? friendName = null,Object? friendAvatarUrl = null,Object? avatarColor = null,Object? initial = null,}) {
  return _then(_Loaded(
messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,friendName: null == friendName ? _self.friendName : friendName // ignore: cast_nullable_to_non_nullable
as String,friendAvatarUrl: null == friendAvatarUrl ? _self.friendAvatarUrl : friendAvatarUrl // ignore: cast_nullable_to_non_nullable
as String,avatarColor: null == avatarColor ? _self.avatarColor : avatarColor // ignore: cast_nullable_to_non_nullable
as Color,initial: null == initial ? _self.initial : initial // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
