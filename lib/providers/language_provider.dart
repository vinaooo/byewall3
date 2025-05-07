import 'package:byewall3/l10n/app_localizations.dart';
import 'package:byewall3/l10n/known_locations.dart';
import 'package:byewall3/providers/theme_provider.dart';
import 'package:byewall3/ui/components/dialog_title.dart';
import 'package:byewall3/ui/components/localized_text.dart';
import 'package:byewall3/ui/components/selection_box.dart';
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

    notifyListeners();
  }

  bool _isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
  }

  void setLocale(Locale locale) {
    _locale = locale;
    saveLanguage(locale); // Salva o idioma escolhido
    notifyListeners();
  }

  /// Exibe um diálogo para o usuário selecionar o idioma
  static void selectLanguage(
    BuildContext context,
    String Function(Locale locale) localeKey,
  ) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(top: 16, bottom: 30),
          backgroundColor:
              themeProvider.themeMode == ThemeMode.dark ||
                      (themeProvider.themeMode == ThemeMode.system &&
                          MediaQuery.of(context).platformBrightness ==
                              Brightness.dark)
                  ? HSLColor.fromColor(
                    Theme.of(context).colorScheme.surface,
                  ).withLightness(0.21).toColor()
                  : null,
          title: DialogTitle(
            context: context,
            icon: Icons.translate,
            title: 'select_language',
          ),

          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: AppLocalizations.supportedLocales.length,
              itemBuilder: (context, index) {
                final locale = AppLocalizations.supportedLocales[index];
                final key = localeKey(locale);
                final name = Locales.knownLocales[key] ?? key;
                final isSelected =
                    Provider.of<LanguageProvider>(context).locale == locale;
                final selectionColor = transparentIfSelected(
                  lp: Provider.of<LanguageProvider>(context),
                  locale: locale,
                );

                return Stack(
                  children: [
                    SelectionBox(
                      languageProvider: Provider.of<LanguageProvider>(context),
                      context: context,
                      locale: locale,
                    ),
                    InkWell(
                      focusColor: selectionColor,
                      hoverColor: selectionColor,
                      highlightColor: selectionColor,
                      child: ListTile(
                        hoverColor: selectionColor,
                        splashColor: selectionColor,
                        tileColor: selectionColor,
                        contentPadding: EdgeInsets.symmetric(horizontal: 50),
                        leading:
                            isSelected
                                ? Icon(
                                  Icons.check,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                )
                                : const SizedBox.shrink(), // Ícone vazio se não for selecionado
                        title: LocalizedText(
                          tKey: name,
                          style: TextStyle(
                            color:
                                isSelected
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : null,
                          ),
                        ),
                        onTap: () {
                          changeLanguage(context, locale);
                        },
                      ),
                    ),
                  ],
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

  static Color? transparentIfSelected({
    required LanguageProvider lp,
    required Locale locale,
  }) {
    return lp.locale == locale ? Colors.transparent : null;
  }
}
