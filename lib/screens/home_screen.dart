import 'package:byewall3/providers/theme_provider.dart';
import 'package:byewall3/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:byewall3/ui/animations/main_screen_animations.dart';

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
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final FocusNode focusNode = FocusNode();
  bool hasFocus = false;
  final GlobalKey settingsIconKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {
        hasFocus = focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
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
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.getTileColor(context),
                            labelText: 'Break the wall',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                            prefixIcon: const Icon(Icons.south_america),
                            suffixIcon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              transitionBuilder: (child, animation) {
                                final rotate = Tween(begin: 0.75, end: 1.0).animate(animation);
                                return RotationTransition(
                                  turns: rotate,
                                  child: FadeTransition(opacity: animation, child: child),
                                );
                              },
                              layoutBuilder:
                                  (currentChild, previousChildren) => Stack(
                                    alignment: Alignment.center,
                                    children: [if (currentChild != null) currentChild],
                                  ),
                              child:
                                  hasFocus
                                      ? GestureDetector(
                                        key: const ValueKey('arrow'),
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          focusNode.unfocus();
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
                                                      onPressed: () => Navigator.of(context).pop(),
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                ),
                                          );
                                        },
                                        child: Container(
                                          width: 48,
                                          height: 48,
                                          alignment: Alignment.center,
                                          child: const Icon(Icons.arrow_forward),
                                        ),
                                      )
                                      : GestureDetector(
                                        key: const ValueKey('settings'),
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () async {
                                          final RenderBox? renderBox =
                                              settingsIconKey.currentContext?.findRenderObject()
                                                  as RenderBox?;
                                          final Offset? position = renderBox?.localToGlobal(
                                            Offset.zero,
                                          );
                                          final Size? size = renderBox?.size;
                                          await MainScreenAnimations.openSettingsScreenWithAnimation(
                                            context: context,
                                            selectedMode:
                                                Provider.of<ThemeProvider>(
                                                  context,
                                                  listen: false,
                                                ).appThemeColor,
                                            onThemeSelected: widget.onThemeSelected,
                                            seeds: widget.seeds,
                                            position: position,
                                            size: size,
                                          );
                                        },
                                        child: Container(
                                          key: settingsIconKey,
                                          width: 48,
                                          height: 48,
                                          alignment: Alignment.center,
                                          child: const Icon(Icons.settings_outlined),
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
              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                return SizedBox(
                  height: 100.0,
                  child: Center(child: Text('$index', textScaler: const TextScaler.linear(5))),
                );
              }, childCount: 20),
            ),
          ],
        ),
      ),
    );
  }
}
