import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/usecases/logout_usecase.dart';
import '../../login/pages/login_page.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HomePage extends StatefulWidget {
  final UserEntity user;
  final AuthRepository repository;

  const HomePage({super.key, required this.user, required this.repository});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();
    _homeCubit = HomeCubit(
      user: widget.user,
      logoutUseCase: LogoutUseCase(widget.repository),
    );
  }

  @override
  void dispose() {
    _homeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeCubit,
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.status == HomeStatus.loggedOut) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => LoginPage(repository: widget.repository),
              ),
                  (route) => false,
            );
          }
        },
        builder: (context, state) {
          final isLoggingOut = state.status == HomeStatus.loggingOut;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: isLoggingOut ? null : () => _homeCubit.logout(),
                  icon: const Icon(Icons.logout),
                  tooltip: 'Logout',
                ),
              ],
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.sports, size: 80, color: Colors.deepPurple),
                    const SizedBox(height: 24),
                    Text('Hello, ${state.user.nickname} 👋',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    const Text('Your sport preference:', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text(
                      state.user.sportPreference,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w600, color: Colors.deepPurple),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      onPressed: isLoggingOut ? null : () => _homeCubit.logout(),
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}