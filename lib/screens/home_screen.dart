import 'package:byewall3/providers/theme_provider.dart';
import 'package:byewall3/screens/settings_screen/settings_screen.dart';
import 'package:byewall3/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final AppColor selectedMode;
  final ValueChanged<AppColor> onThemeSelected;
  final Map<AppColor, Color> seeds;

  const HomeScreen({
    super.key,
    required this.selectedMode,
    required this.onThemeSelected,
    required this.seeds,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;
  final GlobalKey _settingsIconKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _openSettingsScreenWithAnimation(BuildContext context) async {
    // Obtém a posição global do ícone
    final RenderBox? renderBox =
        _settingsIconKey.currentContext?.findRenderObject() as RenderBox?;
    final Offset? position = renderBox?.localToGlobal(Offset.zero);
    final Size? size = renderBox?.size;

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SettingsScreen(
          selectedMode:
              Provider.of<ThemeProvider>(context, listen: false).appThemeColor,
          onThemeSelected: widget.onThemeSelected,
          seeds: widget.seeds,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Se não conseguir a posição, faz um fade/scale do centro
        final Offset origin =
            position ??
            Offset(
              MediaQuery.of(context).size.width / 2,
              MediaQuery.of(context).size.height / 2,
            );
        final Size iconSize = size ?? const Size(40, 40);

        // Calcula o ponto de origem relativo à tela
        final Alignment alignment = Alignment(
          (origin.dx + iconSize.width / 2) /
                  (MediaQuery.of(context).size.width / 2) -
              1,
          (origin.dy + iconSize.height / 2) /
                  (MediaQuery.of(context).size.height / 2) -
              1,
        );

        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.decelerate),
          alignment: alignment,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
    // Remove o foco ao retornar do SettingsScreen
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double expandedHeight = screenHeight * 0.35;

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              expandedHeight: expandedHeight,
              pinned: true,
              floating: false,
              snap: false,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        left: 8,
                        right: 8,
                        bottom: 0,
                        child: TextField(
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.getTileColor(context),
                            labelText: 'Break the wall',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                            prefixIcon: const Icon(Icons.south_america),
                            suffixIcon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              transitionBuilder: (child, animation) {
                                final rotate = Tween(
                                  begin: 0.75,
                                  end: 1.0,
                                ).animate(animation);
                                return RotationTransition(
                                  turns: rotate,
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                              layoutBuilder:
                                  (currentChild, previousChildren) => Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      if (currentChild != null) currentChild,
                                    ],
                                  ),
                              child: GestureDetector(
                                key:
                                    !_hasFocus
                                        ? _settingsIconKey
                                        : null, // Key no GestureDetector
                                behavior:
                                    HitTestBehavior
                                        .opaque, // Garante área de toque maior
                                onTap: () async {
                                  if (_hasFocus) {
                                    _focusNode.unfocus();
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: const Text('Ação da seta'),
                                            content: const Text(
                                              'Você clicou na seta para a direita!',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.of(
                                                          context,
                                                        ).pop(),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                    );
                                  } else {
                                    _focusNode.canRequestFocus = false;
                                    _openSettingsScreenWithAnimation(context);
                                    _focusNode.canRequestFocus = true;
                                  }
                                },
                                child: Container(
                                  width:
                                      48, // Tamanho mínimo confortável para toque
                                  height: 48,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    _hasFocus
                                        ? Icons.arrow_forward
                                        : Icons.settings_outlined,
                                  ),
                                ),
                              ),
                            ),
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
                    child: Text(
                      '$index',
                      textScaler: const TextScaler.linear(5),
                    ),
                  ),
                );
              }, childCount: 20),
            ),
          ],
        ),
      ),
    );
  }
}
