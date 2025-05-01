import 'package:byewall3/l10n/app_localizations.dart';
import 'package:byewall3/providers/language_provider.dart';
import 'package:byewall3/providers/theme_provider.dart';
import 'package:byewall3/ui/app_colors.dart';
import 'package:byewall3/ui/components/settings_custom_sliverappbar.dart';
import 'package:byewall3/ui/components/settings_list_tiles.dart';
import 'package:byewall3/ui/components/settings_title_text.dart';
import 'package:byewall3/utils/settings_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GeneralSettingsView extends StatelessWidget {
  final ScrollController controller;
  final SettingsManager settingsManager;
  final String Function(Locale) localeKey;
  final AppThemeMode selectedMode;
  final ValueChanged<AppThemeMode> onThemeSelected;
  final Map<AppThemeMode, Color> seeds;

  const GeneralSettingsView({
    super.key,
    required this.controller,
    required this.settingsManager,
    required this.localeKey,
    required this.selectedMode,
    required this.onThemeSelected,
    required this.seeds,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double expandedHeight = screenHeight * 0.25;
    final double minExtent =
        kToolbarHeight + MediaQuery.of(context).padding.top;

    final customSliverAppBar = CustomSliverAppBar(context);

    return CustomScrollView(
      key: const PageStorageKey('generalSettings'),
      controller: controller,
      slivers: <Widget>[
        customSliverAppBar.buildSliverAppBar(
          AppLocalizations.of(context)!.translate('general'),
          expandedHeight,
          minExtent,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TitleText(
                  title: AppLocalizations.of(context)!.translate('appearance'),
                ),
                themeModeTile(),
                SizedBox(height: 2),
                accentColorTile(context),
                SizedBox(height: 2),
                amoledTile(context),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TitleText(
                  title: AppLocalizations.of(context)!.translate('defaults'),
                ),
                languageTile(context),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TitleText(
                  title: AppLocalizations.of(context)!.translate('your_data'),
                ),
                exportTile(context),
                SizedBox(height: 2),
                resetTile(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Consumer<ThemeProvider> themeModeTile() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        String themeSubtitle = '';
        switch (themeProvider.themeMode) {
          case ThemeMode.system:
            themeSubtitle = AppLocalizations.of(
              context,
            )!.translate('theme_mode_system');
          case ThemeMode.light:
            themeSubtitle = AppLocalizations.of(
              context,
            )!.translate('theme_mode_light');
          case ThemeMode.dark:
            themeSubtitle = AppLocalizations.of(
              context,
            )!.translate('theme_mode_dark');
        }
        return SettingsTiles(
          border: 1,
          title: AppLocalizations.of(context)!.translate('theme_mode'),
          subtitle: themeSubtitle,
          icon: Icons.arrow_drop_down,
          switchEnable: false,
          onPressed: () {
            ThemeProvider.showThemeSelection(context);
          },
        );
      },
    );
  }

  SettingsTiles resetTile(BuildContext context) {
    return SettingsTiles(
      border: 2, //bottom
      title: AppLocalizations.of(context)!.translate('reset_settings'),
      subtitle: AppLocalizations.of(
        context,
      )!.translate('reset_settings_subtitle'),
      icon: Icons.restore,
      switchEnable: false,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.translate('reset_settings'),
              ),
              content: Text(
                AppLocalizations.of(
                  context,
                )!.translate('reset_settings_subtitle'),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    await settingsManager.clearAllKeys();
                    navigator.pop(); // Fecha o diálogo
                    settingsManager.closeApp(); // Fecha o aplicativo
                  },
                  child: Text(AppLocalizations.of(context)!.translate('reset')),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fecha o diálogo
                  },
                  child: Text(
                    AppLocalizations.of(context)!.translate('cancel'),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  SettingsTiles exportTile(BuildContext context) {
    return SettingsTiles(
      border: 1, //top
      title: AppLocalizations.of(context)!.translate('export_settings'),
      subtitle: AppLocalizations.of(
        context,
      )!.translate('export_settings_subtitle'),
      icon: Icons.download,
      switchEnable: false,
      onPressed: () {},
    );
  }

  SettingsTiles languageTile(BuildContext context) {
    return SettingsTiles(
      border: 3, //all
      title: AppLocalizations.of(context)!.translate('language'),
      subtitle: AppLocalizations.of(context)!.translate('language_subtitle'),
      icon: Icons.arrow_drop_down,
      switchEnable: false,
      onPressed: () {
        LanguageProvider.selectLanguage(context, localeKey);
      },
    );
  }

  SettingsTiles amoledTile(BuildContext context) {
    return SettingsTiles(
      border: 2, //bottom
      title: AppLocalizations.of(context)!.translate('dark_mode_amoled'),
      subtitle: AppLocalizations.of(
        context,
      )!.translate('dark_mode_amoled_subtitle'),
      icon: null,
      switchEnable: true,
      onPressed: () {},
    );
  }

  SettingsTiles accentColorTile(BuildContext context) {
    return SettingsTiles(
      border: 0, //none
      title: AppLocalizations.of(context)!.translate('accent_color'),
      subtitle: AppLocalizations.of(context)!.translate('choose_theme_color'),
      icon: Icons.circle,
      switchEnable: false,
      onPressed: () {
        ThemeProvider.showColorSelection(
          context: context,
          selectedMode: selectedMode,
          onThemeSelected: onThemeSelected,
          seeds: seeds,
        );
      },
    );
  }
}
