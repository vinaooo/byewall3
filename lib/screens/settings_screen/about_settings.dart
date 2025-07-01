import 'package:byewall3/ui/components/custom_sliverappbar.dart';
import 'package:byewall3/ui/components/custom_list_tiles.dart';
import 'package:byewall3/ui/components/tile_title_text.dart';
import 'package:byewall3/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Add this import
import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';

class AboutSettingsView extends StatelessWidget {
  final ScrollController controller;

  const AboutSettingsView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final customSliverAppBar = CustomSliverAppBar(context);

    return CustomScrollView(
      key: const PageStorageKey('aboutSettings'),
      controller: controller,
      slivers: [
        customSliverAppBar.buildSliverAppBar('about'),

        developerTiles(context),
        supportTiles(context),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TileTitleText(title: 'app_information'),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SettingsTiles(
                    border: 3,
                    title: 'byewall',
                    subtitle: 'loading_version',
                    lIcon: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.scale(
                          scale: 2,
                          child: Icon(
                            Icons.circle,
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          ),
                        ),
                        Transform.scale(
                          scale: 1.1,
                          child: Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    tIcon: Icons.chevron_right,
                    onPressed: () => _showDeviceInfo(context),
                  );
                }
                if (snapshot.hasError) {
                  return SettingsTiles(
                    border: 3,
                    title: 'byewall',
                    subtitle: 'error_getting_version',
                    lIcon: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.scale(
                          scale: 2,
                          child: Icon(
                            Icons.circle,
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          ),
                        ),
                        Transform.scale(
                          scale: 1.1,
                          child: Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    tIcon: Icons.chevron_right,
                    onPressed: () => _showDeviceInfo(context),
                  );
                }
                final version = snapshot.data?.version ?? 'unknown';
                return SettingsTiles(
                  border: 3,
                  title: 'byewall',
                  subtitle: 'version  $version',
                  lIcon: Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.scale(
                        scale: 2,
                        child: Icon(
                          Icons.circle,
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        ),
                      ),
                      Transform.scale(
                        scale: 1.1,
                        child: Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  tIcon: Icons.chevron_right,
                  onPressed: () => _showDeviceInfo(context),
                );
              },
            ),
          ),
        ),

        SliverToBoxAdapter(child: const SizedBox(height: 90)),
      ],
    );
  }

  SliverToBoxAdapter supportTiles(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const TileTitleText(title: 'support_the_project'),
            buyMeCoffeeTile(context),
            pixTile(context),
          ],
        ),
      ),
    );
  }

  SettingsTiles buyMeCoffeeTile(BuildContext context) {
    final appColors = AppColors();
    return SettingsTiles(
      border: 1, // top border
      title: 'buy_me_a_coffee',
      subtitle: 'support_development',
      lIcon: Stack(
        alignment: Alignment.center,
        children: [
          Transform.scale(scale: 2, child: Icon(Icons.circle, color: appColors.orangeLight)),
          Transform.scale(scale: 1.1, child: Icon(Icons.coffee, color: appColors.orangeDark)),
        ],
      ),
      tIcon: Icons.open_in_new,
      onPressed: () => _launchUrl('https://buymeacoffee.com/vinaooo'),
    );
  }

  Column pixTile(BuildContext context) {
    final appColors = AppColors();
    return Column(
      children: [
        const SizedBox(height: 2),
        SettingsTiles(
          border: 2, // bottom border
          title: 'pix_brazil',
          subtitle: 'vrpedrinho@gmail.com',
          lIcon: Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(scale: 2, child: Icon(Icons.circle, color: appColors.pixLight)),
              Transform.scale(
                scale: 1.1,
                child: Icon(Icons.currency_exchange, color: appColors.pixDark),
              ),
            ],
          ),
          tIcon: Icons.copy,
          onPressed: () => _copyToClipboard(context, 'vrpedrinho@gmail.com'),
        ),
      ],
    );
  }

  SliverToBoxAdapter developerTiles(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const TileTitleText(title: 'developer'),
            githubTile(context),
            telegramTile(context),
            emailTile(context),
          ],
        ),
      ),
    );
  }

  SettingsTiles githubTile(BuildContext context) {
    // Detecta se o tema atual é escuro
    final appColors = AppColors();
    return SettingsTiles(
      border: 1, // top border
      title: 'github',
      subtitle: 'access_the_source_code',
      lIcon: Stack(
        alignment: Alignment.center,
        children: [
          Transform.scale(scale: 1.9, child: Icon(Icons.circle, color: appColors.githubLight)),
          Transform.scale(
            scale: 1.7,
            child: FaIcon(FontAwesomeIcons.github, color: appColors.githubDark),
          ),
        ],
      ),
      tIcon: Icons.open_in_new,
      onPressed: () => _launchUrl('https://github.com/vinaooo/byewall3'),
    );
  }

  Column telegramTile(BuildContext context) {
    final appColors = AppColors();
    return Column(
      children: [
        const SizedBox(height: 2),
        SettingsTiles(
          border: 0, // no border
          title: 'telegram',
          subtitle: '@vinaooo',
          lIcon: Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(scale: 2, child: Icon(Icons.circle, color: appColors.telegramLight)),
              Transform.scale(scale: 2, child: Icon(Icons.telegram, color: appColors.telegramDark)),
            ],
          ),
          tIcon: Icons.open_in_new,
          onPressed: () => _launchUrl('https://t.me/vinaooo'),
        ),
      ],
    );
  }

  Column emailTile(BuildContext context) {
    final appColors = AppColors();
    return Column(
      children: [
        const SizedBox(height: 2),
        SettingsTiles(
          border: 2, // bottom border
          title: 'email',
          subtitle: 'vrpedrinho@gmail.com',
          lIcon: Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(scale: 2, child: Icon(Icons.circle, color: appColors.emailLight)),
              Transform.scale(scale: 1.1, child: Icon(Icons.email, color: appColors.emailDark)),
            ],
          ),
          tIcon: Icons.open_in_new,
          onPressed: () => _launchUrl('mailto:vrpedrinho@gmail.com'),
        ),
      ],
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

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  void _showDeviceInfo(BuildContext context) async {
    final deviceInfo = DeviceInfoPlugin();
    String deviceInfoText = 'Loading information...';

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceInfoText = '''
Device: ${androidInfo.model}
Brand: ${androidInfo.brand}
Android Version: ${androidInfo.version.release}
SDK: ${androidInfo.version.sdkInt}
Architecture: ${androidInfo.supported64BitAbis.isNotEmpty ? '64-bit' : '32-bit'}
RAM: ${(androidInfo.systemFeatures.length / 1024 / 1024).toStringAsFixed(1)} MB
''';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceInfoText = '''
Device: ${iosInfo.model}
Name: ${iosInfo.name}
iOS Version: ${iosInfo.systemVersion}
Identifier: ${iosInfo.identifierForVendor}
''';
      }
    } catch (e) {
      deviceInfoText = 'Error getting device information: $e';
    }

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Device Information'),
            content: SingleChildScrollView(child: Text(deviceInfoText)),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
              FilledButton(
                onPressed: () {
                  _copyToClipboard(context, deviceInfoText);
                  Navigator.of(context).pop(); // Close dialog after copying
                },
                child: const Text('Copy'),
              ),
            ],
          );
        },
      );
    }
  }
}
