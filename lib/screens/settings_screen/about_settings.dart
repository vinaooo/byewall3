import 'package:byewall3/ui/components/custom_sliverappbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info_plus/device_info_plus.dart';
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

                // Developer Info Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Desenvolvedor',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        const Text('Vina', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 16),

                        // GitHub
                        InkWell(
                          onTap: () => _launchUrl('https://github.com/vinaooo'),
                          child: const Row(
                            children: [
                              Icon(Icons.code, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'GitHub',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Telegram
                        InkWell(
                          onTap: () => _launchUrl('https://t.me/vinaooo'),
                          child: const Row(
                            children: [
                              Icon(Icons.telegram, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Telegram: @vinaooo',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Email
                        InkWell(
                          onTap: () => _launchUrl('mailto:vrpedrinho@gmail.com'),
                          child: const Row(
                            children: [
                              Icon(Icons.email, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'vrpedrinho@gmail.com',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Support Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Apoie o Projeto',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),

                        // Buy Me a Coffee
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _launchUrl('https://buymeacoffee.com/vinaooo'),
                            icon: const Icon(Icons.coffee),
                            label: const Text('Buy Me a Coffee'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // PIX Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.currency_exchange, color: Colors.green.shade700),
                                  const SizedBox(width: 8),
                                  Text(
                                    'PIX (Brasil)',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'vrpedrinho@gmail.com',
                                      style: TextStyle(fontSize: 14, fontFamily: 'monospace'),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed:
                                        () => _copyToClipboard(context, 'vrpedrinho@gmail.com'),
                                    icon: const Icon(Icons.copy, size: 20),
                                    tooltip: 'Copiar PIX',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

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
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
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
