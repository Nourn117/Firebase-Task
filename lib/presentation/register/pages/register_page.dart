import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/usecases/register_usecase.dart';
import '../../home/pages/home_page.dart';
import '../../login/pages/login_page.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';

class RegisterPage extends StatefulWidget {
  final AuthRepository repository;

  const RegisterPage({super.key, required this.repository});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final RegisterCubit _registerCubit;

  String? _selectedSport;

  final List<String> _sports = ['Football', 'Basketball', 'Tennis', 'Swimming', 'Running'];

  @override
  void initState() {
    super.initState();
    _registerCubit = RegisterCubit(RegisterUseCase(widget.repository));
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _registerCubit.close();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    _registerCubit.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      nickname: _nicknameController.text.trim(),
      sportPreference: _selectedSport!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _registerCubit,
      child: Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: BlocConsumer<RegisterCubit, RegisterState>(
              listener: (context, state) {
                if (state.status == RegisterStatus.success && state.user != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomePage(
                        user: state.user!,
                        repository: widget.repository,
                      ),
                    ),
                  );
                } else if (state.status == RegisterStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage ?? 'Registration failed.')),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state.status == RegisterStatus.loading;

                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      const Text('Create Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _nicknameController,
                        decoration: const InputDecoration(
                            labelText: 'Nickname', border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your nickname';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
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
                          if (value.length < 6) return 'Password must be at least 6 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password', border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedSport,
                        decoration: const InputDecoration(
                            labelText: 'Sport Preference', border: OutlineInputBorder()),
                        items: _sports
                            .map((sport) => DropdownMenuItem<String>(value: sport, child: Text(sport)))
                            .toList(),
                        onChanged: (value) => setState(() => _selectedSport = value),
                        validator: (value) => value == null ? 'Please select a sport' : null,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _register,
                          child: isLoading
                              ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2))
                              : const Text('Register', style: TextStyle(fontSize: 16)),
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
                              builder: (_) => LoginPage(repository: widget.repository),
                            ),
                          );
                        },
                        child: const Text('Already have an account? Login'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}