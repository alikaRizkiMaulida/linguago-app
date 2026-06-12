// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leaderboard_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LeaderboardEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaderboardEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LeaderboardEvent()';
}


}

/// @nodoc
class $LeaderboardEventCopyWith<$Res>  {
$LeaderboardEventCopyWith(LeaderboardEvent _, $Res Function(LeaderboardEvent) __);
}


/// Adds pattern-matching-related methods to [LeaderboardEvent].
extension LeaderboardEventPatterns on LeaderboardEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _TabChanged value)?  tabChanged,TResult Function( _ToggleFriend value)?  toggleFriend,TResult Function( _SearchUsers value)?  searchUsers,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _TabChanged() when tabChanged != null:
return tabChanged(_that);case _ToggleFriend() when toggleFriend != null:
return toggleFriend(_that);case _SearchUsers() when searchUsers != null:
return searchUsers(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _TabChanged value)  tabChanged,required TResult Function( _ToggleFriend value)  toggleFriend,required TResult Function( _SearchUsers value)  searchUsers,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _TabChanged():
return tabChanged(_that);case _ToggleFriend():
return toggleFriend(_that);case _SearchUsers():
return searchUsers(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _TabChanged value)?  tabChanged,TResult? Function( _ToggleFriend value)?  toggleFriend,TResult? Function( _SearchUsers value)?  searchUsers,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _TabChanged() when tabChanged != null:
return tabChanged(_that);case _ToggleFriend() when toggleFriend != null:
return toggleFriend(_that);case _SearchUsers() when searchUsers != null:
return searchUsers(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( int index)?  tabChanged,TResult Function( String name)?  toggleFriend,TResult Function( String query)?  searchUsers,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _TabChanged() when tabChanged != null:
return tabChanged(_that.index);case _ToggleFriend() when toggleFriend != null:
return toggleFriend(_that.name);case _SearchUsers() when searchUsers != null:
return searchUsers(_that.query);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( int index)  tabChanged,required TResult Function( String name)  toggleFriend,required TResult Function( String query)  searchUsers,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _TabChanged():
return tabChanged(_that.index);case _ToggleFriend():
return toggleFriend(_that.name);case _SearchUsers():
return searchUsers(_that.query);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( int index)?  tabChanged,TResult? Function( String name)?  toggleFriend,TResult? Function( String query)?  searchUsers,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _TabChanged() when tabChanged != null:
return tabChanged(_that.index);case _ToggleFriend() when toggleFriend != null:
return toggleFriend(_that.name);case _SearchUsers() when searchUsers != null:
return searchUsers(_that.query);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements LeaderboardEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LeaderboardEvent.started()';
}


}




/// @nodoc


class _TabChanged implements LeaderboardEvent {
  const _TabChanged({required this.index});
  

 final  int index;

/// Create a copy of LeaderboardEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TabChangedCopyWith<_TabChanged> get copyWith => __$TabChangedCopyWithImpl<_TabChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TabChanged&&(identical(other.index, index) || other.index == index));
}


@override
int get hashCode => Object.hash(runtimeType,index);

@override
String toString() {
  return 'LeaderboardEvent.tabChanged(index: $index)';
}


}

/// @nodoc
abstract mixin class _$TabChangedCopyWith<$Res> implements $LeaderboardEventCopyWith<$Res> {
  factory _$TabChangedCopyWith(_TabChanged value, $Res Function(_TabChanged) _then) = __$TabChangedCopyWithImpl;
@useResult
$Res call({
 int index
});




}
/// @nodoc
class __$TabChangedCopyWithImpl<$Res>
    implements _$TabChangedCopyWith<$Res> {
  __$TabChangedCopyWithImpl(this._self, this._then);

  final _TabChanged _self;
  final $Res Function(_TabChanged) _then;

/// Create a copy of LeaderboardEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,}) {
  return _then(_TabChanged(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _ToggleFriend implements LeaderboardEvent {
  const _ToggleFriend({required this.name});
  

 final  String name;

/// Create a copy of LeaderboardEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ToggleFriendCopyWith<_ToggleFriend> get copyWith => __$ToggleFriendCopyWithImpl<_ToggleFriend>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToggleFriend&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'LeaderboardEvent.toggleFriend(name: $name)';
}


}

/// @nodoc
abstract mixin class _$ToggleFriendCopyWith<$Res> implements $LeaderboardEventCopyWith<$Res> {
  factory _$ToggleFriendCopyWith(_ToggleFriend value, $Res Function(_ToggleFriend) _then) = __$ToggleFriendCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class __$ToggleFriendCopyWithImpl<$Res>
    implements _$ToggleFriendCopyWith<$Res> {
  __$ToggleFriendCopyWithImpl(this._self, this._then);

  final _ToggleFriend _self;
  final $Res Function(_ToggleFriend) _then;

/// Create a copy of LeaderboardEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_ToggleFriend(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SearchUsers implements LeaderboardEvent {
  const _SearchUsers({required this.query});
  

 final  String query;

/// Create a copy of LeaderboardEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchUsersCopyWith<_SearchUsers> get copyWith => __$SearchUsersCopyWithImpl<_SearchUsers>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchUsers&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'LeaderboardEvent.searchUsers(query: $query)';
}


}

/// @nodoc
abstract mixin class _$SearchUsersCopyWith<$Res> implements $LeaderboardEventCopyWith<$Res> {
  factory _$SearchUsersCopyWith(_SearchUsers value, $Res Function(_SearchUsers) _then) = __$SearchUsersCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class __$SearchUsersCopyWithImpl<$Res>
    implements _$SearchUsersCopyWith<$Res> {
  __$SearchUsersCopyWithImpl(this._self, this._then);

  final _SearchUsers _self;
  final $Res Function(_SearchUsers) _then;

/// Create a copy of LeaderboardEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(_SearchUsers(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$LeaderboardState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaderboardState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LeaderboardState()';
}


}

/// @nodoc
class $LeaderboardStateCopyWith<$Res>  {
$LeaderboardStateCopyWith(LeaderboardState _, $Res Function(LeaderboardState) __);
}


/// Adds pattern-matching-related methods to [LeaderboardState].
extension LeaderboardStatePatterns on LeaderboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Error():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( int selectedTab,  List<Player> worldPlayers,  List<Player> friendPlayers,  List<Friend> friends,  List<Friend> recommendations,  String? searchQuery)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.selectedTab,_that.worldPlayers,_that.friendPlayers,_that.friends,_that.recommendations,_that.searchQuery);case _Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( int selectedTab,  List<Player> worldPlayers,  List<Player> friendPlayers,  List<Friend> friends,  List<Friend> recommendations,  String? searchQuery)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.selectedTab,_that.worldPlayers,_that.friendPlayers,_that.friends,_that.recommendations,_that.searchQuery);case _Error():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( int selectedTab,  List<Player> worldPlayers,  List<Player> friendPlayers,  List<Friend> friends,  List<Friend> recommendations,  String? searchQuery)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.selectedTab,_that.worldPlayers,_that.friendPlayers,_that.friends,_that.recommendations,_that.searchQuery);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements LeaderboardState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LeaderboardState.initial()';
}


}




