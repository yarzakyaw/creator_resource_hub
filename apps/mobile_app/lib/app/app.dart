import '../features/auth/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization_service.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: ValueListenableBuilder<Locale>(
        valueListenable: LocalizationService.localeNotifier,
        builder: (context, locale, _) {
          return MaterialApp(
            title: 'Creator Resource Hub',
            locale: locale,
            supportedLocales: LocalizationService.supportedLocales,
            localizationsDelegates: LocalizationService.localizationsDelegates,
            localeResolutionCallback:
                LocalizationService.localeResolutionCallback,
            theme: ThemeData.light(useMaterial3: true),
            darkTheme: ThemeData.dark(useMaterial3: true),
            themeMode: ThemeMode.system,
            home: AuthGate(),
          );
        },
      ),
    );
  }
}
