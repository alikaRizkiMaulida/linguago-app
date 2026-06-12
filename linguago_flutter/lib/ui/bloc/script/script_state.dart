part of 'script_bloc.dart';

@freezed
class ScriptState with _$ScriptState {
  const factory ScriptState.initial() = _Initial;
  const factory ScriptState.loading() = _Loading;
  const factory ScriptState.loaded({
    required List<HangulCategory> koreanCategories,
    required List<EnglishScriptCategory> englishCategories,
  }) = _Loaded;
}
