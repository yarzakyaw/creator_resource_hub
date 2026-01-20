import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      // Initialize with serverClientId (required for Android)
      await googleSignIn.initialize(
        clientId: null, // ignore on mobile
        serverClientId:
            '816087388737-4msa9fu9i6u8guv8ciu40gna9j1ulukj.apps.googleusercontent.com',
      );

      // Trigger authentication
      final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();
      if (googleUser == null) return null; // user cancelled

      // Get tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.idToken == null) {
        throw FirebaseAuthException(
          code: 'missing-id-token',
          message: 'Google ID token was null',
        );
      }

      // Sign in to Firebase
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      return userCredential.user;
    } catch (e, stack) {
      debugPrint('Google Sign-In failed: $e');
      debugPrint('$stack');
      return null;
    }
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
