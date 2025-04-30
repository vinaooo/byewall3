import 'package:byewall3/l10n/app_localizations.dart';
import 'package:byewall3/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Classe que gerencia o estado do tema
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _useBlackBackground = false;

  bool isDarkMode(BuildContext context) {
    return _themeMode == ThemeMode.dark ||
        (_themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
  }

  // Novo campo para armazenar o modo de cor do tema
  AppThemeMode _appThemeMode = AppThemeMode.dynamic;

  ThemeMode get themeMode => _themeMode;
  bool get useBlackBackground => _useBlackBackground;
  AppThemeMode get appThemeMode => _appThemeMode;

  Future<void> saveBlackBackground(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useBlackBackground', value);
  }

  Future<void> saveTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', themeMode.index);
  }

  // Salva o modo de cor do tema
  Future<void> saveAppThemeMode(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('appThemeMode', mode.index);
  }

  Future<void> loadBlackBackground() async {
    final prefs = await SharedPreferences.getInstance();
    _useBlackBackground = prefs.getBool('useBlackBackground') ?? false;
    notifyListeners(); // Notifica os widgets que dependem desse estado
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('themeMode') ?? ThemeMode.system.index;
    _themeMode = ThemeMode.values[themeIndex];
    notifyListeners(); // Notifica os widgets que dependem desse estado
  }

  // Carrega o modo de cor do tema
  Future<void> loadAppThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('appThemeMode') ?? AppThemeMode.dynamic.index;
    _appThemeMode = AppThemeMode.values[index];
    notifyListeners();
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

  // Atualiza e salva o modo de cor do tema
  void setAppThemeMode(AppThemeMode mode) {
    _appThemeMode = mode;
    saveAppThemeMode(mode);
    notifyListeners();
  }

  static void showThemeSelection(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(top: 16.0, bottom: 30),
          backgroundColor:
              themeProvider.themeMode == ThemeMode.dark ||
                      (themeProvider.themeMode == ThemeMode.system &&
                          MediaQuery.of(context).platformBrightness ==
                              Brightness.dark)
                  ? HSLColor.fromColor(
                    Theme.of(context).colorScheme.surface,
                  ).withLightness(0.21).toColor()
                  : null,
          title: dialogTitle(context, Icons.brightness_6, 'theme_mode'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  selectionBox(themeProvider, context, ThemeMode.system),
                  InkWell(
                    focusColor: transparentIfSelected(
                      themeProvider,
                      ThemeMode.system,
                    ),
                    hoverColor: transparentIfSelected(
                      themeProvider,
                      ThemeMode.system,
                    ),
                    highlightColor: transparentIfSelected(
                      themeProvider,
                      ThemeMode.system,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      themeProvider.setThemeMode(ThemeMode.system);
                    },
                    child: ListTile(
                      tileColor: Colors.transparent, // Garante transparência
                      contentPadding: EdgeInsets.symmetric(horizontal: 36),
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
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 13.0),
                        child: Icon(
                          Icons.check,
                          color:
                              themeProvider.themeMode == ThemeMode.system
                                  ? Theme.of(context).colorScheme.onSecondary
                                  : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  selectionBox(themeProvider, context, ThemeMode.light),
                  InkWell(
                    focusColor: transparentIfSelected(
                      themeProvider,
                      ThemeMode.light,
                    ),
                    hoverColor: transparentIfSelected(
                      themeProvider,
                      ThemeMode.light,
                    ),
                    highlightColor: transparentIfSelected(
                      themeProvider,
                      ThemeMode.light,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      themeProvider.setThemeMode(ThemeMode.light);
                    },
                    child: ListTile(
                      tileColor: Colors.transparent,
                      contentPadding: EdgeInsets.symmetric(horizontal: 36),
                      title: Text(
                        style: TextStyle(
                          color:
                              themeProvider.themeMode == ThemeMode.light
                                  ? Theme.of(context).colorScheme.onSecondary
                                  : null,
                        ),
                        AppLocalizations.of(
                          context,
                        )!.translate('theme_mode_light'),
                      ),
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 13.0),
                        child: Icon(
                          Icons.check,
                          color:
                              themeProvider.themeMode == ThemeMode.light
                                  ? Theme.of(context).colorScheme.onSecondary
                                  : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  selectionBox(themeProvider, context, ThemeMode.dark),
                  InkWell(
                    focusColor: transparentIfSelected(
                      themeProvider,
                      ThemeMode.dark,
                    ),
                    hoverColor: transparentIfSelected(
                      themeProvider,
                      ThemeMode.dark,
                    ),
                    highlightColor: transparentIfSelected(
                      themeProvider,
                      ThemeMode.dark,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      themeProvider.setThemeMode(ThemeMode.dark);
                    },
                    child: ListTile(
                      tileColor: Colors.transparent,
                      contentPadding: EdgeInsets.symmetric(horizontal: 36),
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
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 13.0),
                        child: Icon(
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
            ],
          ),
        );
      },
    );
  }

  static Column dialogTitle(BuildContext context, IconData icon, String title) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Icon(icon, size: 48),
        const SizedBox(height: 16),
        Text(AppLocalizations.of(context)!.translate(title)),
        const SizedBox(height: 16),
      ],
    );
  }

  static Padding selectionBox(
    ThemeProvider themeProvider,
    BuildContext context,
    ThemeMode mode,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Container(
        height: 48, // Altura do ListTile
        decoration: BoxDecoration(
          color:
              themeProvider.themeMode == mode
                  ? HSLColor.fromColor(
                    Theme.of(context).colorScheme.secondary,
                  ).withSaturation(0.6).withLightness(0.77).toColor()
                  : null,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
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
          title: dialogTitle(context, Icons.color_lens, 'accent_color'),
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

  static Color? transparentIfSelected(ThemeProvider provider, ThemeMode mode) =>
      provider.themeMode == mode ? Colors.transparent : null;
}
