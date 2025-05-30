import 'package:byewall3/screens/settings_screen/about_settings.dart';
import 'package:byewall3/ui/components/service_dialog.dart';
import 'package:byewall3/screens/settings_screen/general_settings.dart';
import 'package:byewall3/screens/settings_screen/services_settings.dart';
import 'package:byewall3/ui/app_colors.dart';
import 'package:byewall3/ui/components/floating_nav_bar.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final AppColor selectedMode;
  final ValueChanged<AppColor> onThemeSelected;
  final Map<AppColor, Color> seeds;

  const SettingsScreen({
    super.key,
    required this.selectedMode,
    required this.onThemeSelected,
    required this.seeds,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  // Configurações centralizadas de animação
  static const _AnimationConfig animConfig = _AnimationConfig(
    defaultDuration: 200,
    // longDistance: 700,
    fadeDuration: 50,
    curve: Curves.easeInOutCubic,
  );

  int selectedIndex = 0;
  int previousIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final ScrollController generalScrollController = ScrollController();
  final ScrollController serviceScrollController = ScrollController();
  final ScrollController aboutScrollController = ScrollController();

  bool _isAnimating = false;

  get selectedMode => widget.selectedMode;
  get onThemeSelected => widget.onThemeSelected;
  get seeds => widget.seeds;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: animConfig.defaultDuration),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _animationController, curve: animConfig.curve));

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isAnimating = false;
        });
      }
    });
  }

  @override
  void dispose() {
    generalScrollController.dispose();
    serviceScrollController.dispose();
    aboutScrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String localeKey(Locale locale) {
    if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
      return '${locale.languageCode}_${locale.countryCode}';
    }
    return locale.languageCode;
  }

  void _navigateToPage(int index) {
    if (selectedIndex == index) return;

    previousIndex = selectedIndex;
    setState(() {
      selectedIndex = index;
      _isAnimating = true;
    });

    // Usa a configuração centralizada para duração
    // final int distance = (previousIndex - index).abs();
    // final int duration = distance > 1 ? animConfig.longDistance : animConfig.defaultDuration;
    final int duration = animConfig.defaultDuration;

    _animationController.duration = Duration(milliseconds: duration);
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final views = [
      GeneralSettingsView(
        controller: generalScrollController,
        localeKey: localeKey,
        selectedMode: selectedMode,
        onThemeSelected: onThemeSelected,
        seeds: seeds,
      ),
      ServiceSettingsView(controller: serviceScrollController),
      AboutSettingsView(controller: aboutScrollController),
    ];

    final double iconSize = 30;
    final double itemSpacing = 12;
    final double floatingBarWidth = (views.length * (iconSize + itemSpacing)) + itemSpacing;
    final double minBarWidth = 220;
    final double barWidth = floatingBarWidth > minBarWidth ? floatingBarWidth : minBarWidth;

    return Scaffold(
      body: Stack(
        children: [
          // Sempre mostra a view atual quando não está animando
          if (!_isAnimating) views[selectedIndex],

          // Mostra a animação apenas durante a transição
          if (_isAnimating)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                // Aplicando a mesma animação para todas as transições
                return Stack(
                  children: [
                    // A tela de destino com opacidade aumentando e efeito de zoom
                    Transform.scale(
                      scale: 0.8 + (0.2 * _animation.value), // Começa em 88% e cresce até 100%
                      child: Opacity(
                        opacity: _animation.value,
                        child: views[selectedIndex], // Tela de destino
                      ),
                    ),
                    // A tela anterior (saindo) com opacidade diminuindo
                    Opacity(
                      opacity: 1 - _animation.value,
                      child: Transform.translate(
                        // Deslizamos a tela anterior para a direção apropriada
                        offset: Offset(
                          selectedIndex > previousIndex
                              ? _animation.value *
                                  screenWidth // Para a direita se avançando
                              : -_animation.value * screenWidth, // Para a esquerda se voltando
                          0,
                        ),
                        child: views[previousIndex],
                      ),
                    ),
                  ],
                );
              },
            ),

          // Floating navigation bar
          FloatingNavBar(
            size: 2,
            screenWidth: screenWidth,
            selectedIndex: selectedIndex,
            onTap: _navigateToPage,
            items: const [
              FloatingNavBarItem(icon: Icons.build_outlined, activeIcon: Icons.build),
              FloatingNavBarItem(icon: Icons.list_rounded),
              FloatingNavBarItem(icon: Icons.info_outlined, activeIcon: Icons.info),
            ],
          ),

          // FAB for adding services
          Positioned(
            left: (screenWidth - barWidth) / 2 + barWidth + 8,
            bottom: 25,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: animConfig.fadeDuration),
              opacity: selectedIndex == 1 ? 1.0 : 0.0,
              curve: animConfig.curve,
              child: SizedBox(
                height: 70,
                width: 70,
                child: FloatingActionButton(
                  onPressed: () {
                    if (selectedIndex == 1) {
                      showDialog(context: context, builder: (context) => const ServiceDialog());
                    }
                  },
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  elevation: 3,
                  mini: false,
                  child: const Icon(Icons.add),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Classe para configuração centralizada de animações
class _AnimationConfig {
  final int defaultDuration; // Duração padrão para transições adjacentes
  // final int longDistance; // Duração para transições não-adjacentes (0→2, 2→0)
  final int fadeDuration; // Duração para fade in/out
  final Curve curve; // Curva de animação padrão

  const _AnimationConfig({
    required this.defaultDuration,
    // required this.longDistance,
    required this.fadeDuration,
    required this.curve,
  });
}
