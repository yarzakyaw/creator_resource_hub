import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_services/auth/firebase_auth_service.dart';
import 'auth_repository.dart';

/// Provider for FirebaseAuthService.
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

/// Provider for AuthRepository.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.read(firebaseAuthServiceProvider);
  return AuthRepository(authService: authService);
});

/// Stream provider for authentication state changes.
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return authRepository.authStateChanges;
});

/// Provider for the current user.
final currentUserProvider = Provider<User?>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return authRepository.currentUser;
});
