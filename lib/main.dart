import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'data/datasources/auth_remote_data_source.dart';
import 'data/datasources/user_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'firebase_options.dart';
import 'presentation/login/pages/login_page.dart';

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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Task',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(repository: authRepository),
    );
  }
}