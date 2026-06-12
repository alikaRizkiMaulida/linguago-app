// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuizEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuizEvent()';
}


}

/// @nodoc
class $QuizEventCopyWith<$Res>  {
$QuizEventCopyWith(QuizEvent _, $Res Function(QuizEvent) __);
}


/// Adds pattern-matching-related methods to [QuizEvent].
extension QuizEventPatterns on QuizEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _OptionTapped value)?  optionTapped,TResult Function( _LetterTapped value)?  letterTapped,TResult Function( _CheckAnswer value)?  checkAnswer,TResult Function( _NextQuestion value)?  nextQuestion,TResult Function( _ResetQuiz value)?  resetQuiz,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _OptionTapped() when optionTapped != null:
return optionTapped(_that);case _LetterTapped() when letterTapped != null:
return letterTapped(_that);case _CheckAnswer() when checkAnswer != null:
return checkAnswer(_that);case _NextQuestion() when nextQuestion != null:
return nextQuestion(_that);case _ResetQuiz() when resetQuiz != null:
return resetQuiz(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _OptionTapped value)  optionTapped,required TResult Function( _LetterTapped value)  letterTapped,required TResult Function( _CheckAnswer value)  checkAnswer,required TResult Function( _NextQuestion value)  nextQuestion,required TResult Function( _ResetQuiz value)  resetQuiz,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _OptionTapped():
return optionTapped(_that);case _LetterTapped():
return letterTapped(_that);case _CheckAnswer():
return checkAnswer(_that);case _NextQuestion():
return nextQuestion(_that);case _ResetQuiz():
return resetQuiz(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _OptionTapped value)?  optionTapped,TResult? Function( _LetterTapped value)?  letterTapped,TResult? Function( _CheckAnswer value)?  checkAnswer,TResult? Function( _NextQuestion value)?  nextQuestion,TResult? Function( _ResetQuiz value)?  resetQuiz,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _OptionTapped() when optionTapped != null:
return optionTapped(_that);case _LetterTapped() when letterTapped != null:
return letterTapped(_that);case _CheckAnswer() when checkAnswer != null:
return checkAnswer(_that);case _NextQuestion() when nextQuestion != null:
return nextQuestion(_that);case _ResetQuiz() when resetQuiz != null:
return resetQuiz(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int part)?  started,TResult Function( int index)?  optionTapped,TResult Function( int index)?  letterTapped,TResult Function()?  checkAnswer,TResult Function()?  nextQuestion,TResult Function()?  resetQuiz,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.part);case _OptionTapped() when optionTapped != null:
return optionTapped(_that.index);case _LetterTapped() when letterTapped != null:
return letterTapped(_that.index);case _CheckAnswer() when checkAnswer != null:
return checkAnswer();case _NextQuestion() when nextQuestion != null:
return nextQuestion();case _ResetQuiz() when resetQuiz != null:
return resetQuiz();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int part)  started,required TResult Function( int index)  optionTapped,required TResult Function( int index)  letterTapped,required TResult Function()  checkAnswer,required TResult Function()  nextQuestion,required TResult Function()  resetQuiz,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.part);case _OptionTapped():
return optionTapped(_that.index);case _LetterTapped():
return letterTapped(_that.index);case _CheckAnswer():
return checkAnswer();case _NextQuestion():
return nextQuestion();case _ResetQuiz():
return resetQuiz();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int part)?  started,TResult? Function( int index)?  optionTapped,TResult? Function( int index)?  letterTapped,TResult? Function()?  checkAnswer,TResult? Function()?  nextQuestion,TResult? Function()?  resetQuiz,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.part);case _OptionTapped() when optionTapped != null:
return optionTapped(_that.index);case _LetterTapped() when letterTapped != null:
return letterTapped(_that.index);case _CheckAnswer() when checkAnswer != null:
return checkAnswer();case _NextQuestion() when nextQuestion != null:
return nextQuestion();case _ResetQuiz() when resetQuiz != null:
return resetQuiz();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements QuizEvent {
  const _Started({required this.part});
  

 final  int part;

/// Create a copy of QuizEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartedCopyWith<_Started> get copyWith => __$StartedCopyWithImpl<_Started>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started&&(identical(other.part, part) || other.part == part));
}


@override
int get hashCode => Object.hash(runtimeType,part);

