import 'package:byewall3/l10n/app_localizations.dart';
import 'package:byewall3/ui/language_provider.dart';
import 'package:byewall3/ui/list_tiles.dart';
import 'package:byewall3/ui/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:byewall3/utils/settings_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsManager _settingsManager = SettingsManager();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Inicialize apenas variáveis que não dependem do BuildContext aqui
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Inicialize _pages aqui, pois depende do BuildContext
  //   _pages = <Widget>[
  //     Center(child: generalSettings(context)),
  //     Center(child: Text('Pesquisar', style: TextStyle(fontSize: 24))),
  //     Center(child: Text('Perfil', style: TextStyle(fontSize: 24))),
  //   ];
  // }

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
      bottomNavigationBar: NavigationBar(
        // selectedIconTheme: IconThemeData(
        //   color: Theme.of(context).colorScheme.primary,
        // ),
        // currentIndex: _selectedIndex,
        // onTap: _onItemTapped,
        // // selectedItemColor: Colors.blue,
        // // unselectedItemColor: Colors.grey,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.build_outlined),
            label: 'General',
          ),
          NavigationDestination(
            // icon: Icon(Icons.extension_outlined),
            icon: Icon(Icons.list_rounded),
            label: 'Services',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outlined),
            label: 'About',
          ),
        ],
      ),
      // body: _pages[_selectedIndex],
      body:
          <Widget>[
            generalSettings(context),
            Center(child: Text('Pesquisar', style: TextStyle(fontSize: 24))),
            Center(child: Text('Perfil', style: TextStyle(fontSize: 24))),
          ][_selectedIndex],
    );
  }

  CustomScrollView generalSettings(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          snap: true,
          floating: true,
          surfaceTintColor: Colors.transparent,
          expandedHeight: 120.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              AppLocalizations.of(context)?.translate('settings') ?? "Settings",
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
                      icon: Icons.arrow_drop_down,
                      switchEnable: false,
                      onPressed: () {
                        ThemeProvider.show(context);
                      },
                    );
                  },
                ),
                SizedBox(height: 2),
                SettingsTiles(
                  topLeft: 0,
                  topRight: 0,
                  bottomLeft: 0,
                  bottomRight: 0,
                  title: 'cor',
                  subtitle: 'cor',
                  icon: Icons.arrow_drop_down,
                  switchEnable: false,
                  onPressed: () {},
                ),
                SizedBox(height: 2),
                SettingsTiles(
                  topLeft: 0,
                  topRight: 0,
                  bottomLeft: 20,
                  bottomRight: 20,
                  title: 'Amoled',
                  subtitle: 'Use black background for AMOLED screens',
                  icon: null,
                  switchEnable: true,
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
                  bottomLeft: 20,
                  bottomRight: 20,
                  title:
                      AppLocalizations.of(context)?.translate('language') ??
                      "Language",
                  subtitle:
                      AppLocalizations.of(
                        context,
                      )?.translate('language_subtitle') ??
                      "Select your language",
                  icon: Icons.arrow_drop_down,
                  switchEnable: false,
                  onPressed: () {
                    LanguageProvider.selectLanguage(context, _localeKey);
                  },
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              Row(
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

              SettingsTiles(
                topLeft: 20,
                topRight: 20,
                bottomLeft: 0,
                bottomRight: 0,
                title: 'Export',
                subtitle: 'Export your settings (coming soon)',
                icon: Icons.download,
                switchEnable: false,
                onPressed: () {},
              ),
              SizedBox(height: 2),
              SettingsTiles(
                topLeft: 0,
                topRight: 0,
                bottomLeft: 20,
                bottomRight: 20,
                title: 'Reset',
                subtitle: 'Reset all settings to default',
                icon: Icons.restore,
                switchEnable: false,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Reset Settings'),
                        content: Text(
                          'Are you sure you want to reset all settings to default?\nThis action cannot be undone.\nThe app will close after this action.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              final navigator = Navigator.of(context);
                              await _settingsManager.clearAllKeys();
                              navigator.pop(); // Fecha o diálogo
                              _settingsManager.closeApp(); // Fecha o aplicativo
                            },
                            child: Text('OK'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Fecha o diálogo
                            },
                            child: Text('Cancel'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
