import 'package:byewall3/l10n/app_localizations.dart';
import 'package:byewall3/screens/settings_screen/about_settings.dart';
import 'package:byewall3/screens/settings_screen/general_settings.dart';
import 'package:byewall3/screens/settings_screen/services_settings.dart';
import 'package:byewall3/ui/app_colors.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final AppColor selectedMode;
  final ValueChanged<AppColor> onThemeSelected;
  final Map<AppColor, Color> seeds;

  const SettingsScreen({
    super.key,
    required this.selectedMode,
    required this.onThemeSelected,
    required this.seeds,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 0;

  final ScrollController _generalScrollController = ScrollController();
  final ScrollController _serviceScrollController = ScrollController();
  final ScrollController _aboutScrollController = ScrollController();

  get selectedMode => widget.selectedMode;
  get onThemeSelected => widget.onThemeSelected;
  get seeds => widget.seeds;

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
            selectedIcon: const Icon(Icons.build),
            icon: const Icon(Icons.build_outlined),
            label: AppLocalizations.of(context)!.translate('general'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.list_rounded),
            label: AppLocalizations.of(context)!.translate('services'),
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.info),
            icon: const Icon(Icons.info_outlined),
            label: AppLocalizations.of(context)!.translate('about'),
          ),
        ],
      ),
      body:
          <Widget>[
            GeneralSettingsView(
              controller: _generalScrollController,
              localeKey: _localeKey,
              selectedMode: selectedMode,
              onThemeSelected: onThemeSelected,
              seeds: seeds,
            ),
            ServiceSettingsView(controller: _serviceScrollController),
            AboutSettingsView(controller: _aboutScrollController),
          ][_selectedIndex],
    );
  }
}
