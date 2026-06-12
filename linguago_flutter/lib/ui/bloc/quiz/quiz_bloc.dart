import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:linguago_flutter/data/quiz/quiz_data.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';
part 'quiz_bloc.freezed.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(const QuizState.initial()) {
    on<QuizEvent>((event, emit) async {
      await event.map(
        started: (e) async {
          emit(const QuizState.loading());
          final questions = getQuizQuestions(e.part);
          emit(QuizState.inProgress(
            questions: questions,
            currentIndex: 0,
            selectedOption: null,
            selectedArrangeIndices: const [],
            hasChecked: false,
            isAnswerCorrect: false,
            hearts: 5,
            correctCount: 0,
          ));
        },
        optionTapped: (e) {
          state.map(
            initial: (_) {},
            loading: (_) {},
            inProgress: (s) {
              if (s.hasChecked) return;
              emit(s.copyWith(selectedOption: e.index));
            },
            completed: (_) {},
            failed: (_) {},
          );
        },
        letterTapped: (e) {
          state.map(
            initial: (_) {},
            loading: (_) {},
            inProgress: (s) {
              if (s.hasChecked) return;
              final indices = List<int>.from(s.selectedArrangeIndices);
              if (indices.contains(e.index)) {
                indices.remove(e.index);
              } else {
                indices.add(e.index);
              }
              emit(s.copyWith(selectedArrangeIndices: indices));
            },
            completed: (_) {},
            failed: (_) {},
          );
        },
        checkAnswer: (_) {
          state.map(
            initial: (_) {},
            loading: (_) {},
            inProgress: (s) {
              if (s.hasChecked) return;
              final qData = s.questions[s.currentIndex];
              final isArrange = qData['type'] == 'arrange';

              bool isCorrect = false;
              if (isArrange) {
                if (s.selectedArrangeIndices.isEmpty) return;
                final letters = s.selectedArrangeIndices
                    .map((idx) => qData['letters'][idx] as String)
                    .toList();
                final constructed = _combineLetters(letters);
                isCorrect = constructed == qData['correctAnswer'];
              } else {
                if (s.selectedOption == null) return;
                isCorrect = s.selectedOption == (qData['correct'] as int);
              }

              emit(s.copyWith(
                hasChecked: true,
                isAnswerCorrect: isCorrect,
                correctCount: isCorrect ? s.correctCount + 1 : s.correctCount,
                hearts: isCorrect ? s.hearts : math.max(0, s.hearts - 1),
              ));
            },
            completed: (_) {},
            failed: (_) {},
          );
        },
        nextQuestion: (_) {
          state.map(
            initial: (_) {},
            loading: (_) {},
            inProgress: (s) {
              if (s.hearts == 0) {
                emit(QuizState.failed(
                  correctCount: s.correctCount,
                  totalQuestions: s.questions.length,
                ));
                return;
              }

              if (s.currentIndex < s.questions.length - 1) {
                emit(s.copyWith(
                  currentIndex: s.currentIndex + 1,
                  selectedOption: null,
                  selectedArrangeIndices: const [],
                  hasChecked: false,
                ));
              } else {
                emit(QuizState.completed(
                  part: 0,
                  correctCount: s.correctCount,
                  totalQuestions: s.questions.length,
                ));
              }
            },
            completed: (_) {},
            failed: (_) {},
          );
        },
        resetQuiz: (_) {
          state.map(
            initial: (_) {},
            loading: (_) {},
            inProgress: (s) {
              emit(s.copyWith(
                currentIndex: 0,
                selectedOption: null,
                selectedArrangeIndices: const [],
                hasChecked: false,
                isAnswerCorrect: false,
                hearts: 5,
                correctCount: 0,
              ));
            },
            completed: (_) {},
            failed: (_) {},
          );
        },
      );
    });
  }

  String _combineLetters(List<String> letters) {
    if (letters.isEmpty) return '';
    final temp = letters.join('');

    if (temp == 'ㅎㅏㄷㅏ') return '하다';
    if (temp == 'ㄴㅏㄹㅏ') return '나라';
    if (temp == 'ㅇㅜㄹㅣ') return '우리';
    if (temp == 'ㅎㅏㄴ') return '한';
    if (temp == 'ㅎㅏㄱ') return '학';
    if (temp == 'ㅎㅏ') return '하';
    if (temp == 'ㅎ') return 'ㅎ';
    if (temp == 'ㄴㅏㄴ') return '난';
    if (temp == 'ㄴㅏㄱ') return '낙';
    if (temp == 'ㄴㅏ') return '나';
    if (temp == 'ㄴ') return 'ㄴ';
    if (temp == 'ㄱㅏㄴ') return '간';
    if (temp == 'ㄱㅏㄱ') return '각';
    if (temp == 'ㄱㅏ') return '가';
    if (temp == 'ㄱ') return 'ㄱ';

    if (letters.length == 1) return letters[0];
    if (letters.length == 2) {
      final c = letters[0];
      final v = letters[1];
      if (c == 'ㅎ' && v == 'ㅏ') return '하';
      if (c == 'ㄴ' && v == 'ㅏ') return '나';
      if (c == 'ㄱ' && v == 'ㅏ') return '가';
      return letters.join('');
    }
    if (letters.length >= 3) {
      final c = letters[0];
      final v = letters[1];
      final f = letters[2];
      if (c == 'ㅎ' && v == 'ㅏ') {
        if (f == 'ㄴ') return '한';
        if (f == 'ㄱ') return '학';
        return '하$f';
      }
      if (c == 'ㄴ' && v == 'ㅏ') {
        if (f == 'ㄴ') return '난';
        if (f == 'ㄱ') return '낙';
        return '나$f';
      }
      if (c == 'ㄱ' && v == 'ㅏ') {
        if (f == 'ㄴ') return '간';
        if (f == 'ㄱ') return '각';
        return '가$f';
      }
      return letters.join('');
    }
    return temp;
  }
}