@override
String toString() {
  return 'QuizEvent.started(part: $part)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $QuizEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@useResult
$Res call({
 int part
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of QuizEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? part = null,}) {
  return _then(_Started(
part: null == part ? _self.part : part // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _OptionTapped implements QuizEvent {
  const _OptionTapped({required this.index});
  

 final  int index;

/// Create a copy of QuizEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OptionTappedCopyWith<_OptionTapped> get copyWith => __$OptionTappedCopyWithImpl<_OptionTapped>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OptionTapped&&(identical(other.index, index) || other.index == index));
}


@override
int get hashCode => Object.hash(runtimeType,index);

@override
String toString() {
  return 'QuizEvent.optionTapped(index: $index)';
}


}

/// @nodoc
abstract mixin class _$OptionTappedCopyWith<$Res> implements $QuizEventCopyWith<$Res> {
  factory _$OptionTappedCopyWith(_OptionTapped value, $Res Function(_OptionTapped) _then) = __$OptionTappedCopyWithImpl;
@useResult
$Res call({
 int index
});




}
/// @nodoc
class __$OptionTappedCopyWithImpl<$Res>
    implements _$OptionTappedCopyWith<$Res> {
  __$OptionTappedCopyWithImpl(this._self, this._then);

  final _OptionTapped _self;
  final $Res Function(_OptionTapped) _then;

/// Create a copy of QuizEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,}) {
  return _then(_OptionTapped(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _LetterTapped implements QuizEvent {
  const _LetterTapped({required this.index});
  

 final  int index;

/// Create a copy of QuizEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LetterTappedCopyWith<_LetterTapped> get copyWith => __$LetterTappedCopyWithImpl<_LetterTapped>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LetterTapped&&(identical(other.index, index) || other.index == index));
}


@override
int get hashCode => Object.hash(runtimeType,index);

@override
String toString() {
  return 'QuizEvent.letterTapped(index: $index)';
}


}

/// @nodoc
abstract mixin class _$LetterTappedCopyWith<$Res> implements $QuizEventCopyWith<$Res> {
  factory _$LetterTappedCopyWith(_LetterTapped value, $Res Function(_LetterTapped) _then) = __$LetterTappedCopyWithImpl;
@useResult
$Res call({
 int index
});




}
/// @nodoc
class __$LetterTappedCopyWithImpl<$Res>
    implements _$LetterTappedCopyWith<$Res> {
  __$LetterTappedCopyWithImpl(this._self, this._then);

  final _LetterTapped _self;
  final $Res Function(_LetterTapped) _then;

/// Create a copy of QuizEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,}) {
  return _then(_LetterTapped(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _CheckAnswer implements QuizEvent {
  const _CheckAnswer();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckAnswer);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuizEvent.checkAnswer()';
}


}




/// @nodoc


class _NextQuestion implements QuizEvent {
  const _NextQuestion();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NextQuestion);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuizEvent.nextQuestion()';
}


}




/// @nodoc


class _ResetQuiz implements QuizEvent {
  const _ResetQuiz();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResetQuiz);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuizEvent.resetQuiz()';
}


}




/// @nodoc
mixin _$QuizState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuizState()';
}


}

/// @nodoc
class $QuizStateCopyWith<$Res>  {
$QuizStateCopyWith(QuizState _, $Res Function(QuizState) __);
}


