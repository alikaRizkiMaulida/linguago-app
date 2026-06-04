import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:linguago_flutter/data/datasource/auth_local_datasource.dart';
import 'package:linguago_flutter/data/datasource/auth_remote_datasource.dart';
import 'package:linguago_flutter/data/model/request/login_request_model.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState.initial()) {
    on<LoginEvent>((event, emit) async {
      await event.map(
        started: (_) async {
          emit(const LoginState.initial());
        },
        loginSubmitted: (e) async {
          emit(const LoginState.loading());
          try {
            final result = await AuthRemoteDatasource().login(
              LoginRequestModel(email: e.email, password: e.password),
            );
            await result.fold(
              (l) async {
                String errorMessage = l;
                try {
                  final Map<String, dynamic> errorMap = jsonDecode(l);
                  if (errorMap.containsKey('message')) {
                    final msg = errorMap['message'];
                    if (msg is List) {
                      errorMessage = msg.first.toString();
                    } else {
                      errorMessage = msg.toString();
                    }
                  }
                } catch (_) {}
                emit(LoginState.error(errorMessage));
              },
              (r) async {
                await AuthLocalDatasource().saveAuthData(r);
                emit(const LoginState.success());
              },
            );
          } catch (error) {
            emit(LoginState.error(error.toString()));
          }
        },
      );
    });
  }
}

