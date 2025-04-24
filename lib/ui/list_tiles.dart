import 'package:byewall3/ui/app_colors.dart';
import 'package:byewall3/ui/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsTiles extends StatelessWidget {
  final int topLeft;
  final int topRight;
  final int bottomRight;
  final int bottomLeft;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool switchEnable;

  const SettingsTiles({
    super.key,
    required this.topLeft,
    required this.topRight,
    required this.bottomRight,
    required this.bottomLeft,
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
          topLeft: Radius.circular(topLeft.toDouble()),
          topRight: Radius.circular(topRight.toDouble()),
          bottomLeft: Radius.circular(bottomLeft.toDouble()),
          bottomRight: Radius.circular(bottomRight.toDouble()),
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
              topLeft: Radius.circular(topLeft.toDouble()),
              topRight: Radius.circular(topRight.toDouble()),
              bottomLeft: Radius.circular(bottomLeft.toDouble()),
              bottomRight: Radius.circular(bottomRight.toDouble()),
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
