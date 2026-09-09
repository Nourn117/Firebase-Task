import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/logout_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
final LogoutUseCase logoutUseCase;

HomeCubit({
required UserEntity user,
required this.logoutUseCase,
}) : super(HomeState(user: user));

Future<void> logout() async {
emit(state.copyWith(status: HomeStatus.loggingOut));
await logoutUseCase();
emit(state.copyWith(status: HomeStatus.loggedOut));
}
}