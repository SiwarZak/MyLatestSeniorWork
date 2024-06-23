import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tejwal/providers/auth_provider.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthProvider authProvider;

  LoginCubit({required this.authProvider}) : super(LoginInitial());

  Future<void> signIn({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      await authProvider.signIn(
        email: email,
        password: password,
        onSuccess: () {
          emit(LoginSuccess());
        },
        onError: (error) {
          emit(LoginFailure(error));
        },
      );
    } catch (error) {
      emit(LoginFailure(error.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(LoginLoading());
    try {
      await authProvider.signInWithGoogle(
        onSuccess: () {
          emit(LoginSuccess());
        },
        onError: (error) {
          emit(LoginFailure(error));
        },
      );
    } catch (error) {
      emit(LoginFailure(error.toString()));
    }
  }
}
