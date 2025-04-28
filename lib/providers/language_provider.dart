import 'package:byewall3/l10n/app_localizations.dart';
import 'package:byewall3/l10n/known_locations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en', 'US'); // Idioma padrão

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
    // Recupera o idioma salvo ou usa o padrão 'en_US'
    final savedLanguage = prefs.getString('appLanguage') ?? 'en_US';
    final parts = savedLanguage.split('_');

    if (parts.length == 2) {
      // Caso o idioma tenha código de idioma e país (ex.: en_US)
      _locale = Locale(parts[0], parts[1]);
    } else if (parts.length == 1) {
      // Caso o idioma tenha apenas o código de idioma (ex.: pl)
      _locale = Locale(parts[0], '');
    } else {
      // Caso inesperado, define o idioma padrão
      _locale = const Locale('en', 'US');
    }

    notifyListeners(); // Notifica os widgets que dependem desse estado
  }

  /// Atualiza o idioma atual e salva no SharedPreferences
  void setLocale(Locale locale) {
    _locale = locale;
    saveLanguage(locale); // Salva o idioma escolhido
    notifyListeners(); // Notifica os ouvintes sobre a mudança
  }

  // @override
  // bool isSupported(Locale locale) {
  //   return AppLocalizations.supportedLocales.any(
  //     (supportedLocale) =>
  //         supportedLocale.languageCode == locale.languageCode &&
  //         (supportedLocale.countryCode == locale.countryCode ||
  //             supportedLocale.countryCode == null ||
  //             locale.countryCode == null),
  //   );
  // }

  /// Exibe um diálogo para o usuário selecionar o idioma
  static void selectLanguage(
    BuildContext context,
    String Function(Locale locale) localeKey,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Language'),
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
                        Provider.of<LanguageProvider>(
                          context,
                          listen: false,
                        ).setLocale(selectedLocale);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Language changed to $name')),
                        );
                      }
                    },
                  ),
                  title: Text(name),
                  onTap: () {
                    Provider.of<LanguageProvider>(
                      context,
                      listen: false,
                    ).setLocale(locale);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Language changed to $name')),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
