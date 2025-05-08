import 'package:byewall3/providers/language_provider.dart';
import 'package:byewall3/providers/theme_provider.dart';
import 'package:byewall3/ui/app_colors.dart';
import 'package:byewall3/ui/components/localized_text.dart';
import 'package:byewall3/ui/components/custom_sliverappbar.dart';
import 'package:byewall3/ui/components/custom_list_tiles.dart';
import 'package:byewall3/ui/components/tile_title_text.dart';
import 'package:byewall3/utils/settings_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GeneralSettingsView extends StatelessWidget {
  final ScrollController controller;
  final String Function(Locale) localeKey;
  final AppColor selectedMode;
  final ValueChanged<AppColor> onThemeSelected;
  final Map<AppColor, Color> seeds;

  const GeneralSettingsView({
    super.key,
    required this.controller,
    required this.localeKey,
    required this.selectedMode,
    required this.onThemeSelected,
    required this.seeds,
  });
  @override
  Widget build(BuildContext context) {
    final customSliverAppBar = CustomSliverAppBar(context);

    return CustomScrollView(
      key: const PageStorageKey('generalSettings'),
      controller: controller,
      slivers: <Widget>[
        customSliverAppBar.buildSliverAppBar('general'),
        appearenceTiles(context),
        languageTile(context),
        dataTiles(context),
      ],
    );
  }

  SliverToBoxAdapter appearenceTiles(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const TileTitleText(title: 'appearance'),
            themeModeTile(),
            accentColorTile(context),
            amoledTile(context),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter languageTile(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const TileTitleText(title: 'defaults'),
            SettingsTiles(
              border: 3, //all
              title: 'language',
              subtitle: 'language_subtitle',
              lIcon: leadingIcon(color: 'blue', icon: Icons.translate),
              tIcon: Icons.arrow_drop_down,
              onPressed: () {
                LanguageProvider.selectLanguage(context, localeKey);
              },
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter dataTiles(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const TileTitleText(title: 'your_data'),
            exportTile(context),
            resetTile(context),
            SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  Consumer<ThemeProvider> themeModeTile() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        String themeSubtitle = '';
        switch (themeProvider.themeMode) {
          case ThemeMode.system:
            themeSubtitle = 'theme_mode_system';
          case ThemeMode.light:
            themeSubtitle = 'theme_mode_light';
          case ThemeMode.dark:
            themeSubtitle = 'theme_mode_dark';
        }
        return SettingsTiles(
          border: 1,
          title: 'theme_mode',
          subtitle: themeSubtitle,
          lIcon: leadingIcon(color: 'pink', icon: Icons.brightness_6),
          tIcon: Icons.arrow_drop_down,
          onPressed: () {
            ThemeProvider.showThemeSelection(context);
          },
        );
      },
    );
  }

  Column accentColorTile(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 2),
        SettingsTiles(
          border: 0, //none
          title: 'accent_color',
          subtitle: 'choose_theme_color',
          lIcon: leadingIcon(color: 'pink', icon: Icons.color_lens),
          tIcon: Icons.circle,
          onPressed: () {
            ThemeProvider.showColorSelection(
              context: context,
              selectedMode: selectedMode,
              onThemeSelected: onThemeSelected,
              seeds: seeds,
            );
          },
        ),
      ],
    );
  }

  Column amoledTile(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 2),
        SettingsTiles(
          border: 2, //bottom
          title: 'dark_mode_amoled',
          subtitle: 'dark_mode_amoled_subtitle',
          lIcon: leadingIcon(color: 'pink', icon: Icons.nightlight_round_sharp),
          switchEnable: true,
          onPressed: () {},
        ),
      ],
    );
  }

  SettingsTiles exportTile(BuildContext context) {
    return SettingsTiles(
      border: 1, //top
      title: 'export_settings',
      subtitle: 'export_settings_subtitle',
      lIcon: leadingIcon(color: 'green', icon: Icons.download),
      onPressed: () {},
    );
  }

  Column resetTile(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 2),
        SettingsTiles(
          border: 2, //bottom
          title: 'reset_settings',
          subtitle: 'reset_settings_subtitle',
          lIcon: leadingIcon(color: 'green', icon: Icons.restore),
          onPressed: () => _showResetDialog(context),
        ),
      ],
    );
  }

  void _showResetDialog(BuildContext context) {
    final SettingsManager settingsManager = SettingsManager();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const LocalizedText(tKey: 'reset_settings'),
          content: const LocalizedText(tKey: 'reset_settings_subtitle'),
          actions: [
            TextButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                await settingsManager.clearAllKeys();
                navigator.pop(); // Fecha o diálogo
                settingsManager.closeApp(); // Fecha o aplicativo
              },
              child: const LocalizedText(tKey: 'reset'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const LocalizedText(tKey: 'cancel'),
            ),
          ],
        );
      },
    );
  }

  Stack leadingIcon({String color = '', IconData? icon}) {
    final colorMap = {
      'pink': [AppColors().pink, AppColors().darkPink],
      'blue': [AppColors().blue, AppColors().darkBlue],
      'green': [AppColors().green, AppColors().darkGreen],
    };

    final colors = colorMap[color] ?? [Colors.white, Colors.black];
    final lightColor = colors[0];
    final darkColor = colors[1];

    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.scale(scale: 2, child: Icon(Icons.circle, color: lightColor)),
        Transform.scale(scale: 1.1, child: Icon(icon, color: darkColor)),
      ],
    );
  }
}
