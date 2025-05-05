import 'package:byewall3/providers/theme_provider.dart';
import 'package:byewall3/screens/settings_screen/settings_screen.dart';
import 'package:byewall3/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final AppThemeMode selectedMode;
  final ValueChanged<AppThemeMode> onThemeSelected;
  final Map<AppThemeMode, Color> seeds;

  const HomeScreen({
    super.key,
    required this.selectedMode,
    required this.onThemeSelected,
    required this.seeds,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double expandedHeight = screenHeight * 0.35;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            expandedHeight: expandedHeight,
            pinned: true,
            floating: false,
            snap: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 8, right: 8),
                child: IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () async {
                    final themeProvider = Provider.of<ThemeProvider>(
                      context,
                      listen: false,
                    );
                    await Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder:
                            (context) => SettingsScreen(
                              selectedMode: themeProvider.appThemeMode,
                              onThemeSelected: onThemeSelected,
                              seeds: seeds,
                            ),
                      ),
                    );
                  },
                ),
              ),
            ],
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      left: 8, // Remova o uso de horizontalPadding
                      right: 48,
                      bottom: 0,
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.getTileColor(
                            context,
                          ), // cor do fundo
                          hintText: 'Pesquisar...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16, // mais confortável para Material 3
                            horizontal: 16,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                          ), // opcional, para visual mais comum
                        ),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SliverFillRemaining(child: Column(children: [Text('teste')])),
          SliverList(
            delegate: SliverChildBuilderDelegate((
              BuildContext context,
              int index,
            ) {
              return SizedBox(
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
