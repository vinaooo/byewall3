import 'package:byewall3/ui/app_colors.dart';
import 'package:byewall3/ui/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsTiles extends StatelessWidget {
  final int top;
  final int bottom;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool switchEnable;

  const SettingsTiles({
    super.key,
    required this.top,
    required this.bottom,
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

    return Material(
      color: Colors.transparent, // Necessário para o efeito ripple funcionar
      child: InkWell(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(top.toDouble()),
          topRight: Radius.circular(top.toDouble()),
          bottomLeft: Radius.circular(bottom.toDouble()),
          bottomRight: Radius.circular(bottom.toDouble()),
        ),
        onTap: () {
          if (switchEnable) {
            themeProvider.toggleBlackBackground(
              !themeProvider.useBlackBackground,
            );
          } else {
            onPressed();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.getTileColor(context), // Adicione uma cor de fundo
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(top.toDouble()),
              topRight: Radius.circular(top.toDouble()),
              bottomLeft: Radius.circular(bottom.toDouble()),
              bottomRight: Radius.circular(bottom.toDouble()),
            ),
          ),
          child: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            trailing:
                switchEnable
                    ? Switch(
                      value: themeProvider.useBlackBackground,
                      onChanged: (value) {
                        themeProvider.toggleBlackBackground(value);
                        themeProvider.saveBlackBackground(
                          value,
                        ); // Salva o estado ao alternar
                      },
                    )
                    : Icon(icon),
            onTap: switchEnable ? null : onPressed,
          ),
        ),
      ),
    );
  }
}
