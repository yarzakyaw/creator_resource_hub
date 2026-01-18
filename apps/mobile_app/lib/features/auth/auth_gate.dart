import 'package:creator_resource_hub_mobile/features/resources/presentation/resource_list_screen.dart';
import 'package:firebase_services/auth/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_screen.dart';

/// A widget that listens to the authentication state and decides which screen to show.
class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  bool _isSigningInAnonymously = false;

  @override
  void initState() {
    super.initState();
    // Trigger anonymous sign-in after the first frame if no user is authenticated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndSignInAnonymously();
    });
  }

  Future<void> _checkAndSignInAnonymously() async {
    final authRepository = ref.read(authRepositoryProvider);
    final currentUser = authRepository.currentUser;

    // If there's no current user and we haven't started signing in, sign in anonymously
    if (currentUser == null && !_isSigningInAnonymously) {
      setState(() {
        _isSigningInAnonymously = true;
      });

      try {
        await authRepository.signInAnonymously();
      } catch (e) {
        debugPrint('Error signing in anonymously: $e');
        // Reset the flag if sign-in fails
        if (mounted) {
          setState(() {
            _isSigningInAnonymously = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          // User is authenticated (including anonymous users).
          return ResourceListScreen();
        } else {
          // Show loading while signing in anonymously
          if (_isSigningInAnonymously) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          // If anonymous sign-in failed, show login screen
          return const LoginScreen();
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }
}
