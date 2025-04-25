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
  static const double minTitlePadding = 8.0;
  static const double maxTitlePadding = 50.0;
  static const double maxFontSize = 48.0;
  @override
  void initState() {
    super.initState();
    // Inicialize apenas variáveis que não dependem do BuildContext aqui
  }

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
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.build),
            icon: Icon(Icons.build_outlined),
            label: 'General',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.list_outlined),
            icon: Icon(Icons.list_rounded),
            label: 'Services',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.info),
            icon: Icon(Icons.info_outlined),
            label: 'About',
          ),
        ],
      ),
      // body: _pages[_selectedIndex],
      body:
          <Widget>[
            generalSettings(context),
            serviceSettings(),
            aboutSettings(),
          ][_selectedIndex],
    );
  }

  CustomScrollView aboutSettings() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          surfaceTintColor: Colors.transparent,
          expandedHeight: 160,
          pinned: true,
          snap: true,
          floating: true,
          flexibleSpace: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double minExtent =
                  kToolbarHeight + MediaQuery.of(context).padding.top;
              final double maxExtent = 160.0;
              final double t = ((constraints.maxHeight - minExtent) /
                      (maxExtent - minExtent))
                  .clamp(0.0, 1.0);

              // Padding: da esquerda para a direita
              final double horizontalPadding =
                  maxTitlePadding - (maxTitlePadding - minTitlePadding) * t;

              // Tamanho da fonte: maior expandido, menor colapsado
              final double defaultFontSize =
                  Theme.of(context).textTheme.titleLarge?.fontSize ?? 16.0;
              final double fontSize =
                  defaultFontSize + (maxFontSize - defaultFontSize) * t;

              return Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    left: horizontalPadding,
                    bottom: 12,
                    child: Text(
                      AppLocalizations.of(context)?.translate('about') ??
                          "About",
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((
            BuildContext context,
            int index,
          ) {
            return SizedBox(
              height: 100.0,
              child: Center(
                child: Text('$index', textScaler: const TextScaler.linear(5)),
              ),
            );
          }, childCount: 20),
        ),
      ],
    );
  }

  CustomScrollView serviceSettings() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          snap: true,
          floating: true,
          surfaceTintColor: Colors.transparent,
          expandedHeight: 120.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              AppLocalizations.of(context)?.translate('services') ?? "Services",
            ),
          ),
        ),
      ],
    );
  }

  CustomScrollView generalSettings(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          surfaceTintColor: Colors.transparent,
          toolbarHeight: 65,
          expandedHeight: 200,
          pinned: true,
          snap: true,
          floating: true,
          flexibleSpace: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double minExtent =
                  kToolbarHeight + MediaQuery.of(context).padding.top;
              final double maxExtent = 200.0;
              final double t = ((constraints.maxHeight - minExtent) /
                      (maxExtent - minExtent))
                  .clamp(0.0, 1.0);

              // Padding: da esquerda para a direita
              final double horizontalPadding =
                  maxTitlePadding - (maxTitlePadding - minTitlePadding) * t;

              // Tamanho da fonte: maior expandido, menor colapsado
              final double defaultFontSize =
                  Theme.of(context).textTheme.titleLarge?.fontSize ?? 16.0;
              final double fontSize =
                  defaultFontSize + (maxFontSize - defaultFontSize) * t;

              return Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    left: horizontalPadding,
                    // Ajusta dinamicamente com base no estado de colapso:
                    bottom: (kToolbarHeight - fontSize) / 2 + (-10 * (1 - t)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.translate('General') ??
                              "General",
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Opacity(
                          opacity: t * t * t,
                          child: Text(
                            "Configure tema, idioma e outros",
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
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
                      top: 20,
                      bottom: 0,
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
                  top: 0,
                  bottom: 0,
                  title: 'cor',
                  subtitle: 'cor',
                  icon: Icons.arrow_drop_down,
                  switchEnable: false,
                  onPressed: () {},
                ),
                SizedBox(height: 2),
                SettingsTiles(
                  top: 0,
                  bottom: 20,
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
                  top: 20,
                  bottom: 20,
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
                        AppLocalizations.of(context)?.translate('your_data') ??
                            "Your data",
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
                top: 20,
                bottom: 0,
                title: 'Export',
                subtitle: 'Export your settings (coming soon)',
                icon: Icons.download,
                switchEnable: false,
                onPressed: () {},
              ),
              SizedBox(height: 2),
              SettingsTiles(
                top: 0,
                bottom: 20,
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
        SliverList(
          delegate: SliverChildBuilderDelegate((
            BuildContext context,
            int index,
          ) {
            return SizedBox(
              height: 100.0,
              child: Center(
                child: Text('$index', textScaler: const TextScaler.linear(5)),
              ),
            );
          }, childCount: 20),
        ),
      ],
    );
  }
}
