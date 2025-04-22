import 'package:byewall3/l10n/app_localizations.dart';
import 'package:byewall3/l10n/known_locations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en', 'US'); // Idioma padrão

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners(); // Notifica os ouvintes sobre a mudança
  }

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
                  subtitle: Text(key),
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
