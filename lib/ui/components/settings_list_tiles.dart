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

    return Material(
      color: Colors.transparent, // Necessário para o efeito ripple funcionar
      child: InkWell(
        borderRadius:
            border == 0
                ? null
                : border == 3
                ? BorderRadius.circular(20.0)
                : BorderRadius.only(
                  topLeft: border == 1 ? Radius.circular(20.0) : Radius.zero,
                  topRight: border == 1 ? Radius.circular(20.0) : Radius.zero,
                  bottomLeft: border == 2 ? Radius.circular(20.0) : Radius.zero,
                  bottomRight:
                      border == 2 ? Radius.circular(20.0) : Radius.zero,
                ),
        onTap: () {
          if (switchEnable) {
            toggleAndSaveBlackBackground(!themeProvider.useBlackBackground);
          } else {
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
                    : BorderRadius.only(
                      topLeft:
                          border == 1 ? Radius.circular(20.0) : Radius.zero,
                      topRight:
                          border == 1 ? Radius.circular(20.0) : Radius.zero,
                      bottomLeft:
                          border == 2 ? Radius.circular(20.0) : Radius.zero,
                      bottomRight:
                          border == 2 ? Radius.circular(20.0) : Radius.zero,
                    ),
          ),
          child: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            trailing:
                switchEnable
                    ? Switch(
                      value: themeProvider.useBlackBackground,
                      onChanged: toggleAndSaveBlackBackground,
                    )
                    : Icon(icon),
            onTap: switchEnable ? null : onPressed,
          ),
        ),
      ),
    );
  }
}
