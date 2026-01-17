import 'package:flutter/material.dart';
import 'package:localization/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// A simple localization service that holds the current [Locale]
/// in a [ValueNotifier] so the app can listen and rebuild when it
/// changes at runtime. Persistence is handled with [SharedPreferences].
class LocalizationService {
  static const String _languageCodeKey = 'language_code';

  static const Locale english = Locale('en');
  static const Locale burmese = Locale('my');

  // Exposed notifier for apps to listen to locale changes.
  static final ValueNotifier<Locale> localeNotifier = ValueNotifier<Locale>(
    english,
  );

  /// Initialize the service and load any saved locale from disk.
  /// Call this before `runApp` so the initial locale is ready.
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageCodeKey) ?? 'en';
    localeNotifier.value = Locale(languageCode);
  }

  /// Change the current locale, persist it, and notify listeners.
  static Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, locale.languageCode);
    localeNotifier.value = locale;
  }

  /// Locale resolution callback used by MaterialApp.
  static Locale localeResolutionCallback(
    Locale? locale,
    Iterable<Locale> supportedLocales,
  ) {
    if (locale == null) {
      return supportedLocales.first;
    }
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }
    return supportedLocales.first;
  }

  static Iterable<Locale> get supportedLocales => [english, burmese];

  static List<LocalizationsDelegate<dynamic>> get localizationsDelegates => [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}
