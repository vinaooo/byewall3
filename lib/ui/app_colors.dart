import 'package:flutter/material.dart';

class AppColors {
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
