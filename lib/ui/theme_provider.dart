import 'package:byewall3/l10n/app_localizations.dart';
import 'package:byewall3/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Classe que gerencia o estado do tema
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners(); // Notifica os widgets que dependem desse estado
  }

  static void show(BuildContext context) {
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
              Text(
                AppLocalizations.of(context)?.translate('theme_mode') ??
                    "Theme Mode",
              ),
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
                          )?.translate('theme_mode_system') ??
                          "System",
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
                    AppLocalizations.of(
                          context,
                        )?.translate('theme_mode_light') ??
                        "Light",
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
                    themeProvider.setThemeMode(ThemeMode.system);
                    Navigator.of(context).pop();
                  },
                  child: ListTile(
                    title: Text(
                      AppLocalizations.of(
                            context,
                          )?.translate('theme_mode_dark') ??
                          "Dark",
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
}
