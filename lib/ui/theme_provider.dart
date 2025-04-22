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
          backgroundColor: AppColors.getDialogBoxColor(context),
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
                  color: AppColors.getDialogTileColor(
                    context,
                  ), // Adicione uma cor de fundo
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    AppLocalizations.of(
                          context,
                        )?.translate('theme_mode_system') ??
                        "System",
                  ),
                  leading: Radio<ThemeMode>(
                    value: ThemeMode.system,
                    groupValue: themeProvider.themeMode,
                    onChanged: (ThemeMode? value) {
                      themeProvider.setThemeMode(value!);
                      Navigator.of(context).pop();
                    },
                  ),
                  onTap: () {
                    // Altera o valor do Radio ao tocar em qualquer parte do ListTile
                    themeProvider.setThemeMode(ThemeMode.system);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.getDialogTileColor(
                    context,
                  ), // Adicione uma cor de fundo
                ),
                child: ListTile(
                  title: Text(
                    AppLocalizations.of(
                          context,
                        )?.translate('theme_mode_light') ??
                        "Light",
                  ),
                  leading: Radio<ThemeMode>(
                    value: ThemeMode.light,
                    groupValue: themeProvider.themeMode,
                    onChanged: (ThemeMode? value) {
                      themeProvider.setThemeMode(value!);
                      Navigator.of(context).pop();
                    },
                  ),
                  onTap: () {
                    // Altera o valor do Radio ao tocar em qualquer parte do ListTile
                    themeProvider.setThemeMode(ThemeMode.light);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.getDialogTileColor(
                    context,
                  ), // Adicione uma cor de fundo
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    AppLocalizations.of(
                          context,
                        )?.translate('theme_mode_dark') ??
                        "Dark",
                  ),
                  leading: Radio<ThemeMode>(
                    value: ThemeMode.dark,
                    groupValue: themeProvider.themeMode,
                    onChanged: (ThemeMode? value) {
                      themeProvider.setThemeMode(value!);
                      Navigator.of(context).pop();
                    },
                  ),
                  onTap: () {
                    // Altera o valor do Radio ao tocar em qualquer parte do ListTile
                    themeProvider.setThemeMode(ThemeMode.dark);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
