import 'package:byewall3/l10n/app_localizations.dart';
import 'package:byewall3/l10n/known_locations.dart';
import 'package:byewall3/ui/language_provider.dart';
import 'package:byewall3/ui/list_tiles.dart';
import 'package:byewall3/ui/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  String _localeKey(Locale locale) {
    // Ex: Locale('en', 'US') => 'en_US'
    if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
      return '${locale.languageCode}_${locale.countryCode}';
    }
    return locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            surfaceTintColor: Colors.transparent,
            expandedHeight: 120.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                AppLocalizations.of(context)?.translate('settings') ??
                    "Settings",
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  SizedBox(
                    height: 20,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)?.translate('appearance') ??
                            "Appearance",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      String themeSubtitle = '';
                      switch (themeProvider.themeMode) {
                        case ThemeMode.system:
                          themeSubtitle =
                              AppLocalizations.of(
                                context,
                              )?.translate('theme_mode_system') ??
                              "System";
                        case ThemeMode.light:
                          themeSubtitle =
                              AppLocalizations.of(
                                context,
                              )?.translate('theme_mode_light') ??
                              'Light';
                        case ThemeMode.dark:
                          themeSubtitle =
                              AppLocalizations.of(
                                context,
                              )?.translate('theme_mode_dark') ??
                              'Dark';
                      }
                      return SettingsTiles(
                        topLeft: 20,
                        topRight: 20,
                        bottomLeft: 0,
                        bottomRight: 0,
                        title:
                            AppLocalizations.of(
                              context,
                            )?.translate('theme_mode') ??
                            "Theme Mode",
                        subtitle: themeSubtitle,
                        onPressed: () {
                          ThemeProvider.show(context);
                        },
                      );
                    },
                  ),
                  SizedBox(height: 5),
                  SettingsTiles(
                    topLeft: 0,
                    topRight: 0,
                    bottomLeft: 0,
                    bottomRight: 0,
                    title: 'cor',
                    subtitle: 'cor',
                    onPressed: () {},
                  ),
                  SizedBox(height: 5),
                  SettingsTiles(
                    topLeft: 0,
                    topRight: 0,
                    bottomLeft: 0,
                    bottomRight: 0,
                    title: 'Amoled',
                    subtitle: 'amoled',
                    onPressed: () {},
                  ),
                  SizedBox(height: 5),
                  SettingsTiles(
                    topLeft: 0,
                    topRight: 0,
                    bottomLeft: 0,
                    bottomRight: 0,
                    title: 'Ajuda',
                    subtitle: 'Ajuda e suporte',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SettingsTiles(
                    topLeft: 20,
                    topRight: 20,
                    bottomLeft: 0,
                    bottomRight: 0,
                    title:
                        AppLocalizations.of(context)?.translate('language') ??
                        "Language",
                    subtitle:
                        AppLocalizations.of(
                          context,
                        )?.translate('language_subtitle') ??
                        "Select your language",
                    onPressed: () {
                      LanguageProvider.selectLanguage(context, _localeKey);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
