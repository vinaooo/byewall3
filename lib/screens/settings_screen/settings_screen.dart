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
    final double floatingBarWidth = 170; // Defina a largura desejada

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

          // Sombra atrás dos widgets flutuantes (agora ocupando toda a largura)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 95, // ajuste conforme necessário para cobrir até o topo dos widgets flutuantes
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.13),
                      blurRadius: 40,
                      spreadRadius: 8,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
              ),
            ),
          ),

          FloatingNavBar(
            screenWidth: screenWidth,
            floatingBarWidth: floatingBarWidth,
            selectedIndex: selectedIndex,
            elevation: 6,
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
                height: 70,
                width: 70,
                child: FloatingActionButton(
                  onPressed: () {
                    showDialog(context: context, builder: (context) => const ServiceDialog());
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
