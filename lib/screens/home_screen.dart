import 'package:byewall3/break_services/services_helper.dart';
import 'package:byewall3/break_services/services_model.dart';
import 'package:byewall3/providers/theme_provider.dart';
import 'package:byewall3/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:byewall3/ui/animations/main_screen_animations.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;
import 'package:byewall3/ui/components/localized_text.dart';

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
  int? selectedChipId;
  final TextEditingController textController = TextEditingController();
  String? errorText;

  late Future<Box<ServicesModel>> servicesBoxFuture;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {
        hasFocus = focusNode.hasFocus;
      });
    });

    // Inicialize o Future apenas uma vez
    servicesBoxFuture = ServicesHelper.openBox();
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
                          controller: textController,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.getTileColor(context),
                            label: LocalizedText(
                              kText: 'break_the_wall',
                              style: TextStyle(
                                color:
                                    errorText != null ? Theme.of(context).colorScheme.error : null,
                              ),
                            ),
                            errorText: errorText,
                            // Reserve space for error text even when null
                            errorStyle: TextStyle(
                              color: errorText != null ? null : Colors.transparent,
                              height: 0.01, // Very small but not zero to maintain space
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color:
                                    errorText != null
                                        ? Theme.of(context).colorScheme.error
                                        : Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color:
                                    errorText != null
                                        ? Theme.of(context).colorScheme.error
                                        : Theme.of(context).colorScheme.primary,
                                width: 2.0,
                              ),
                            ),
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
                                          final urlText = textController.text.trim();

                                          if (urlText.isEmpty || !_isValidUrl(urlText)) {
                                            setState(() {
                                              errorText = ''; // Define erro
                                            });
                                          } else {
                                            setState(() {
                                              errorText = null; // Limpa o erro
                                            });
                                            _abrirLink(urlText);
                                          }
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
                                        child: SizedBox(
                                          key: settingsIconKey,
                                          width: 48,
                                          height: 48,
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
            SliverFillRemaining(
              child: ValueListenableBuilder<Box<ServicesModel>>(
                valueListenable: Hive.box<ServicesModel>('services').listenable(),
                builder: (context, box, _) {
                  if (box.isEmpty) {
                    return const Center(
                      child: LocalizedText(
                        kText: 'no_services_available', // Tradução aplicada
                      ),
                    );
                  }

                  // Filtra os serviços com isEnable == true
                  final enabledServices = box.values.where((service) => service.isEnable).toList();

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 4.0,
                      runSpacing: 4.0,
                      children:
                          enabledServices.map((service) {
                            return SelectableChip(
                              label: service.serviceName,
                              isSelected: selectedChipId == service.id,
                              onSelected: () {
                                setState(() {
                                  selectedChipId = selectedChipId == service.id ? null : service.id;
                                });
                              },
                            );
                          }).toList(),
                    ),
                  );
                },
              ),
            ),
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

  Future<void> _abrirLink(String urlText) async {
    final Uri url = Uri.parse(urlText);

    if (defaultTargetPlatform == TargetPlatform.android) {
      // Use flutter_custom_tabs para Android
      try {
        await custom_tabs.launchUrl(url, customTabsOptions: const custom_tabs.CustomTabsOptions());
      } catch (e) {
        throw Exception('Não foi possível abrir o link com Custom Tabs: $e');
      }
    } else {
      // Use url_launcher para outras plataformas
      if (!await url_launcher.launchUrl(url, mode: url_launcher.LaunchMode.externalApplication)) {
        throw Exception('Não foi possível abrir o link');
      }
    }
  }

  bool _isValidUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }
}

class SelectableChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const SelectableChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  State<SelectableChip> createState() => _SelectableChipState();
}

class _SelectableChipState extends State<SelectableChip> {
  @override
  Widget build(BuildContext context) {
    return RawChip(
      padding: const EdgeInsets.all(0),
      label: Text(
        widget.label,
        style: Theme.of(context)
            .textTheme //
            .labelSmall
            ?.copyWith(fontWeight: FontWeight.normal),
      ),
      selected: widget.isSelected,
      selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
      showCheckmark: false, // Remove o ícone de check
      onSelected: (_) => widget.onSelected(),
    );
  }
}
