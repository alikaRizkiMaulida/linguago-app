part of 'quiz_bloc.dart';

@freezed
class QuizState with _$QuizState {
  const factory QuizState.initial() = _Initial;
  const factory QuizState.loading() = _Loading;
  const factory QuizState.inProgress({
    required List<Map<String, dynamic>> questions,
    required int currentIndex,
    int? selectedOption,
    required List<int> selectedArrangeIndices,
    required bool hasChecked,
    required bool isAnswerCorrect,
    required int hearts,
    required int correctCount,
  }) = _InProgress;
  const factory QuizState.completed({
    required int part,
    required int correctCount,
    required int totalQuestions,
  }) = _Completed;
  const factory QuizState.failed({
    required int correctCount,
    required int totalQuestions,
  }) = _Failed;
}
