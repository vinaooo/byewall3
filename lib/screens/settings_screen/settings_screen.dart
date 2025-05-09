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
                            selectedIndex == 0
                                ? Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.15)
                                : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          selectedIndex == 0
                              ? Icons.build
                              : Icons.build_outlined,
                        ),
                        onPressed: () => setState(() => selectedIndex = 0),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color:
                            selectedIndex == 1
                                ? Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.15)
                                : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.list_rounded),
                        onPressed: () => setState(() => selectedIndex = 1),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color:
                            selectedIndex == 2
                                ? Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.15)
                                : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          selectedIndex == 2 ? Icons.info : Icons.info_outlined,
                          color:
                              selectedIndex == 2
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).iconTheme.color,
                        ),
                        onPressed: () => setState(() => selectedIndex = 2),
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
