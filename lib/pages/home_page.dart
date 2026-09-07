import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  final String nickname;
  final String sportPreference;

  const HomePage({
    super.key,
    required this.nickname,
    required this.sportPreference,
  });

  Future<void> _logout(BuildContext context) async {
    await AuthService().logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _logout(context),
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
              const Icon(
                Icons.sports,
                size: 80,
                color: Colors.deepPurple,
              ),

              const SizedBox(height: 24),

              Text(
                'Hello, $nickname 👋',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Your sport preference:',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                sportPreference,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),

              const SizedBox(height: 40),

              ElevatedButton.icon(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
