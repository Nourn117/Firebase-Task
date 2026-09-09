import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/datasources/auth_remote_data_source.dart';
import 'data/datasources/user_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'domain/usecases/register_usecase.dart';
import 'firebase_options.dart';
import 'presentation/cubit/auth_cubit.dart';
import 'presentation/pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepositoryImpl(
      authRemoteDataSource: AuthRemoteDataSource(),
      userRemoteDataSource: UserRemoteDataSource(),
    );

    return BlocProvider(
      create: (_) => AuthCubit(
        loginUseCase: LoginUseCase(authRepository),
        registerUseCase: RegisterUseCase(authRepository),
        logoutUseCase: LogoutUseCase(authRepository),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Firebase Task',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}