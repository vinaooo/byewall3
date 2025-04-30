import 'package:byewall3/providers/theme_provider.dart';
import 'package:byewall3/screens/settings_screen/settings_screen.dart';
import 'package:byewall3/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    super.key,
    required this.onThemeSelected,
    required this.seeds,
  });

  final ValueChanged<AppThemeMode> onThemeSelected;
  final Map<AppThemeMode, Color> seeds;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.settings_outlined),
          label: const Text('Configurações'),
          onPressed: () async {
            final themeProvider = Provider.of<ThemeProvider>(
              context,
              listen: false,
            );
            await Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder:
                    (context) => SettingsScreen(
                      selectedMode: themeProvider.appThemeMode,
                      onThemeSelected: onThemeSelected,
                      seeds: seeds,
                    ),
              ),
            );
          },
        ),
      ),
    );
  }
}
