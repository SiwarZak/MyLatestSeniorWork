import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tejwal/providers/auth_provider.dart';
import 'package:meta/meta.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthProvider authProvider;

  SignupCubit({required this.authProvider}) : super(SignupInitial());

  Future<void> signUp({required String fullName, required String email, required String password}) async {
    emit(SignupLoading());
    try {
      await authProvider.signUp(
        fullName: fullName,
        email: email,
        password: password,
        onSuccess: () {
          emit(SignupSuccess());
        },
        onError: (error) {
          emit(SignupFailure(error));
        },
      );
    } catch (error) {
      emit(SignupFailure(error.toString()));
    }
  }
}
