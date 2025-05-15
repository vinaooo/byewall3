import 'package:byewall3/screens/settings_screen/about_settings.dart';
import 'package:byewall3/ui/components/service_dialog.dart';
import 'package:byewall3/screens/settings_screen/general_settings.dart';
import 'package:byewall3/screens/settings_screen/services_settings.dart';
import 'package:byewall3/ui/app_colors.dart';
import 'package:byewall3/ui/components/floating_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:byewall3/screens/settings_screen/placeholder_settings.dart';

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

    final views = [
      GeneralSettingsView(
        controller: generalScrollController,
        localeKey: localeKey,
        selectedMode: selectedMode,
        onThemeSelected: onThemeSelected,
        seeds: seeds,
      ),
      ServiceSettingsView(controller: serviceScrollController),
      AboutSettingsView(controller: aboutScrollController),
      const PlaceholderSettingsView(),
      const PlaceholderSettingsView(), // Adicionada uma nova view
    ];

    final double iconSize = 30;
    final double itemSpacing = 12;
    final double floatingBarWidth = (views.length * (iconSize + itemSpacing)) + itemSpacing;
    final double minBarWidth = 220; // Match with FloatingNavBar
    final double barWidth = floatingBarWidth > minBarWidth ? floatingBarWidth : minBarWidth;

    return Scaffold(
      body: Stack(
        children: [
          views[selectedIndex],
          FloatingNavBar(
            size: 2,
            screenWidth: screenWidth,
            selectedIndex: selectedIndex,
            onTap: (index) => setState(() => selectedIndex = index),
            items: const [
              FloatingNavBarItem(icon: Icons.build_outlined, activeIcon: Icons.build),
              FloatingNavBarItem(icon: Icons.list_rounded),
              FloatingNavBarItem(icon: Icons.info_outlined, activeIcon: Icons.info),
              // FloatingNavBarItem(icon: Icons.star_outline, activeIcon: Icons.star),
              // FloatingNavBarItem(icon: Icons.settings_outlined, activeIcon: Icons.settings),
            ],
          ),
          Positioned(
            left: (screenWidth - barWidth) / 2 + barWidth + 8,
            bottom: 25,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: selectedIndex == 1 ? 1.0 : 0.0,
              curve: Curves.easeInOut,
              child: SizedBox(
                height: 70,
                width: 70,
                child: FloatingActionButton(
                  onPressed: () {
                    if (selectedIndex == 1) {
                      showDialog(context: context, builder: (context) => const ServiceDialog());
                    }
                  },
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  elevation: 3,
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
