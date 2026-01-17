// FirebaseInitializer abstraction

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_services/firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FirebaseInitializer {
  /// Initializes Firebase based on the platform.
  static Future<void> initialize() async {
    if (kIsWeb) {
      // Web-specific Firebase initialization
      await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
    } else {
      // Mobile-specific Firebase initialization
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }
}
