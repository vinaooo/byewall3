import 'package:byewall3/l10n/app_localizations.dart';
import 'package:byewall3/ui/list_tiles.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            surfaceTintColor: Colors.transparent,
            expandedHeight: 120.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                AppLocalizations.of(context)?.translate('settings') ??
                    "Settings",
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  SizedBox(
                    height: 20,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)?.translate('appearance') ??
                            "Appearance",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SettingsTiles(
                    topLeft: 20,
                    topRight: 20,
                    bottomLeft: 0,
                    bottomRight: 0,
                    title: 'Mapa',
                    subtitle: 'Veja o mapa',
                  ),
                  SizedBox(height: 5),
                  SettingsTiles(
                    topLeft: 0,
                    topRight: 0,
                    bottomLeft: 0,
                    bottomRight: 0,
                    title: 'Tema',
                    subtitle: 'Escolha o tema',
                  ),
                  SizedBox(height: 5),
                  SettingsTiles(
                    topLeft: 0,
                    topRight: 0,
                    bottomLeft: 0,
                    bottomRight: 0,
                    title: 'Idioma',
                    subtitle: 'Escolha o idioma',
                  ),
                  SizedBox(height: 5),
                  SettingsTiles(
                    topLeft: 0,
                    topRight: 0,
                    bottomLeft: 0,
                    bottomRight: 0,
                    title: 'Sobre',
                    subtitle: 'Sobre o aplicativo',
                  ),
                  SizedBox(height: 5),
                  SettingsTiles(
                    topLeft: 0,
                    topRight: 0,
                    bottomLeft: 0,
                    bottomRight: 0,
                    title: 'Ajuda',
                    subtitle: 'Ajuda e suporte',
                  ),
                  SizedBox(height: 5),
                  SettingsTiles(
                    topLeft: 0,
                    topRight: 0,
                    bottomLeft: 20,
                    bottomRight: 20,
                    title: 'Notificações',
                    subtitle: 'Gerenciar notificações',
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((
              BuildContext context,
              int index,
            ) {
              return Container(
                // color: index.isOdd ? Colors.white : Colors.black12,
                height: 100.0,
                child: Center(
                  child: Text('$index', textScaler: const TextScaler.linear(5)),
                ),
              );
            }, childCount: 20),
          ),
        ],
      ),
    );
  }
}
