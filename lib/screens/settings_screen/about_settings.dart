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
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Info Section
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ByeWall',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('Version 3.0.0', style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // Developer Section with proper structure
        developerTiles(context),

        // Support Section using SettingsTiles
        supportTiles(context),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Device Info Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showDeviceInfo(context),
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Informações do Dispositivo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 90),
              ],
            ),
          ),
        ),
      ],
    );
  }

  SliverToBoxAdapter supportTiles(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const TileTitleText(title: 'Apoie o Projeto'),
            buyMeCoffeeTile(context),
            pixTile(context),
          ],
        ),
      ),
    );
  }

  SettingsTiles buyMeCoffeeTile(BuildContext context) {
    return SettingsTiles(
      border: 1, // top border
      title: 'Buy Me a Coffee',
      subtitle: 'Apoie o desenvolvimento',
      lIcon: Stack(
        alignment: Alignment.center,
        children: [
          Transform.scale(scale: 2, child: Icon(Icons.circle, color: Colors.orange.shade300)),
          Transform.scale(scale: 1.1, child: Icon(Icons.coffee, color: Colors.orange.shade800)),
        ],
      ),
      tIcon: Icons.open_in_new,
      onPressed: () => _launchUrl('https://buymeacoffee.com/vinaooo'),
    );
  }

  Column pixTile(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 2),
        SettingsTiles(
          border: 2, // bottom border
          title: 'PIX (Brasil)',
          subtitle: 'vrpedrinho@gmail.com',
          lIcon: Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(scale: 2, child: Icon(Icons.circle, color: Colors.green.shade300)),
              Transform.scale(
                scale: 1.1,
                child: Icon(Icons.currency_exchange, color: Colors.green.shade800),
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
            const TileTitleText(title: 'Desenvolvedor'),
            githubTile(context),
            telegramTile(context),
            emailTile(context),
          ],
        ),
      ),
    );
  }

  SettingsTiles githubTile(BuildContext context) {
    return SettingsTiles(
      border: 1, // top border
      title: 'GitHub',
      subtitle: 'Acesse o código fonte',
      lIcon: Stack(
        alignment: Alignment.center,
        children: [
          Transform.scale(scale: 2, child: Icon(Icons.circle, color: Colors.grey.shade100)),
          Transform.scale(scale: 1.7, child: FaIcon(FontAwesomeIcons.github, color: Colors.black)),
        ],
      ),
      tIcon: Icons.open_in_new,
      onPressed: () => _launchUrl('https://github.com/vinaooo/byewall3'),
    );
  }

  Column telegramTile(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 2),
        SettingsTiles(
          border: 0, // no border
          title: 'Telegram',
          subtitle: '@vinaooo',
          lIcon: Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(scale: 2, child: Icon(Icons.circle, color: Colors.white)),
              Transform.scale(scale: 2, child: Icon(Icons.telegram, color: Colors.blue.shade300)),
            ],
          ),
          tIcon: Icons.open_in_new,
          onPressed: () => _launchUrl('https://t.me/vinaooo'),
        ),
      ],
    );
  }

  Column emailTile(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 2),
        SettingsTiles(
          border: 2, // bottom border
          title: 'Email',
          subtitle: 'vrpedrinho@gmail.com',
          lIcon: Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(scale: 2, child: Icon(Icons.circle, color: Colors.red.shade300)),
              Transform.scale(scale: 1.1, child: Icon(Icons.email, color: Colors.white)),
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PIX copiado para a área de transferência!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showDeviceInfo(BuildContext context) async {
    final deviceInfo = DeviceInfoPlugin();
    String deviceInfoText = 'Carregando informações...';

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceInfoText = '''
Dispositivo: ${androidInfo.model}
Marca: ${androidInfo.brand}
Versão Android: ${androidInfo.version.release}
SDK: ${androidInfo.version.sdkInt}
Arquitetura: ${androidInfo.supported64BitAbis.isNotEmpty ? '64-bit' : '32-bit'}
RAM: ${(androidInfo.systemFeatures.length / 1024 / 1024).toStringAsFixed(1)} MB
''';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceInfoText = '''
Dispositivo: ${iosInfo.model}
Nome: ${iosInfo.name}
Versão iOS: ${iosInfo.systemVersion}
Identificador: ${iosInfo.identifierForVendor}
''';
      }
    } catch (e) {
      deviceInfoText = 'Erro ao obter informações do dispositivo: $e';
    }

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Informações do Dispositivo'),
            content: SingleChildScrollView(child: Text(deviceInfoText)),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Fechar')),
              TextButton(
                onPressed: () => _copyToClipboard(context, deviceInfoText),
                child: const Text('Copiar'),
              ),
            ],
          );
        },
      );
    }
  }
}
