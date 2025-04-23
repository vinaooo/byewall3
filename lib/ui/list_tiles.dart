import 'package:byewall3/ui/app_colors.dart';
import 'package:flutter/material.dart';

class SettingsTiles extends StatelessWidget {
  final int topLeft;
  final int topRight;
  final int bottomRight;
  final int bottomLeft;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;
  final IconData trailing;

  const SettingsTiles({
    super.key,
    required this.topLeft,
    required this.topRight,
    required this.bottomRight,
    required this.bottomLeft,
    required this.title,
    required this.subtitle,
    required this.onPressed,
    required this.trailing,
  });

  get onTap => null;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        trailing: Icon(trailing),
        onTap: onPressed,
      ),
    );
  }
}
