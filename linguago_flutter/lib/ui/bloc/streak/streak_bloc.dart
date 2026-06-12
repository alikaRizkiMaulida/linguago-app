import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:linguago_flutter/data/streak/models/streak_task.dart';
import 'package:linguago_flutter/data/streak/streak_repository.dart';

part 'streak_event.dart';
part 'streak_state.dart';
part 'streak_bloc.freezed.dart';

class StreakBloc extends Bloc<StreakEvent, StreakState> {
  final StreakRepository _repo;

  StreakBloc({StreakRepository? repo})
      : _repo = repo ?? StreakRepository(),
        super(const StreakState.initial()) {
    on<StreakEvent>((event, emit) async {
      await event.map(
        started: (_) async {
          emit(const StreakState.loading());
          emit(StreakState.loaded(
            streakCount: _repo.getStreakCount(),
            progress: _repo.getProgress(),
            activeDay: StreakRepository.activeDay,
            tasks: _repo.getDailyTasks(),
          ));
        },
      );
    });
  }
}