/// @nodoc


class _Loading implements LeaderboardState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LeaderboardState.loading()';
}


}




/// @nodoc


class _Loaded implements LeaderboardState {
  const _Loaded({required this.selectedTab, required final  List<Player> worldPlayers, required final  List<Player> friendPlayers, required final  List<Friend> friends, required final  List<Friend> recommendations, this.searchQuery}): _worldPlayers = worldPlayers,_friendPlayers = friendPlayers,_friends = friends,_recommendations = recommendations;
  

 final  int selectedTab;
 final  List<Player> _worldPlayers;
 List<Player> get worldPlayers {
  if (_worldPlayers is EqualUnmodifiableListView) return _worldPlayers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_worldPlayers);
}

 final  List<Player> _friendPlayers;
 List<Player> get friendPlayers {
  if (_friendPlayers is EqualUnmodifiableListView) return _friendPlayers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_friendPlayers);
}

 final  List<Friend> _friends;
 List<Friend> get friends {
  if (_friends is EqualUnmodifiableListView) return _friends;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_friends);
}

 final  List<Friend> _recommendations;
 List<Friend> get recommendations {
  if (_recommendations is EqualUnmodifiableListView) return _recommendations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recommendations);
}

 final  String? searchQuery;

/// Create a copy of LeaderboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.selectedTab, selectedTab) || other.selectedTab == selectedTab)&&const DeepCollectionEquality().equals(other._worldPlayers, _worldPlayers)&&const DeepCollectionEquality().equals(other._friendPlayers, _friendPlayers)&&const DeepCollectionEquality().equals(other._friends, _friends)&&const DeepCollectionEquality().equals(other._recommendations, _recommendations)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,selectedTab,const DeepCollectionEquality().hash(_worldPlayers),const DeepCollectionEquality().hash(_friendPlayers),const DeepCollectionEquality().hash(_friends),const DeepCollectionEquality().hash(_recommendations),searchQuery);

@override
String toString() {
  return 'LeaderboardState.loaded(selectedTab: $selectedTab, worldPlayers: $worldPlayers, friendPlayers: $friendPlayers, friends: $friends, recommendations: $recommendations, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $LeaderboardStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 int selectedTab, List<Player> worldPlayers, List<Player> friendPlayers, List<Friend> friends, List<Friend> recommendations, String? searchQuery
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of LeaderboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? selectedTab = null,Object? worldPlayers = null,Object? friendPlayers = null,Object? friends = null,Object? recommendations = null,Object? searchQuery = freezed,}) {
  return _then(_Loaded(
selectedTab: null == selectedTab ? _self.selectedTab : selectedTab // ignore: cast_nullable_to_non_nullable
as int,worldPlayers: null == worldPlayers ? _self._worldPlayers : worldPlayers // ignore: cast_nullable_to_non_nullable
as List<Player>,friendPlayers: null == friendPlayers ? _self._friendPlayers : friendPlayers // ignore: cast_nullable_to_non_nullable
as List<Player>,friends: null == friends ? _self._friends : friends // ignore: cast_nullable_to_non_nullable
as List<Friend>,recommendations: null == recommendations ? _self._recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as List<Friend>,searchQuery: freezed == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _Error implements LeaderboardState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of LeaderboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'LeaderboardState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $LeaderboardStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of LeaderboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
