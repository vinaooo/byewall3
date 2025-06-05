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

  late final List<Widget?> _viewCache = List.filled(3, null);

  Widget _getView(int index) {
    if (_viewCache[index] == null) {
      switch (index) {
        case 0:
          _viewCache[index] = GeneralSettingsView(
            controller: generalScrollController,
            localeKey: localeKey,
            selectedMode: widget.selectedMode,
            onThemeSelected: widget.onThemeSelected,
            seeds: widget.seeds,
          );
          break;
        case 1:
          _viewCache[index] = ServiceSettingsView(controller: serviceScrollController);
          break;
        case 2:
          _viewCache[index] = AboutSettingsView(controller: aboutScrollController);
          break;
      }
    }
    return _viewCache[index]!;
  }

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
    if (selectedIndex == index || _isAnimating) return;

    // Pré-carregar a próxima view antes da animação para evitar jank
    _getView(index);

    previousIndex = selectedIndex;
    setState(() {
      selectedIndex = index;
      _isAnimating = true;
    });

    _animationController.duration = Duration(milliseconds: animConfig.defaultDuration);
    _animationController.forward(from: 0.0);
  }

  // Constantes do layout da barra
  static const double _iconSize = 30;
  static const double _itemSpacing = 12;
  static const double _minBarWidth = 220;
  static const double _fabBottomMargin = 25;
  static const double _fabSideMargin = 8;
  static const double _fabSize = 70;
  static const Widget _fabIcon = Icon(Icons.add);

  // Simplificar o cálculo da largura da barra
  double _calculateBarWidth(int viewCount) {
    final double floatingBarWidth = (viewCount * (_iconSize + _itemSpacing)) + _itemSpacing;
    return floatingBarWidth > _minBarWidth ? floatingBarWidth : _minBarWidth;
  }

  // Extrair widget para a animação
  // Otimizar para evitar recálculos em cada frame
  Widget _buildAnimatedTransition() {
    // Precalcular valores usados na transformação
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isForward = selectedIndex > previousIndex;

    // Usar constantes para valores de corte - evita recálculos em cada frame
    const double visibilityThreshold = 0.01;
    const double scaleBase = 0.8;
    const double scaleVariation = 0.2;

    final previousView = _getView(previousIndex);
    final currentView = _getView(selectedIndex);

    return AnimatedBuilder(
      animation: _animation,
      // Uso do child para widgets estáticos
      child: Column(children: [previousView, currentView]),
      builder: (context, child) {
        final double animValue = _animation.value;
        final double reverseValue = 1 - animValue;

        // Extraindo views do child
        final previousView = (child as Column).children[0];
        final currentView = (child).children[1];

        return Stack(
          children: [
            // Tela de destino - apenas renderiza se visível
            if (animValue > visibilityThreshold)
              RepaintBoundary(
                child: Transform.scale(
                  scale: scaleBase + (scaleVariation * animValue),
                  child: Opacity(opacity: animValue, child: currentView),
                ),
              ),

            // Tela anterior - apenas renderiza se visível
            if (reverseValue > visibilityThreshold)
              RepaintBoundary(
                child: Opacity(
                  opacity: reverseValue,
                  child: Transform.translate(
                    offset: Offset(
                      isForward ? animValue * screenWidth : -animValue * screenWidth,
                      0,
                    ),
                    child: previousView,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Cache valores do MediaQuery para evitar múltiplas chamadas
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final double barWidth = _calculateBarWidth(_viewCache.length);
    final fabLeftPosition = (screenWidth - barWidth) / 2 + barWidth + _fabSideMargin;

    // Resto do código permanece o mesmo

    return Scaffold(
      body: Stack(
        children: [
          // Sempre mostra a view atual quando não está animando
          if (!_isAnimating) _getView(selectedIndex),

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
          Positioned(
            left: fabLeftPosition,
            bottom: _fabBottomMargin,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: animConfig.fadeDuration),
              opacity: selectedIndex == 1 ? 1.0 : 0.0,
              curve: animConfig.curve,
              child: IgnorePointer(
                ignoring: selectedIndex != 1,
                child: SizedBox(
                  height: _fabSize,
                  width: _fabSize,
                  child: FloatingActionButton(
                    onPressed: () {
                      // Custom animation without nested Heroes
                      final RenderBox buttonBox = context.findRenderObject() as RenderBox;
                      final buttonPosition = buttonBox.localToGlobal(Offset.zero);
                      final buttonSize = buttonBox.size;

                      Navigator.of(context).push(
                        DialogPageRoute(
                          builder: (context) => ServiceDialog(initialService: null),
                          sourceRect: Rect.fromLTWH(
                            buttonPosition.dx,
                            buttonPosition.dy,
                            buttonSize.width,
                            buttonSize.height,
                          ),
                        ),
                      );
                    },
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    elevation: 3,
                    child: _fabIcon,
                  ),
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
  final int defaultDuration;
  final int fadeDuration;
  final Curve curve;

  const _AnimationConfig({
    required this.defaultDuration,
    required this.fadeDuration,
    required this.curve,
  });
}
