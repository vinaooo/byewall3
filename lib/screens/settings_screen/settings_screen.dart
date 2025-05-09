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

  String localeKey(Locale locale) {
    if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
      return '${locale.languageCode}_${locale.countryCode}';
    }
    return locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double floatingBarWidth = 155; // Defina a largura desejada

    return Scaffold(
      body: Stack(
        children: [
          <Widget>[
            GeneralSettingsView(
              controller: _generalScrollController,
              localeKey: localeKey,
              selectedMode: selectedMode,
              onThemeSelected: onThemeSelected,
              seeds: seeds,
            ),
            ServiceSettingsView(controller: _serviceScrollController),
            AboutSettingsView(controller: _aboutScrollController),
          ][_selectedIndex],
          Positioned(
            left: (screenWidth - floatingBarWidth) / 2,
            width: floatingBarWidth,
            bottom: 25,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                height: 60, // Altura customizada
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color:
                            _selectedIndex == 0
                                ? Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.15)
                                : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          _selectedIndex == 0
                              ? Icons.build
                              : Icons.build_outlined,
                        ),
                        onPressed: () => setState(() => _selectedIndex = 0),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color:
                            _selectedIndex == 1
                                ? Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.15)
                                : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.list_rounded),
                        onPressed: () => setState(() => _selectedIndex = 1),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color:
                            _selectedIndex == 2
                                ? Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.15)
                                : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          _selectedIndex == 2
                              ? Icons.info
                              : Icons.info_outlined,
                          color:
                              _selectedIndex == 2
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).iconTheme.color,
                        ),
                        onPressed: () => setState(() => _selectedIndex = 2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
