import 'package:byewall3/providers/language_provider.dart';
import 'package:byewall3/providers/theme_provider.dart';
import 'package:byewall3/ui/app_colors.dart';
import 'package:flutter/material.dart';

class SelectionBox extends StatelessWidget {
  final LanguageProvider? languageProvider;
  final ThemeProvider? themeProvider;
  final BuildContext context;
  final Locale? locale;
  final ThemeMode? mode;
  final AppColor? appColor;

  const SelectionBox({
    super.key,
    this.languageProvider,
    this.themeProvider,
    required this.context,
    this.locale,
    this.mode,
    this.appColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected =
        (languageProvider != null && locale != null)
            ? languageProvider!.locale == locale
            : (themeProvider != null &&
                (themeProvider!.themeMode == mode ||
                    themeProvider!.appThemeColor == appColor));

    final Color corBox =
        HSLColor.fromColor(
          Theme.of(context).colorScheme.secondary,
        ).withSaturation(0.6).withLightness(0.77).toColor();

    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? corBox : null,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
