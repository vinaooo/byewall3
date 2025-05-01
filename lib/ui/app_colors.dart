import 'package:byewall3/l10n/app_localizations.dart';
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
Map<AppThemeMode, String> themeModeNames(BuildContext context) {
  return {
    AppThemeMode.dynamic: AppLocalizations.of(context)!.translate('dynamic'),
    AppThemeMode.amber: AppLocalizations.of(context)!.translate('amber'),
    AppThemeMode.blue: AppLocalizations.of(context)!.translate('blue'),
    AppThemeMode.blueGrey: AppLocalizations.of(context)!.translate('blue_grey'),
    AppThemeMode.brown: AppLocalizations.of(context)!.translate('brown'),
    AppThemeMode.cyan: AppLocalizations.of(context)!.translate('cyan'),
    AppThemeMode.deepOrange: AppLocalizations.of(
      context,
    )!.translate('deep_orange'),
    AppThemeMode.deepPurple: AppLocalizations.of(
      context,
    )!.translate('deep_purple'),
    AppThemeMode.green: AppLocalizations.of(context)!.translate('green'),
    AppThemeMode.grey: AppLocalizations.of(context)!.translate('grey'),
    AppThemeMode.indigo: AppLocalizations.of(context)!.translate('indigo'),
    AppThemeMode.lightBlue: AppLocalizations.of(
      context,
    )!.translate('light_blue'),
    AppThemeMode.lightGreen: AppLocalizations.of(
      context,
    )!.translate('light_green'),
    AppThemeMode.lime: AppLocalizations.of(context)!.translate('lime'),
    AppThemeMode.orange: AppLocalizations.of(context)!.translate('orange'),
    AppThemeMode.pink: AppLocalizations.of(context)!.translate('pink'),
    AppThemeMode.purple: AppLocalizations.of(context)!.translate('purple'),
    AppThemeMode.red: AppLocalizations.of(context)!.translate('red'),
    AppThemeMode.teal: AppLocalizations.of(context)!.translate('teal'),
    AppThemeMode.yellow: AppLocalizations.of(context)!.translate('yellow'),
  };
}

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
