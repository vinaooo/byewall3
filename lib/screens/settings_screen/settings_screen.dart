import 'package:byewall3/screens/settings_screen/about_settings.dart';
import 'package:byewall3/screens/settings_screen/general_settings.dart';
import 'package:byewall3/screens/settings_screen/services_settings.dart';
import 'package:byewall3/ui/app_colors.dart';
import 'package:byewall3/ui/components/floating_nav_bar.dart';
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
  int selectedIndex = 0;

  final ScrollController generalScrollController = ScrollController();
  final ScrollController serviceScrollController = ScrollController();
  final ScrollController aboutScrollController = ScrollController();

  get selectedMode => widget.selectedMode;
  get onThemeSelected => widget.onThemeSelected;
  get seeds => widget.seeds;

  @override
  void dispose() {
    generalScrollController.dispose();
    serviceScrollController.dispose();
    aboutScrollController.dispose();
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
              controller: generalScrollController,
              localeKey: localeKey,
              selectedMode: selectedMode,
              onThemeSelected: onThemeSelected,
              seeds: seeds,
            ),
            ServiceSettingsView(controller: serviceScrollController),
            AboutSettingsView(controller: aboutScrollController),
          ][selectedIndex],
          FloatingNavBar(
            screenWidth: screenWidth,
            floatingBarWidth: floatingBarWidth,
            selectedIndex: selectedIndex,
            onTap: (index) => setState(() => selectedIndex = index),
          ),
          Positioned(
            left: (screenWidth - floatingBarWidth) / 2 + floatingBarWidth + 8,
            bottom: 25,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: selectedIndex == 1 ? 1.0 : 0.0,
              curve: Curves.easeInOut,
              child: SizedBox(
                height: 60,
                width: 60,
                child: FloatingActionButton(
                  onPressed: () {
                    // Sua ação aqui
                  },
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  foregroundColor:
                      Theme.of(context).colorScheme.onPrimaryContainer,
                  elevation: 4,
                  mini: false,
                  child: const Icon(Icons.add),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
