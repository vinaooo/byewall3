import 'package:byewall3/ui/app_colors.dart';
import 'package:byewall3/providers/theme_provider.dart';
import 'package:byewall3/ui/components/localized_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsTiles extends StatelessWidget {
  final int border; // 0 = none, 1 = top, 2 = bottom, 3 = all
  final String title;
  final String subtitle;
  final VoidCallback onPressed;
  final Stack lIcon;
  final IconData? tIcon;
  final bool switchEnable;

  const SettingsTiles({
    super.key,
    required this.border,
    required this.title,
    required this.subtitle,
    required this.onPressed,
    required this.lIcon,
    this.tIcon,
    this.switchEnable = false,
  });

  static const WidgetStateProperty<Icon> thumbIcon =
      WidgetStateProperty<Icon>.fromMap(<WidgetStatesConstraint, Icon>{
        WidgetState.selected: Icon(Icons.check),
        WidgetState.any: Icon(Icons.close),
      });

  BorderRadius? _getBorderRadius() {
    switch (border) {
      case 1:
        return const BorderRadius.vertical(top: Radius.circular(20.0));
      case 2:
        return const BorderRadius.vertical(bottom: Radius.circular(20.0));
      case 3:
        return BorderRadius.circular(20.0);
      default:
        return null;
    }
  }

  RoundedRectangleBorder _getShape() {
    return RoundedRectangleBorder(
      borderRadius: _getBorderRadius() ?? BorderRadius.zero,
    );
  }

  bool _widgetEnabled(BuildContext context, ThemeProvider themeProvider) {
    return switchEnable ? themeProvider.isDarkMode(context) : true;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    void toggleAndSaveBlackBackground(bool value) {
      themeProvider.toggleBlackBackground(value);
      themeProvider.saveBlackBackground(value);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: _getBorderRadius(),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: !switchEnable ? onPressed : null,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.getTileColor(context),
            borderRadius: _getBorderRadius(),
          ),
          child: ListTile(
            enabled: _widgetEnabled(context, themeProvider),
            shape: _getShape(),
            hoverColor: Colors.transparent,
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: LocalizedText(
                tKey: title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: LocalizedText(
                tKey: subtitle,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.normal),
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: lIcon,
            ),
            trailing:
                switchEnable
                    ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 36.0,
                          child: VerticalDivider(thickness: 1.0),
                        ),
                        Switch(
                          thumbIcon: thumbIcon,
                          value: themeProvider.useBlackBackground,
                          onChanged:
                              _widgetEnabled(context, themeProvider)
                                  ? toggleAndSaveBlackBackground
                                  : null,
                        ),
                      ],
                    )
                    : Icon(
                      tIcon,
                      color:
                          tIcon == Icons.circle
                              ? (themeProvider.appThemeColor == AppColor.dynamic
                                  ? themeProvider.dynamicColor ??
                                      AppColors.seeds[AppColor.dynamic]
                                  : AppColors.seeds[themeProvider
                                      .appThemeColor])
                              : null,
                    ),
            onTap:
                switchEnable
                    ? () => toggleAndSaveBlackBackground(
                      !themeProvider.useBlackBackground,
                    )
                    : onPressed,
          ),
        ),
      ),
    );
  }
}
