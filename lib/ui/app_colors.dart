import 'package:byewall3/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum AppColor {
  dynamic,
  amber,
  blue,
  blueGrey,
  brown,
  green,
  grey,
  orange,
  pink,
  purple,
  red,
  teal,
}

// Nomes formatados para exibição
Map<AppColor, String> themeModeNames(BuildContext context) {
  return {
    AppColor.dynamic: AppLocalizations.of(context)!.translate('dynamic'),
    AppColor.amber: AppLocalizations.of(context)!.translate('amber'),
    AppColor.blue: AppLocalizations.of(context)!.translate('blue'),
    AppColor.blueGrey: AppLocalizations.of(context)!.translate('blue_grey'),
    AppColor.brown: AppLocalizations.of(context)!.translate('brown'),
    AppColor.green: AppLocalizations.of(context)!.translate('green'),
    AppColor.grey: AppLocalizations.of(context)!.translate('grey'),
    AppColor.orange: AppLocalizations.of(context)!.translate('orange'),
    AppColor.pink: AppLocalizations.of(context)!.translate('pink'),
    AppColor.purple: AppLocalizations.of(context)!.translate('purple'),
    AppColor.red: AppLocalizations.of(context)!.translate('red'),
    AppColor.teal: AppLocalizations.of(context)!.translate('teal'),
  };
}

class AppColors {
  // Mova o Map seeds para cá
  static final Map<AppColor, Color> seeds = {
    AppColor.amber: Colors.amber,
    AppColor.blue: Colors.blue,
    AppColor.blueGrey: Colors.blueGrey,
    AppColor.brown: Colors.brown,
    AppColor.green: Colors.green,
    AppColor.grey: Colors.grey,
    AppColor.orange: Colors.orange,
    AppColor.pink: Colors.pink,
    AppColor.purple: Colors.purple,
    AppColor.red: Colors.red,
    AppColor.teal: Colors.teal,
  };

  final Color brown;
  final Color darkBrown;
  final Color pink;
  final Color darkPink;
  final Color blue;
  final Color darkBlue;
  final Color green;
  final Color darkGreen;

  AppColors()
    : brown = const Color.fromARGB(255, 254, 221, 194),
      darkBrown = Color.fromARGB(255, 122, 49, 0),
      //
      pink = const Color.fromARGB(255, 255, 210, 243),
      darkPink = const Color.fromARGB(255, 153, 0, 88),
      //
      blue = const Color.fromARGB(255, 176, 238, 253),
      darkBlue = const Color.fromARGB(255, 0, 75, 103),
      //
      green = const Color.fromARGB(255, 174, 240, 178),
      darkGreen = const Color.fromARGB(255, 0, 89, 39);

  static Color getTileColor(BuildContext context) {
    return HSLColor.fromColor(Theme.of(context).colorScheme.primaryContainer)
        .withLightness(_getLightness(context))
        .withSaturation(_getSaturation(context))
        .toColor()
        .withAlpha((_getAlpha(context)).toInt());
  } // Novo método para cores completamente opacas seguindo Material 3

  static Color getSolidTileColor(BuildContext context) {
    final bool isDarkTheme = _getIsDarkTheme(context);
    final colorScheme = Theme.of(context).colorScheme;

    if (isDarkTheme) {
      // Para tema escuro: usa uma cor mais escura baseada no surface
      return Color.alphaBlend(colorScheme.primary.withValues(alpha: 0.08), colorScheme.surface);
    } else {
      // Para tema claro: usa uma cor mais evidente baseada no surface
      return Color.alphaBlend(colorScheme.primary.withValues(alpha: 0.12), colorScheme.surface);
    }
  }

  static Color getDialogBoxColor(BuildContext context) {
    return HSLColor.fromColor(
      Theme.of(context).colorScheme.primaryContainer,
    ).withLightness(_getLightness(context)).withSaturation(_getSaturation(context)).toColor();
  }

  static Color getDialogTileColor(BuildContext context) {
    return HSLColor.fromColor(
      Theme.of(context).colorScheme.primaryContainer,
    ).withLightness(_getLightness(context)).toColor().withAlpha((_getAlpha(context)).toInt());
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
