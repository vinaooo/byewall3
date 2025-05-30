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

  late final List<Widget> _views;

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
      if (status == AnimationStatus.completed && _isAnimating) {
        setState(() {
          _isAnimating = false;
        });
      }
    });

    // Inicialização das views
    _views = [
      GeneralSettingsView(
        controller: generalScrollController,
        localeKey: localeKey,
        selectedMode: widget.selectedMode,
        onThemeSelected: widget.onThemeSelected,
        seeds: widget.seeds,
      ),
      ServiceSettingsView(controller: serviceScrollController),
      AboutSettingsView(controller: aboutScrollController),
    ];
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

  // Constantes do layout da barra
  static const double _iconSize = 30;
  static const double _itemSpacing = 12;
  static const double _minBarWidth = 220;
  static const double _fabBottomMargin = 25;
  static const double _fabSideMargin = 8;
  static const double _fabSize = 70;

  // Simplificar o cálculo da largura da barra
  double _calculateBarWidth(int viewCount) {
    final double floatingBarWidth = (viewCount * (_iconSize + _itemSpacing)) + _itemSpacing;
    return floatingBarWidth > _minBarWidth ? floatingBarWidth : _minBarWidth;
  }

  // Extrair widget para a animação
  Widget _buildAnimatedTransition() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          children: [
            // Tela de destino
            Transform.scale(
              scale: 0.8 + (0.2 * _animation.value),
              child: Opacity(opacity: _animation.value, child: _views[selectedIndex]),
            ),
            // Tela anterior
            Opacity(
              opacity: 1 - _animation.value,
              child: Transform.translate(
                offset: Offset(
                  selectedIndex > previousIndex
                      ? _animation.value * MediaQuery.of(context).size.width
                      : -_animation.value * MediaQuery.of(context).size.width,
                  0,
                ),
                child: _views[previousIndex],
              ),
            ),
          ],
        );
      },
    );
  }

  // Extrair widget para o FAB
  Widget _buildServiceFab(double screenWidth, double barWidth) {
    return Positioned(
      left: (screenWidth - barWidth) / 2 + barWidth + _fabSideMargin,
      bottom: _fabBottomMargin,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: animConfig.fadeDuration),
        opacity: selectedIndex == 1 ? 1.0 : 0.0,
        curve: animConfig.curve,
        child: SizedBox(
          height: _fabSize,
          width: _fabSize,
          child: FloatingActionButton(
            onPressed: () {
              if (selectedIndex == 1) {
                showDialog(context: context, builder: (context) => const ServiceDialog());
              }
            },
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            elevation: 3,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double barWidth = _calculateBarWidth(_views.length);

    return Scaffold(
      body: Stack(
        children: [
          // Sempre mostra a view atual quando não está animando
          if (!_isAnimating) _views[selectedIndex],

          // Mostra a animação apenas durante a transição
          if (_isAnimating) _buildAnimatedTransition(),

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
          _buildServiceFab(screenWidth, barWidth),
        ],
      ),
    );
  }
}

// Classe para configuração centralizada de animações
class _AnimationConfig {
  final int defaultDuration;
  final int fadeDuration;
  final Curve curve;

  const _AnimationConfig({
    required this.defaultDuration,
    required this.fadeDuration,
    required this.curve,
  });
}
