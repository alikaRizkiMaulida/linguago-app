part of 'quiz_bloc.dart';

@freezed
class QuizEvent with _$QuizEvent {
  const factory QuizEvent.started({required int part}) = _Started;
  const factory QuizEvent.optionTapped({required int index}) = _OptionTapped;
  const factory QuizEvent.letterTapped({required int index}) = _LetterTapped;
  const factory QuizEvent.checkAnswer() = _CheckAnswer;
  const factory QuizEvent.nextQuestion() = _NextQuestion;
  const factory QuizEvent.resetQuiz() = _ResetQuiz;
}
