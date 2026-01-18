import 'package:creator_resource_hub_admin/features/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_services/auth/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget to enforce admin authentication.
class AdminGuard extends ConsumerWidget {
  final Widget child;
  final List<String> allowlist;

  const AdminGuard({super.key, required this.child, required this.allowlist});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    debugPrint('Current user: ${FirebaseAuth.instance.currentUser}');

    if (user == null || user.isAnonymous) {
      return const LoginScreen();
    }

    if (!allowlist.contains(user.email)) {
      return const AccessDeniedScreen();
    }

    return child;
  }
}

/// A screen to display access denied message.
class AccessDeniedScreen extends StatelessWidget {
  const AccessDeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Access Denied')),
      body: const Center(
        child: Text('You do not have permission to access this page.'),
      ),
    );
  }
}
