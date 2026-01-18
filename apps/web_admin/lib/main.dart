// Placeholder main.dart for the web admin app

import 'package:firebase_services/firebase_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization_service.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializer.initialize();
  await LocalizationService.init();
  runApp(const ProviderScope(child: App()));
}
