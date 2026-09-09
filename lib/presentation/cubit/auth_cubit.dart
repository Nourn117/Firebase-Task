import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
  }) : super(const AuthState());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await loginUseCase(email: email, password: password);
      emit(state.copyWith(status: AuthStatus.success, user: user));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String nickname,
    required String sportPreference,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await registerUseCase(
        email: email,
        password: password,
        nickname: nickname,
        sportPreference: sportPreference,
      );
      emit(state.copyWith(status: AuthStatus.success, user: user));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<void> logout() async {
    await logoutUseCase();
    emit(const AuthState(status: AuthStatus.loggedOut));
  }
}