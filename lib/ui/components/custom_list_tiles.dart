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
  final bool checkboxEnable;
  final bool? checkboxValue;
  final ValueChanged<bool?>? onCheckboxChanged;
  final VoidCallback? onLongPress;

  const SettingsTiles({
    super.key,
    required this.border,
    required this.title,
    required this.subtitle,
    required this.onPressed,
    required this.lIcon,
    this.tIcon,
    this.switchEnable = false,
    this.checkboxEnable = false,
    this.checkboxValue,
    this.onCheckboxChanged,
    this.onLongPress,
  });

  static const WidgetStateProperty<Icon> thumbIcon = WidgetStateProperty<Icon>.fromMap(
    <WidgetStatesConstraint, Icon>{
      WidgetState.selected: Icon(Icons.check),
      WidgetState.any: Icon(Icons.close),
    },
  );

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
    return RoundedRectangleBorder(borderRadius: _getBorderRadius() ?? BorderRadius.zero);
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

    return ClipRRect(
      borderRadius: _getBorderRadius() ?? BorderRadius.zero,
      child: Material(
        color: AppColors.getSolidTileColor(context),
        child: InkWell(
          splashColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
          highlightColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.04),
          onTap: !switchEnable && !checkboxEnable ? onPressed : null,
          onLongPress: onLongPress,
          child: ListTile(
            enabled: _widgetEnabled(context, themeProvider),
            shape: _getShape(),
            hoverColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.04),
            tileColor: AppColors.getSolidTileColor(context),
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child:
                  checkboxEnable
                      ? Text(title, style: Theme.of(context).textTheme.titleMedium)
                      : LocalizedText(kText: title, style: Theme.of(context).textTheme.titleMedium),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child:
                  checkboxEnable
                      ? Text(
                        subtitle,
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.normal),
                      )
                      : LocalizedText(
                        kText: subtitle,
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.normal),
                      ),
            ),
            leading: Padding(padding: const EdgeInsets.only(left: 8.0), child: lIcon),
            trailing:
                checkboxEnable
                    ? Checkbox(value: checkboxValue, onChanged: onCheckboxChanged)
                    : switchEnable
                    ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 36.0, child: VerticalDivider(thickness: 1.0)),
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
                                  ? themeProvider.dynamicColor ?? AppColors.seeds[AppColor.dynamic]
                                  : AppColors.seeds[themeProvider.appThemeColor])
                              : null,
                    ),
            onTap:
                checkboxEnable
                    ? () => onCheckboxChanged?.call(!(checkboxValue ?? false))
                    : switchEnable
                    ? () => toggleAndSaveBlackBackground(!themeProvider.useBlackBackground)
                    : onPressed,
            onLongPress: onLongPress,
          ),
        ),
      ),
    );
  }
}
