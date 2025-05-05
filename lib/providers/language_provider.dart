import 'package:byewall3/l10n/app_localizations.dart';
import 'package:byewall3/l10n/known_locations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en', 'US'); // Fica como fallback

  Locale get locale => _locale;

  /// Salva o idioma escolhido no SharedPreferences
  Future<void> saveLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    // Salvamos o idioma no formato "en_US" (código do idioma e região)
    await prefs.setString(
      'appLanguage',
      '${locale.languageCode}_${locale.countryCode}',
    );
  }

  /// Carrega o idioma salvo no SharedPreferences e aplica no app
  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('appLanguage');

    if (savedLanguage == null) {
      // Pega a localidade do sistema
      final systemLocale =
          WidgetsBinding.instance.platformDispatcher.locales.first;
      // Se suportado, usa o sistema; caso contrário, fallback para inglês
      if (_isSupported(systemLocale)) {
        _locale = systemLocale;
      } else {
        _locale = const Locale('en', 'US');
      }
    } else {
      final parts = savedLanguage.split('_');
      if (parts.length == 2) {
        _locale = Locale(parts[0], parts[1]);
      } else if (parts.length == 1) {
        _locale = Locale(parts[0], '');
      } else {
        _locale = const Locale('en', 'US');
      }
    }

    notifyListeners(); // Notifica os widgets que dependem desse estado
  }

  bool _isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
  }

  /// Atualiza o idioma atual e salva no SharedPreferences
  void setLocale(Locale locale) {
    _locale = locale;
    saveLanguage(locale); // Salva o idioma escolhido
    notifyListeners(); // Notifica os ouvintes sobre a mudança
  }

  /// Exibe um diálogo para o usuário selecionar o idioma
  static void selectLanguage(
    BuildContext context,
    String Function(Locale locale) localeKey,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.translate('select_language'),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: AppLocalizations.supportedLocales.length,
              itemBuilder: (context, index) {
                final locale = AppLocalizations.supportedLocales[index];
                final key = localeKey(locale);
                final name = Locales.knownLocales[key] ?? key;
                return ListTile(
                  leading: Radio<Locale>(
                    value: locale,
                    groupValue: Provider.of<LanguageProvider>(context).locale,
                    onChanged: (Locale? selectedLocale) {
                      if (selectedLocale != null) {
                        changeLanguage(context, selectedLocale);
                      }
                    },
                  ),
                  title: Text(name),
                  onTap: () {
                    changeLanguage(context, locale);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  static void changeLanguage(BuildContext context, Locale selectedLocale) {
    Provider.of<LanguageProvider>(
      context,
      listen: false,
    ).setLocale(selectedLocale);
    Navigator.pop(context);
  }
}
