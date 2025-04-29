import 'package:byewall3/l10n/app_localizations.dart';
import 'package:byewall3/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Classe que gerencia o estado do tema
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _useBlackBackground = false;

  ThemeMode get themeMode => _themeMode;
  bool get useBlackBackground => _useBlackBackground;

  Future<void> saveBlackBackground(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useBlackBackground', value);
  }

  Future<void> loadBlackBackground() async {
    final prefs = await SharedPreferences.getInstance();
    _useBlackBackground = prefs.getBool('useBlackBackground') ?? false;
    notifyListeners(); // Notifica os widgets que dependem desse estado
  }

  Future<void> saveTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', themeMode.index);
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('themeMode') ?? ThemeMode.system.index;
    _themeMode = ThemeMode.values[themeIndex];
    notifyListeners(); // Notifica os widgets que dependem desse estado
  }

  void toggleBlackBackground(bool value) {
    _useBlackBackground = value;
    notifyListeners();
  }

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    saveTheme(themeMode);
    notifyListeners();
  }

  static void showThemeSelection(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              themeProvider.themeMode == ThemeMode.dark ||
                      (themeProvider.themeMode == ThemeMode.system &&
                          MediaQuery.of(context).platformBrightness ==
                              Brightness.dark)
                  ? HSLColor.fromColor(
                    Theme.of(context).colorScheme.surface,
                  ).withLightness(0.21).toColor()
                  : null,
          title: Column(
            children: [
              Icon(Icons.brightness_6),
              Text(AppLocalizations.of(context)!.translate('theme_mode')),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color:
                      themeProvider.themeMode == ThemeMode.system
                          ? HSLColor.fromColor(
                            Theme.of(context).colorScheme.secondary,
                          ).withSaturation(0.6).withLightness(0.77).toColor()
                          : null,

                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  onTap: () {
                    themeProvider.setThemeMode(ThemeMode.system);
                    Navigator.of(context).pop();
                  },
                  child: ListTile(
                    title: Text(
                      style: TextStyle(
                        color:
                            themeProvider.themeMode == ThemeMode.system
                                ? Theme.of(context).colorScheme.onSecondary
                                : null,
                      ),
                      AppLocalizations.of(
                        context,
                      )!.translate('theme_mode_system'),
                    ),
                    leading: Icon(
                      Icons.check,
                      color:
                          themeProvider.themeMode == ThemeMode.system
                              ? Theme.of(context).colorScheme.onSecondary
                              : Colors.transparent,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color:
                      themeProvider.themeMode == ThemeMode.light
                          ? HSLColor.fromColor(
                            Theme.of(context).colorScheme.secondary,
                          ).withSaturation(0.6).withLightness(0.77).toColor()
                          : null,
                ),
                child: ListTile(
                  title: Text(
                    style: TextStyle(
                      color:
                          themeProvider.themeMode == ThemeMode.light
                              ? Theme.of(context).colorScheme.onSecondary
                              : null,
                    ),
                    AppLocalizations.of(context)!.translate('theme_mode_light'),
                  ),
                  leading: Icon(
                    Icons.check,
                    color:
                        themeProvider.themeMode == ThemeMode.light
                            ? Theme.of(context).colorScheme.onSecondary
                            : Colors.transparent,
                  ),
                  onTap: () {
                    themeProvider.setThemeMode(ThemeMode.light);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color:
                      themeProvider.themeMode == ThemeMode.dark
                          ? HSLColor.fromColor(
                            Theme.of(context).colorScheme.secondary,
                          ).withSaturation(0.6).withLightness(0.77).toColor()
                          : null,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  onTap: () {
                    themeProvider.setThemeMode(
                      ThemeMode.dark,
                    ); // Define o tema como escuro
                    Navigator.of(context).pop();
                  },
                  child: ListTile(
                    title: Text(
                      style: TextStyle(
                        color:
                            themeProvider.themeMode == ThemeMode.dark
                                ? Theme.of(context).colorScheme.onSecondary
                                : null,
                      ),
                      AppLocalizations.of(
                        context,
                      )!.translate('theme_mode_dark'),
                    ),
                    leading: Icon(
                      Icons.check,
                      color:
                          themeProvider.themeMode == ThemeMode.dark
                              ? Theme.of(context).colorScheme.onSecondary
                              : Colors.transparent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<dynamic> showColorSelection({
    required BuildContext context,
    required AppThemeMode selectedMode,
    required ValueChanged<AppThemeMode> onThemeSelected,
    required Map<AppThemeMode, Color> seeds,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ajusta o tamanho do conteúdo
              children: [
                ListTile(
                  trailing: Icon(
                    Icons.circle,
                    color:
                        selectedMode == AppThemeMode.dynamic
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey, // Cor do círculo
                  ),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (selectedMode == AppThemeMode.dynamic)
                        Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    ],
                  ),
                  title: Text('Dinâmico (Material You)'),
                  onTap: () {
                    onThemeSelected(AppThemeMode.dynamic);
                    Navigator.pop(context); // Fecha o diálogo após a seleção
                  },
                ),
                ...seeds.entries.map((entry) {
                  return ListTile(
                    trailing: Icon(Icons.circle, color: entry.value),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (selectedMode == entry.key)
                          Icon(Icons.check, color: entry.value),
                      ],
                    ),
                    title: Text(themeModeNames[entry.key] ?? entry.key.name),
                    onTap: () {
                      onThemeSelected(entry.key);
                      Navigator.pop(context); // Fecha o diálogo após a seleção
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
