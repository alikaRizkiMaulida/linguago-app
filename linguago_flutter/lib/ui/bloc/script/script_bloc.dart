import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:linguago_flutter/data/script/models/english_script_data.dart';
import 'package:linguago_flutter/data/script/models/script_category.dart' show HangulCategory;
import 'package:linguago_flutter/data/script/script_repository.dart';

part 'script_event.dart';
part 'script_state.dart';
part 'script_bloc.freezed.dart';

class ScriptBloc extends Bloc<ScriptEvent, ScriptState> {
  final ScriptRepository _repo;

  ScriptBloc({ScriptRepository? repo})
      : _repo = repo ?? ScriptRepository(),
        super(const ScriptState.initial()) {
    on<ScriptEvent>((event, emit) async {
      await event.map(
        started: (_) async {
          emit(const ScriptState.loading());
          emit(ScriptState.loaded(
            koreanCategories: _repo.getKoreanCategories(),
            englishCategories: _repo.getEnglishCategories(),
          ));
        },
      );
    });
  }
}
