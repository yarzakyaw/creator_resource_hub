import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_services/auth/firebase_auth_service.dart';

/// Repository to handle authentication logic.
class AuthRepository {
  final FirebaseAuthService _authService;

  AuthRepository({required FirebaseAuthService authService})
    : _authService = authService;

  /// Sign in anonymously.
  Future<User?> signInAnonymously() => _authService.signInAnonymously();

  /// Sign in with email and password.
  Future<User?> signInWithEmail(String email, String password) =>
      _authService.signInWithEmail(email, password);

  /// Register with email and password.
  Future<User?> registerWithEmail(String email, String password) =>
      _authService.registerWithEmail(email, password);

  /// Sign in with Google.
  Future<User?> signInWithGoogle() => _authService.signInWithGoogle();

  /// Sign out the current user.
  Future<void> signOut() => _authService.signOut();

  /// Stream of authentication state changes.
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  /// Get the current user.
  User? get currentUser => _authService.currentUser;
}
