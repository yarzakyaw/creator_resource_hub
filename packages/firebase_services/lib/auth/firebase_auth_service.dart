import 'package:firebase_auth/firebase_auth.dart';

/// A service to handle Firebase Authentication logic.
class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Sign in anonymously.
  Future<User?> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user;
  }

  /// Sign in with email and password.
  Future<User?> signInWithEmail(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  /// Register with email and password.
  Future<User?> registerWithEmail(String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  /// Sign in with Google.
  Future<User?> signInWithGoogle() async {
    // TODO: Implement Google Sign-In logic.
    throw UnimplementedError('Google Sign-In not implemented yet.');
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Stream of authentication state changes.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Get the current user.
  User? get currentUser => _firebaseAuth.currentUser;
}
