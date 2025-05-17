import 'package:byewall3/screens/settings_screen/about_settings.dart';
import 'package:byewall3/ui/components/service_dialog.dart';
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
  final PageController _pageController = PageController();

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
    ];

    final double iconSize = 30;
    final double itemSpacing = 12;
    final double floatingBarWidth = (views.length * (iconSize + itemSpacing)) + itemSpacing;
    final double minBarWidth = 220; // Match with FloatingNavBar
    final double barWidth = floatingBarWidth > minBarWidth ? floatingBarWidth : minBarWidth;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),

            onPageChanged: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            children: views,
          ),
          FloatingNavBar(
            size: 2,
            screenWidth: screenWidth,
            selectedIndex: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });

              // Defina a duração com base na distância entre os índices
              final int distance = (selectedIndex - index).abs();
              final int duration =
                  distance > 1 ? 700 : 350; // 600ms para saltos maiores, 350ms para saltos menores

              _pageController.animateToPage(
                index,
                duration: Duration(milliseconds: duration),
                curve: Curves.easeInToLinear,
              );
            },
            items: const [
              FloatingNavBarItem(icon: Icons.build_outlined, activeIcon: Icons.build),
              FloatingNavBarItem(icon: Icons.list_rounded),
              FloatingNavBarItem(icon: Icons.info_outlined, activeIcon: Icons.info),
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
