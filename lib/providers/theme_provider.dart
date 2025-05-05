import 'package:byewall3/l10n/app_localizations.dart';
import 'package:byewall3/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diacritic/diacritic.dart';

// Classe que gerencia o estado do tema
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _useBlackBackground = false;
  Color? _dynamicColor;

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
  Color? get dynamicColor => _dynamicColor;

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

  Future<void> saveDynamicColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'dynamicColor',
      color.toString(),
    ); // Salva como string
    _dynamicColor = color;
    notifyListeners();
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

  Future<void> loadDynamicColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorString = prefs.getString('dynamicColor');
    if (colorString != null && colorString.startsWith('Color(')) {
      try {
        // Converte a string salva de volta para um objeto Color
        final colorValue = int.parse(
          colorString.split('(0x')[1].split(')')[0],
          radix: 16,
        );
        _dynamicColor = Color(colorValue);
      } catch (e) {
        // Caso ocorra um erro na conversão, define como null
        _dynamicColor = null;
      }
    } else {
      _dynamicColor = null; // Define como null se o formato for inválido
    }
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
                    focusColor: transparentIfSelectedForTheme(
                      themeProvider,
                      ThemeMode.system,
                    ),
                    hoverColor: transparentIfSelectedForTheme(
                      themeProvider,
                      ThemeMode.system,
                    ),
                    highlightColor: transparentIfSelectedForTheme(
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
                    focusColor: transparentIfSelectedForTheme(
                      themeProvider,
                      ThemeMode.light,
                    ),
                    hoverColor: transparentIfSelectedForTheme(
                      themeProvider,
                      ThemeMode.light,
                    ),
                    highlightColor: transparentIfSelectedForTheme(
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
                    focusColor: transparentIfSelectedForTheme(
                      themeProvider,
                      ThemeMode.dark,
                    ),
                    hoverColor: transparentIfSelectedForTheme(
                      themeProvider,
                      ThemeMode.dark,
                    ),
                    highlightColor: transparentIfSelectedForTheme(
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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final dynamicColor =
        themeProvider.dynamicColor ?? Theme.of(context).colorScheme.primary;
    final sortedSeeds =
        seeds.entries.toList()..sort((a, b) {
          final aName = themeModeNames(context)[a.key] ?? a.key.name;
          final bName = themeModeNames(context)[b.key] ?? b.key.name;
          // Remove acentos antes de comparar
          return removeDiacritics(aName).compareTo(removeDiacritics(bName));
        });
    return showDialog(
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
          title: dialogTitle(context, Icons.color_lens, 'accent_color'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    InkWell(
                      child: ListTile(
                        trailing: Icon(
                          Icons.circle,
                          color: dynamicColor, // Use a cor dinâmica salva
                        ),
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (selectedMode == AppThemeMode.dynamic)
                              Icon(Icons.check, color: dynamicColor),
                          ],
                        ),
                        title: Text('Dinâmico (Material You)'),
                        onTap: () {
                          onThemeSelected(AppThemeMode.dynamic);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                ...sortedSeeds.map((entry) {
                  return ListTile(
                    trailing: Icon(Icons.circle, color: entry.value),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (selectedMode == entry.key)
                          Icon(Icons.check, color: entry.value),
                      ],
                    ),
                    title: Text(
                      themeModeNames(context)[entry.key] ?? entry.key.name,
                    ),
                    onTap: () {
                      onThemeSelected(entry.key);
                      Navigator.pop(context);
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

  static Color? transparentIfSelectedForTheme(
    ThemeProvider provider,
    ThemeMode mode,
  ) => provider.themeMode == mode ? Colors.transparent : null;
}
