import 'package:byewall3/ui/app_colors.dart';
import 'package:byewall3/ui/components/dialog_title.dart';
import 'package:byewall3/ui/components/localized_text.dart';
import 'package:byewall3/ui/components/selection_box.dart';
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
  AppColor _appThemeColor = AppColor.dynamic;

  ThemeMode get themeMode => _themeMode;
  bool get useBlackBackground => _useBlackBackground;
  AppColor get appThemeColor => _appThemeColor;
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
  Future<void> saveAppThemeColor(AppColor mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('appThemeColor', mode.index);
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
  Future<void> loadAppThemeColor() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('appThemeColor') ?? AppColor.dynamic.index;
    _appThemeColor = AppColor.values[index];
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
  void setAppThemeColor(AppColor mode) {
    _appThemeColor = mode;
    saveAppThemeColor(mode);
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
          title: DialogTitle(
            context: context,
            icon: Icons.brightness_6,
            title: 'theme_mode',
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    SelectionBox(
                      themeProvider: themeProvider,
                      context: context,
                      mode: ThemeMode.system,
                    ),
                    InkWell(
                      focusColor: transparentIfSelected(
                        tp: themeProvider,
                        mode: ThemeMode.system,
                      ),
                      hoverColor: transparentIfSelected(
                        tp: themeProvider,
                        mode: ThemeMode.system,
                      ),
                      highlightColor: transparentIfSelected(
                        tp: themeProvider,
                        mode: ThemeMode.system,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        themeProvider.setThemeMode(ThemeMode.system);
                      },
                      child: ListTile(
                        tileColor: Colors.transparent, // Garante transparência
                        contentPadding: EdgeInsets.symmetric(horizontal: 36),
                        title: LocalizedText(
                          tKey: 'theme_mode_system',
                          style: TextStyle(
                            color:
                                themeProvider.themeMode == ThemeMode.system
                                    ? Theme.of(context).colorScheme.onSecondary
                                    : null,
                          ),
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
                    SelectionBox(
                      themeProvider: themeProvider,
                      context: context,
                      mode: ThemeMode.light,
                    ),
                    InkWell(
                      focusColor: transparentIfSelected(
                        tp: themeProvider,
                        mode: ThemeMode.light,
                      ),
                      hoverColor: transparentIfSelected(
                        tp: themeProvider,
                        mode: ThemeMode.light,
                      ),
                      highlightColor: transparentIfSelected(
                        tp: themeProvider,
                        mode: ThemeMode.light,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        themeProvider.setThemeMode(ThemeMode.light);
                      },
                      child: ListTile(
                        tileColor: Colors.transparent,
                        contentPadding: EdgeInsets.symmetric(horizontal: 36),
                        title: LocalizedText(
                          tKey: 'theme_mode_light',
                          style: TextStyle(
                            color:
                                themeProvider.themeMode == ThemeMode.light
                                    ? Theme.of(context).colorScheme.onSecondary
                                    : null,
                          ),
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
                    SelectionBox(
                      themeProvider: themeProvider,
                      context: context,
                      mode: ThemeMode.dark,
                    ),
                    InkWell(
                      focusColor: transparentIfSelected(
                        tp: themeProvider,
                        mode: ThemeMode.dark,
                      ),
                      hoverColor: transparentIfSelected(
                        tp: themeProvider,
                        mode: ThemeMode.dark,
                      ),
                      highlightColor: transparentIfSelected(
                        tp: themeProvider,
                        mode: ThemeMode.dark,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        themeProvider.setThemeMode(ThemeMode.dark);
                      },
                      child: ListTile(
                        tileColor: Colors.transparent,
                        contentPadding: EdgeInsets.symmetric(horizontal: 36),
                        title: LocalizedText(
                          tKey: 'theme_mode_dark',
                          style: TextStyle(
                            color:
                                themeProvider.themeMode == ThemeMode.dark
                                    ? Theme.of(context).colorScheme.onSecondary
                                    : null,
                          ),
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
          ),
        );
      },
    );
  }

  static Future<dynamic> showColorSelection({
    required BuildContext context,
    required AppColor selectedMode,
    required ValueChanged<AppColor> onThemeSelected,
    required Map<AppColor, Color> seeds,
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
          title: DialogTitle(
            context: context,
            icon: Icons.color_lens,
            title: 'accent_color',
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.5,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      SelectionBox(
                        themeProvider: themeProvider,
                        context: context,
                        appColor: AppColor.dynamic,
                      ),
                      InkWell(
                        focusColor: transparentIfSelected(
                          tp: themeProvider,
                          appColor: AppColor.dynamic,
                        ),
                        hoverColor: transparentIfSelected(
                          tp: themeProvider,
                          appColor: AppColor.dynamic,
                        ),
                        highlightColor: transparentIfSelected(
                          tp: themeProvider,
                          appColor: AppColor.dynamic,
                        ),
                        child: ListTile(
                          hoverColor: transparentIfSelected(
                            tp: themeProvider,
                            appColor: AppColor.dynamic,
                          ),
                          splashColor: transparentIfSelected(
                            tp: themeProvider,
                            appColor: AppColor.dynamic,
                          ),
                          tileColor: transparentIfSelected(
                            tp: themeProvider,
                            appColor: AppColor.dynamic,
                          ),
                          trailing: Icon(
                            Icons.circle,
                            color: dynamicColor, // Use a cor dinâmica salva
                          ),
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (selectedMode == AppColor.dynamic)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Icon(
                                    Icons.check,
                                    color:
                                        themeProvider.appThemeColor ==
                                                AppColor.dynamic
                                            ? Theme.of(
                                              context,
                                            ).colorScheme.onSecondary
                                            : null,
                                  ),
                                ),

                              if (selectedMode != AppColor.dynamic)
                                const SizedBox(width: 40),
                            ],
                          ),
                          title: LocalizedText(
                            tKey: 'dynamic',
                            style: TextStyle(
                              color:
                                  themeProvider.appThemeColor ==
                                          AppColor.dynamic
                                      ? Theme.of(
                                        context,
                                      ).colorScheme.onSecondary
                                      : null,
                            ),
                          ),
                          onTap: () {
                            onThemeSelected(AppColor.dynamic);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  ...sortedSeeds.map((entry) {
                    return Stack(
                      children: [
                        SelectionBox(
                          themeProvider: themeProvider,
                          context: context,
                          appColor: entry.key,
                        ),
                        ListTile(
                          trailing: Icon(Icons.circle, color: entry.value),
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (selectedMode == entry.key)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Icon(
                                    Icons.check,
                                    color:
                                        themeProvider.appThemeColor == entry.key
                                            ? Theme.of(
                                              context,
                                            ).colorScheme.onSecondary
                                            : null,
                                  ),
                                ),
                              if (selectedMode != entry.key)
                                const SizedBox(width: 32),
                            ],
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: LocalizedText(
                              tKey:
                                  themeModeNames(context)[entry.key] ??
                                  entry.key.name,
                              style: TextStyle(
                                color:
                                    themeProvider.appThemeColor == entry.key
                                        ? Theme.of(
                                          context,
                                        ).colorScheme.onSecondary
                                        : null,
                              ),
                            ),
                          ),
                          onTap: () {
                            onThemeSelected(entry.key);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Color? transparentIfSelected({
    ThemeProvider? tp,
    ThemeMode? mode,
    AppColor? appColor,
  }) {
    return tp!.themeMode == mode || tp.appThemeColor == appColor
        ? Colors.transparent
        : null;
  }
}