/// Adds pattern-matching-related methods to [QuizState].
extension QuizStatePatterns on QuizState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _InProgress value)?  inProgress,TResult Function( _Completed value)?  completed,TResult Function( _Failed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _InProgress() when inProgress != null:
return inProgress(_that);case _Completed() when completed != null:
return completed(_that);case _Failed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _InProgress value)  inProgress,required TResult Function( _Completed value)  completed,required TResult Function( _Failed value)  failed,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _InProgress():
return inProgress(_that);case _Completed():
return completed(_that);case _Failed():
return failed(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _InProgress value)?  inProgress,TResult? Function( _Completed value)?  completed,TResult? Function( _Failed value)?  failed,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _InProgress() when inProgress != null:
return inProgress(_that);case _Completed() when completed != null:
return completed(_that);case _Failed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Map<String, dynamic>> questions,  int currentIndex,  int? selectedOption,  List<int> selectedArrangeIndices,  bool hasChecked,  bool isAnswerCorrect,  int hearts,  int correctCount)?  inProgress,TResult Function( int part,  int correctCount,  int totalQuestions)?  completed,TResult Function( int correctCount,  int totalQuestions)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _InProgress() when inProgress != null:
return inProgress(_that.questions,_that.currentIndex,_that.selectedOption,_that.selectedArrangeIndices,_that.hasChecked,_that.isAnswerCorrect,_that.hearts,_that.correctCount);case _Completed() when completed != null:
return completed(_that.part,_that.correctCount,_that.totalQuestions);case _Failed() when failed != null:
return failed(_that.correctCount,_that.totalQuestions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Map<String, dynamic>> questions,  int currentIndex,  int? selectedOption,  List<int> selectedArrangeIndices,  bool hasChecked,  bool isAnswerCorrect,  int hearts,  int correctCount)  inProgress,required TResult Function( int part,  int correctCount,  int totalQuestions)  completed,required TResult Function( int correctCount,  int totalQuestions)  failed,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _InProgress():
return inProgress(_that.questions,_that.currentIndex,_that.selectedOption,_that.selectedArrangeIndices,_that.hasChecked,_that.isAnswerCorrect,_that.hearts,_that.correctCount);case _Completed():
return completed(_that.part,_that.correctCount,_that.totalQuestions);case _Failed():
return failed(_that.correctCount,_that.totalQuestions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Map<String, dynamic>> questions,  int currentIndex,  int? selectedOption,  List<int> selectedArrangeIndices,  bool hasChecked,  bool isAnswerCorrect,  int hearts,  int correctCount)?  inProgress,TResult? Function( int part,  int correctCount,  int totalQuestions)?  completed,TResult? Function( int correctCount,  int totalQuestions)?  failed,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _InProgress() when inProgress != null:
return inProgress(_that.questions,_that.currentIndex,_that.selectedOption,_that.selectedArrangeIndices,_that.hasChecked,_that.isAnswerCorrect,_that.hearts,_that.correctCount);case _Completed() when completed != null:
return completed(_that.part,_that.correctCount,_that.totalQuestions);case _Failed() when failed != null:
return failed(_that.correctCount,_that.totalQuestions);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements QuizState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuizState.initial()';
}


}




/// @nodoc


class _Loading implements QuizState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuizState.loading()';
}


}




/// @nodoc


class _InProgress implements QuizState {
  const _InProgress({required final  List<Map<String, dynamic>> questions, required this.currentIndex, this.selectedOption, required final  List<int> selectedArrangeIndices, required this.hasChecked, required this.isAnswerCorrect, required this.hearts, required this.correctCount}): _questions = questions,_selectedArrangeIndices = selectedArrangeIndices;
  

 final  List<Map<String, dynamic>> _questions;
 List<Map<String, dynamic>> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}

 final  int currentIndex;
 final  int? selectedOption;
 final  List<int> _selectedArrangeIndices;
 List<int> get selectedArrangeIndices {
  if (_selectedArrangeIndices is EqualUnmodifiableListView) return _selectedArrangeIndices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedArrangeIndices);
}

 final  bool hasChecked;
 final  bool isAnswerCorrect;
 final  int hearts;
 final  int correctCount;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InProgressCopyWith<_InProgress> get copyWith => __$InProgressCopyWithImpl<_InProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InProgress&&const DeepCollectionEquality().equals(other._questions, _questions)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.selectedOption, selectedOption) || other.selectedOption == selectedOption)&&const DeepCollectionEquality().equals(other._selectedArrangeIndices, _selectedArrangeIndices)&&(identical(other.hasChecked, hasChecked) || other.hasChecked == hasChecked)&&(identical(other.isAnswerCorrect, isAnswerCorrect) || other.isAnswerCorrect == isAnswerCorrect)&&(identical(other.hearts, hearts) || other.hearts == hearts)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_questions),currentIndex,selectedOption,const DeepCollectionEquality().hash(_selectedArrangeIndices),hasChecked,isAnswerCorrect,hearts,correctCount);

@override
String toString() {
  return 'QuizState.inProgress(questions: $questions, currentIndex: $currentIndex, selectedOption: $selectedOption, selectedArrangeIndices: $selectedArrangeIndices, hasChecked: $hasChecked, isAnswerCorrect: $isAnswerCorrect, hearts: $hearts, correctCount: $correctCount)';
}


}

