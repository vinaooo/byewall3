import 'package:flutter/material.dart';

enum AppThemeMode {
  dynamic,
  amber,
  blue,
  blueGrey,
  brown,
  cyan,
  deepOrange,
  deepPurple,
  green,
  grey,
  indigo,
  lightBlue,
  lightGreen,
  lime,
  orange,
  pink,
  purple,
  red,
  teal,
  yellow,
}

// Nomes formatados para exibição
const Map<AppThemeMode, String> themeModeNames = {
  AppThemeMode.dynamic: 'Dynamic (Material You)',
  AppThemeMode.amber: 'Amber',
  AppThemeMode.blue: 'Blue',
  AppThemeMode.blueGrey: 'Blue Grey',
  AppThemeMode.brown: 'Brown',
  AppThemeMode.cyan: 'Cyan',
  AppThemeMode.deepOrange: 'Deep Orange',
  AppThemeMode.deepPurple: 'Deep Purple',
  AppThemeMode.green: 'Green',
  AppThemeMode.grey: 'Grey',
  AppThemeMode.indigo: 'Indigo',
  AppThemeMode.lightBlue: 'Light Blue',
  AppThemeMode.lightGreen: 'Light Green',
  AppThemeMode.lime: 'Lime',
  AppThemeMode.orange: 'Orange',
  AppThemeMode.pink: 'Pink',
  AppThemeMode.purple: 'Purple',
  AppThemeMode.red: 'Red',
  AppThemeMode.teal: 'Teal',
  AppThemeMode.yellow: 'Yellow',
};

class AppColors {
  // Mova o Map seeds para cá
  static final Map<AppThemeMode, Color> seeds = {
    AppThemeMode.amber: Colors.amber,
    AppThemeMode.blue: Colors.blue,
    AppThemeMode.blueGrey: Colors.blueGrey,
    AppThemeMode.brown: Colors.brown,
    AppThemeMode.cyan: Colors.cyan,
    AppThemeMode.deepOrange: Colors.deepOrange,
    AppThemeMode.deepPurple: Colors.deepPurple,
    AppThemeMode.green: Colors.green,
    AppThemeMode.grey: Colors.grey,
    AppThemeMode.indigo: Colors.indigo,
    AppThemeMode.lightBlue: Colors.lightBlue,
    AppThemeMode.lightGreen: Colors.lightGreen,
    AppThemeMode.lime: Colors.lime,
    AppThemeMode.orange: Colors.orange,
    AppThemeMode.pink: Colors.pink,
    AppThemeMode.purple: Colors.purple,
    AppThemeMode.red: Colors.red,
    AppThemeMode.teal: Colors.teal,
    AppThemeMode.yellow: Colors.yellow,
  };

  static Color getTileColor(BuildContext context) {
    return HSLColor.fromColor(Theme.of(context).colorScheme.primaryContainer)
        .withLightness(_getLightness(context))
        .withSaturation(_getSaturation(context))
        .toColor()
        .withAlpha((_getAlpha(context)).toInt());
  }

  static Color getDialogBoxColor(BuildContext context) {
    return HSLColor.fromColor(Theme.of(context).colorScheme.primaryContainer)
        .withLightness(_getLightness(context))
        .withSaturation(_getSaturation(context))
        .toColor();
  }

  static Color getDialogTileColor(BuildContext context) {
    return HSLColor.fromColor(Theme.of(context).colorScheme.primaryContainer)
        .withLightness(_getLightness(context))
        .toColor()
        .withAlpha((_getAlpha(context)).toInt());
  }

  static bool _getIsDarkTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static double _getLightness(BuildContext context) {
    bool isDarkTheme = _getIsDarkTheme(context);
    return isDarkTheme ? 0.2 : 0.91;
  }

  static double _getSaturation(BuildContext context) {
    bool isDarkTheme = _getIsDarkTheme(context);
    return isDarkTheme ? 0.1 : 0.25;
  }

  static double _getAlpha(BuildContext context) {
    bool isDarkTheme = _getIsDarkTheme(context);
    return (isDarkTheme ? 0.4 : 0.5) * 255;
  }
}
