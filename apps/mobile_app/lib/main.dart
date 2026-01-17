// Placeholder main.dart for the mobile app

import 'package:firebase_services/firebase_initializer.dart';
import 'package:flutter/material.dart';
import 'package:localization/l10n/generated/app_localizations.dart';
import 'package:localization/localization_service.dart';

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
    // Use ValueListenableBuilder to rebuild MaterialApp when the locale changes.
    return ValueListenableBuilder<Locale>(
      valueListenable: LocalizationService.localeNotifier,
      builder: (context, locale, _) {
        return MaterialApp(
          title: 'Creator Resource Hub',
          locale: locale,
          supportedLocales: LocalizationService.supportedLocales,
          localizationsDelegates: LocalizationService.localizationsDelegates,
          localeResolutionCallback:
              LocalizationService.localeResolutionCallback,
          home: Builder(builder: (context) => const LanguageToggleScreen()),
        );
      },
    );
  }
}

class LanguageToggleScreen extends StatefulWidget {
  const LanguageToggleScreen({super.key});

  @override
  _LanguageToggleScreenState createState() => _LanguageToggleScreenState();
}

class _LanguageToggleScreenState extends State<LanguageToggleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.appTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.welcomeMessage),
            ElevatedButton(
              onPressed: () =>
                  LocalizationService.setLocale(LocalizationService.english),
              child: Text(AppLocalizations.of(context)!.english),
            ),
            ElevatedButton(
              onPressed: () =>
                  LocalizationService.setLocale(LocalizationService.burmese),
              child: Text(AppLocalizations.of(context)!.myanmar),
            ),
          ],
        ),
      ),
    );
  }
}
