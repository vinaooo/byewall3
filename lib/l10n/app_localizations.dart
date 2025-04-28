import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  // Fallback estático para inglês
  static Map<String, String>? _fallbackStrings;

  // Carrega o fallback apenas uma vez
  static Future<void> loadFallback() async {
    if (_fallbackStrings != null) return;
    try {
      String jsonString = await rootBundle.loadString('lang/en_US.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _fallbackStrings = jsonMap.map(
        (key, value) => MapEntry(key, value.toString()),
      );
    } catch (e) {
      _fallbackStrings = {};
    }
  }

  Future<bool> load() async {
    // Carrega o fallback EN uma vez
    await AppLocalizations.loadFallback();

    // Tenta carregar com countryCode, depois sem
    String pathWithCountry =
        locale.countryCode != null && locale.countryCode!.isNotEmpty
            ? 'lang/${locale.languageCode}_${locale.countryCode}.json'
            : '';
    String pathWithoutCountry = 'lang/${locale.languageCode}.json';

    Map<String, dynamic> jsonMap = {};
    try {
      if (pathWithCountry.isNotEmpty) {
        String jsonString = await rootBundle.loadString(pathWithCountry);
        jsonMap = json.decode(jsonString);
      } else {
        throw Exception('No country code');
      }
    } catch (_) {
      try {
        String jsonString = await rootBundle.loadString(pathWithoutCountry);
        jsonMap = json.decode(jsonString);
      } catch (_) {
        jsonMap = {};
      }
    }

    _localizedStrings = jsonMap.map(
      (key, value) => MapEntry(key, value.toString()),
    );

    return true;
  }

  String translate(String key) {
    String? result = _localizedStrings[key];
    if (result == null && _fallbackStrings != null) {
      result = _fallbackStrings![key];
    }
    // Retorne a chave como fallback para facilitar debug
    return result ?? key;
  }

  /// Lista de idiomas suportados
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en', 'US'),
    Locale('es', 'ES'),
    Locale('pt', 'BR'),
    Locale('pl'),
  ];
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Suporte para qualquer variante do idioma suportado
    return AppLocalizations.supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