/// @nodoc
abstract mixin class _$InProgressCopyWith<$Res> implements $QuizStateCopyWith<$Res> {
  factory _$InProgressCopyWith(_InProgress value, $Res Function(_InProgress) _then) = __$InProgressCopyWithImpl;
@useResult
$Res call({
 List<Map<String, dynamic>> questions, int currentIndex, int? selectedOption, List<int> selectedArrangeIndices, bool hasChecked, bool isAnswerCorrect, int hearts, int correctCount
});




}
/// @nodoc
class __$InProgressCopyWithImpl<$Res>
    implements _$InProgressCopyWith<$Res> {
  __$InProgressCopyWithImpl(this._self, this._then);

  final _InProgress _self;
  final $Res Function(_InProgress) _then;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? questions = null,Object? currentIndex = null,Object? selectedOption = freezed,Object? selectedArrangeIndices = null,Object? hasChecked = null,Object? isAnswerCorrect = null,Object? hearts = null,Object? correctCount = null,}) {
  return _then(_InProgress(
questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,selectedOption: freezed == selectedOption ? _self.selectedOption : selectedOption // ignore: cast_nullable_to_non_nullable
as int?,selectedArrangeIndices: null == selectedArrangeIndices ? _self._selectedArrangeIndices : selectedArrangeIndices // ignore: cast_nullable_to_non_nullable
as List<int>,hasChecked: null == hasChecked ? _self.hasChecked : hasChecked // ignore: cast_nullable_to_non_nullable
as bool,isAnswerCorrect: null == isAnswerCorrect ? _self.isAnswerCorrect : isAnswerCorrect // ignore: cast_nullable_to_non_nullable
as bool,hearts: null == hearts ? _self.hearts : hearts // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _Completed implements QuizState {
  const _Completed({required this.part, required this.correctCount, required this.totalQuestions});
  

 final  int part;
 final  int correctCount;
 final  int totalQuestions;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompletedCopyWith<_Completed> get copyWith => __$CompletedCopyWithImpl<_Completed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Completed&&(identical(other.part, part) || other.part == part)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.totalQuestions, totalQuestions) || other.totalQuestions == totalQuestions));
}


@override
int get hashCode => Object.hash(runtimeType,part,correctCount,totalQuestions);

@override
String toString() {
  return 'QuizState.completed(part: $part, correctCount: $correctCount, totalQuestions: $totalQuestions)';
}


}

/// @nodoc
abstract mixin class _$CompletedCopyWith<$Res> implements $QuizStateCopyWith<$Res> {
  factory _$CompletedCopyWith(_Completed value, $Res Function(_Completed) _then) = __$CompletedCopyWithImpl;
@useResult
$Res call({
 int part, int correctCount, int totalQuestions
});




}
/// @nodoc
class __$CompletedCopyWithImpl<$Res>
    implements _$CompletedCopyWith<$Res> {
  __$CompletedCopyWithImpl(this._self, this._then);

  final _Completed _self;
  final $Res Function(_Completed) _then;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? part = null,Object? correctCount = null,Object? totalQuestions = null,}) {
  return _then(_Completed(
part: null == part ? _self.part : part // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,totalQuestions: null == totalQuestions ? _self.totalQuestions : totalQuestions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _Failed implements QuizState {
  const _Failed({required this.correctCount, required this.totalQuestions});
  

 final  int correctCount;
 final  int totalQuestions;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FailedCopyWith<_Failed> get copyWith => __$FailedCopyWithImpl<_Failed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Failed&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.totalQuestions, totalQuestions) || other.totalQuestions == totalQuestions));
}


@override
int get hashCode => Object.hash(runtimeType,correctCount,totalQuestions);

@override
String toString() {
  return 'QuizState.failed(correctCount: $correctCount, totalQuestions: $totalQuestions)';
}


}

/// @nodoc
abstract mixin class _$FailedCopyWith<$Res> implements $QuizStateCopyWith<$Res> {
  factory _$FailedCopyWith(_Failed value, $Res Function(_Failed) _then) = __$FailedCopyWithImpl;
@useResult
$Res call({
 int correctCount, int totalQuestions
});




}
/// @nodoc
class __$FailedCopyWithImpl<$Res>
    implements _$FailedCopyWith<$Res> {
  __$FailedCopyWithImpl(this._self, this._then);

  final _Failed _self;
  final $Res Function(_Failed) _then;

/// Create a copy of QuizState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? correctCount = null,Object? totalQuestions = null,}) {
  return _then(_Failed(
correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,totalQuestions: null == totalQuestions ? _self.totalQuestions : totalQuestions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
