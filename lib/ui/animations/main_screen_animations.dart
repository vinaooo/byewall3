import 'package:byewall3/providers/theme_provider.dart';
import 'package:byewall3/screens/settings_screen/settings_screen.dart';
import 'package:byewall3/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreenAnimations {
  static Future<void> openSettingsScreenWithAnimation({
    required BuildContext context,
    required AppColor selectedMode,
    required ValueChanged<AppColor> onThemeSelected,
    required Map<AppColor, Color> seeds,
    required Offset? position,
    required Size? size,
  }) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SettingsScreen(
          selectedMode: Provider.of<ThemeProvider>(context, listen: false).appThemeColor,
          onThemeSelected: onThemeSelected,
          seeds: seeds.cast<AppColor, Color>(),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final Offset origin =
            position ??
            Offset(MediaQuery.of(context).size.width / 2, MediaQuery.of(context).size.height / 2);
        final Size iconSize = size ?? const Size(40, 40);

        final Alignment alignment = Alignment(
          (origin.dx + iconSize.width / 2) / (MediaQuery.of(context).size.width / 2) - 1,
          (origin.dy + iconSize.height / 2) / (MediaQuery.of(context).size.height / 2) - 1,
        );

        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.decelerate),
          alignment: alignment,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
    if (!context.mounted) return;
    FocusScope.of(context).unfocus();
  }
}
