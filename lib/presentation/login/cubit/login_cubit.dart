import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(const LoginState());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      final user = await loginUseCase(email: email, password: password);
      emit(state.copyWith(status: LoginStatus.success, user: user));
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }
}