import 'package:byewall3/l10n/app_localizations.dart';
import 'package:byewall3/screens/settings_screen/about_settings.dart';
import 'package:byewall3/screens/settings_screen/general_settings.dart';
import 'package:byewall3/screens/settings_screen/services_settings.dart';
import 'package:flutter/material.dart';
import 'package:byewall3/utils/settings_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsManager _settingsManager = SettingsManager();
  int _selectedIndex = 0;

  final ScrollController _generalScrollController = ScrollController();
  final ScrollController _serviceScrollController = ScrollController();
  final ScrollController _aboutScrollController = ScrollController();

  @override
  void dispose() {
    _generalScrollController.dispose();
    _serviceScrollController.dispose();
    _aboutScrollController.dispose();
    super.dispose();
  }

  String _localeKey(Locale locale) {
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
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.build),
            icon: Icon(Icons.build_outlined),
            label: AppLocalizations.of(context)!.translate('general'),
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.list_outlined),
            icon: Icon(Icons.list_rounded),
            label: AppLocalizations.of(context)!.translate('services'),
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.info),
            icon: Icon(Icons.info_outlined),
            label: AppLocalizations.of(context)!.translate('about'),
          ),
        ],
      ),
      body:
          <Widget>[
            GeneralSettingsView(
              controller: _generalScrollController,
              settingsManager: _settingsManager,
              localeKey: _localeKey,
            ),
            ServiceSettingsView(controller: _serviceScrollController),
            AboutSettingsView(controller: _aboutScrollController),
          ][_selectedIndex],
    );
  }
}
