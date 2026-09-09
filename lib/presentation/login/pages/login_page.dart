import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../home/pages/home_page.dart';
import '../../register/pages/register_page.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

class LoginPage extends StatefulWidget {
  final AuthRepository repository;

  const LoginPage({super.key, required this.repository});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final LoginCubit _loginCubit;

  @override
  void initState() {
    super.initState();
    _loginCubit = LoginCubit(LoginUseCase(widget.repository));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _loginCubit.close();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    _loginCubit.login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _loginCubit,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state.status == LoginStatus.success && state.user != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomePage(
                          user: state.user!,
                          repository: widget.repository,
                        ),
                      ),
                    );
                  } else if (state.status == LoginStatus.error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage ?? 'Login failed.')),
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading = state.status == LoginStatus.loading;

                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Welcome Back 👋',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        const Text('Login to your account',
                            textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              labelText: 'Email', border: OutlineInputBorder()),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) return 'Please enter a valid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Password', border: OutlineInputBorder()),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _login,
                            child: isLoading
                                ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2))
                                : const Text('Login', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RegisterPage(repository: widget.repository),
                              ),
                            );
                          },
                          child: const Text("Don't have an account? Register"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}