import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/register_usecase.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterCubit(this.registerUseCase) : super(const RegisterState());

  Future<void> register({
    required String email,
    required String password,
    required String nickname,
    required String sportPreference,
  }) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    try {
      final user = await registerUseCase(
        email: email,
        password: password,
        nickname: nickname,
        sportPreference: sportPreference,
      );
      emit(state.copyWith(status: RegisterStatus.success, user: user));
    } catch (e) {
      emit(state.copyWith(
        status: RegisterStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }
}