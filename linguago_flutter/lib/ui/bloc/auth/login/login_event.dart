part of 'login_bloc.dart';

@freezed
class LoginEvent with _$LoginEvent {
  const factory LoginEvent.started() = _Started;
  const factory LoginEvent.loginSubmitted({
    required String email,
    required String password,
  }) = _LoginSubmitted;
}