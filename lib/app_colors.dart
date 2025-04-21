import 'package:flutter/material.dart';

class AppColors {
  static Color getAdjustedSecondaryContainer(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    final double lightness = isDarkTheme ? 0.15 : 0.91;
    final double saturation = isDarkTheme ? 0.01 : 0.25;
    final double alpha = isDarkTheme ? 0.4 : 0.5;

    return HSLColor.fromColor(Theme.of(context).colorScheme.primaryContainer)
        .withLightness(lightness)
        .withSaturation(saturation)
        .toColor()
        .withAlpha((alpha * 255).toInt());
  }
}
