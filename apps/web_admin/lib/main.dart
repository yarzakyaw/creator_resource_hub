// Placeholder main.dart for the web admin app

import 'package:firebase_services/firebase_initializer.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization_service.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializer.initialize();
  await LocalizationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: LocalizationService.localeNotifier,
      builder: (context, locale, _) {
        return MaterialApp(
          title: 'Creator Resource Hub Admin',
          locale: locale,
          supportedLocales: LocalizationService.supportedLocales,
          localizationsDelegates: LocalizationService.localizationsDelegates,
          localeResolutionCallback:
              LocalizationService.localeResolutionCallback,
          home: Scaffold(
            appBar: AppBar(title: const Text('Creator Resource Hub Admin')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Intl.message('Welcome to the Creator Resource Hub Admin!'),
                  ),
                  ElevatedButton(
                    onPressed: () => LocalizationService.setLocale(
                      LocalizationService.english,
                    ),
                    child: Text(Intl.message('English')),
                  ),
                  ElevatedButton(
                    onPressed: () => LocalizationService.setLocale(
                      LocalizationService.burmese,
                    ),
                    child: Text(Intl.message('Burmese')),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
