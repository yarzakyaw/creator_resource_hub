import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_services/auth/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A screen for email and password registration.
class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.read(authRepositoryProvider);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                final password = passwordController.text;
                try {
                  final currentUser = authRepository.currentUser;
                  if (currentUser != null && currentUser.isAnonymous) {
                    // Link anonymous account to email/password.
                    await currentUser.linkWithCredential(
                      EmailAuthProvider.credential(
                        email: email,
                        password: password,
                      ),
                    );
                  } else {
                    // Register a new account.
                    await authRepository.registerWithEmail(email, password);
                  }
                  Navigator.pop(context); // Return to the previous screen.
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
