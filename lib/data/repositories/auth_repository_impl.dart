import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final UserRemoteDataSource userRemoteDataSource;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.userRemoteDataSource,
  });

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final firebaseUser = await authRemoteDataSource.login(
      email: email,
      password: password,
    );

    return userRemoteDataSource.getUser(firebaseUser.uid);
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String nickname,
    required String sportPreference,
  }) async {
    final firebaseUser = await authRemoteDataSource.register(
      email: email,
      password: password,
    );

    final userModel = UserModel(
      uid: firebaseUser.uid,
      email: email,
      nickname: nickname,
      sportPreference: sportPreference,
    );

    await userRemoteDataSource.createUser(userModel);
    return userModel;
  }

  @override
  Future<void> logout() {
    return authRemoteDataSource.logout();
  }
}