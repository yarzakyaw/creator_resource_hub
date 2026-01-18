import 'package:firebase_services/auth/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'register_screen.dart';

/// A minimal login screen for email and Google authentication.
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.read(authRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: (value) =>
                  ref.read(emailProvider.notifier).state = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (value) =>
                  ref.read(passwordProvider.notifier).state = value,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final email = ref.read(emailProvider);
                final password = ref.read(passwordProvider);
                await authRepository.signInWithEmail(email, password);
              },
              child: const Text('Login with Email'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await authRepository.signInWithGoogle();
              },
              child: const Text('Login with Google'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text('Don\'t have an account? Register'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Providers for email and password state.
final emailProvider = StateProvider<String>((ref) => '');
final passwordProvider = StateProvider<String>((ref) => '');
