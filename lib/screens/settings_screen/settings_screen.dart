import 'dart:ui';
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
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
          Positioned(
            left: screenWidth * 0.25,
            right: screenWidth * 0.25,
            bottom: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: BottomNavigationBar(
                    backgroundColor:
                        Theme.of(
                          context,
                        ).colorScheme.secondaryContainer, // Fundo do tema
                    currentIndex: _selectedIndex,
                    onTap: (int index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    showSelectedLabels: false, // Remove o espaço do label
                    showUnselectedLabels: false, // Remove o espaço do label
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.build_outlined),
                        activeIcon: Icon(Icons.build),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.list_rounded),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.info_outlined),
                        activeIcon: Icon(Icons.info),
                        label: '',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
