import 'package:byewall3/ui/app_colors.dart';
import 'package:byewall3/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsTiles extends StatelessWidget {
  final int border; // 0 = none, 1 = top, 2 = bottom, 3 = all
  final String title;
  final String subtitle;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool switchEnable;

  const SettingsTiles({
    super.key,
    required this.border,
    required this.title,
    required this.subtitle,
    required this.onPressed,
    required this.icon,
    required this.switchEnable,
  });

  get onTap => null;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Função auxiliar para alternar e salvar o estado
    void toggleAndSaveBlackBackground(bool value) {
      themeProvider.toggleBlackBackground(value);
      themeProvider.saveBlackBackground(value); // Salva o estado ao alternar
    }

    bool widgetEnabled(context, bool switchEnable) {
      if (switchEnable) {
        return themeProvider.isDarkMode(context);
      }
      return true; // Tiles normais sempre habilitados
    }

    return Material(
      color: Colors.transparent, // Necessário para o efeito ripple funcionar
      child: InkWell(
        borderRadius:
            border == 0
                ? null
                : border == 3
                ? BorderRadius.circular(20.0)
                : border == 1
                ? const BorderRadius.vertical(top: Radius.circular(20.0))
                : border == 2
                ? const BorderRadius.vertical(bottom: Radius.circular(20.0))
                : BorderRadius.zero,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          if (!switchEnable) {
            onPressed();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.getTileColor(context), // Adicione uma cor de fundo
            borderRadius:
                border == 0
                    ? null
                    : border == 3
                    ? BorderRadius.circular(20.0)
                    : border == 1
                    ? const BorderRadius.vertical(top: Radius.circular(20.0))
                    : border == 2
                    ? const BorderRadius.vertical(bottom: Radius.circular(20.0))
                    : BorderRadius.zero,
          ),
          child: ListTile(
            enabled: widgetEnabled(context, switchEnable),
            shape:
                border == 3
                    ? RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )
                    : border == 1
                    ? const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.0),
                      ),
                    )
                    : border == 2
                    ? const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(20.0),
                      ),
                    )
                    : const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
            hoverColor: Colors.transparent,
            title: Text(title),
            subtitle: Text(subtitle),
            trailing:
                switchEnable
                    ? Switch(
                      value: themeProvider.useBlackBackground,
                      onChanged:
                          widgetEnabled(context, switchEnable)
                              ? toggleAndSaveBlackBackground
                              : null, // Switch desabilitado se ThemeMode.light
                    )
                    : Icon(
                      icon,
                      color:
                          icon == Icons.circle
                              ? (themeProvider.appThemeMode ==
                                      AppThemeMode.dynamic
                                  ? themeProvider.dynamicColor ??
                                      AppColors.seeds[AppThemeMode.dynamic]
                                  : AppColors.seeds[themeProvider.appThemeMode])
                              : null,
                    ),
            onTap:
                switchEnable
                    ? () {
                      toggleAndSaveBlackBackground(
                        !themeProvider.useBlackBackground,
                      );
                    }
                    : onPressed,
          ),
        ),
      ),
    );
  }
}
