import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:linguago_flutter/data/datasource/auth_local_datasource.dart';
import 'package:linguago_flutter/data/datasource/auth_remote_datasource.dart';

part 'register_event.dart';
part 'register_state.dart';
part 'register_bloc.freezed.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(const RegisterState.initial()) {
    on<RegisterEvent>((event, emit) async {
      await event.map(
        started: (_) async {
          emit(const RegisterState.initial());
        },
        registerSubmitted: (e) async {
          emit(const RegisterState.loading());
          try {
            final result = await AuthRemoteDatasource().register(
              e.name,
              e.email,
              e.password,
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
                emit(RegisterState.error(errorMessage));
              },
              (r) async {
                await AuthLocalDatasource().saveAuthData(r);
                emit(const RegisterState.success());
              },
            );
          } catch (error) {
            emit(RegisterState.error(error.toString()));
          }
        },
      );
    });
  }
}

