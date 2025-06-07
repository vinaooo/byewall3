import 'package:byewall3/l10n/app_localizations.dart';
import 'package:byewall3/ui/components/localized_text.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:byewall3/break_services/services_model.dart';
import 'package:byewall3/break_services/services_helper.dart';

class ServiceDialog extends StatefulWidget {
  final ServicesModel? initialService;

  const ServiceDialog({super.key, this.initialService});

  @override
  State<ServiceDialog> createState() => ServiceDialogState();
}

class ServiceDialogState extends State<ServiceDialog> {
  late TextEditingController nameController;
  late TextEditingController urlController;
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode urlFocusNode = FocusNode(); // Adicione isto

  String? nameError;
  String? urlError;
  bool attemptedSubmit = false;

  late Future<Box<ServicesModel>> boxFuture;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialService?.serviceName ?? '');
    urlController = TextEditingController(text: widget.initialService?.serviceUrl ?? '');
    boxFuture = Hive.openBox<ServicesModel>('services');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    urlController.dispose();
    nameFocusNode.dispose();
    urlFocusNode.dispose(); // Libere também
    super.dispose();
  }

  // Método separado para validação
  bool validateFields() {
    final newNameError =
        nameController.text.trim().isEmpty
            ? AppLocalizations.of(context)!.translate('service_name_empty')
            : null;

    final newUrlError =
        urlController.text.trim().isEmpty
            ? AppLocalizations.of(context)!.translate('service_url_empty') // Mensagem de erro
            : (!isValidUrl(urlController.text.trim())
                ? AppLocalizations.of(context)!.translate('service_url_invalid')
                : null);

    // Atualiza os erros apenas se houver mudanças
    if (newNameError != nameError || newUrlError != urlError) {
      setState(() {
        nameError = newNameError;
        urlError = newUrlError;
      });
    }

    return (newNameError == null && newUrlError == null);
  }

  void validateAndSubmit(BuildContext context) {
    attemptedSubmit = true;
    final valid = validateFields();

    // Foco inteligente ao validar
    if (!valid) {
      setState(() {});
      if (nameError != null) {
        nameFocusNode.requestFocus();
      } else if (urlError != null) {
        urlFocusNode.requestFocus();
      }
      return;
    }

    final newService = ServicesModel(
      id: widget.initialService?.id ?? DateTime.now().millisecondsSinceEpoch,
      serviceName: nameController.text.trim(),
      serviceUrl: urlController.text.trim(),
      dateAdd: widget.initialService?.dateAdd ?? DateTime.now(),
      isEnable: true,
    );
    if (widget.initialService != null) {
      ServicesHelper.updateService(newService);
    } else {
      ServicesHelper.addService(newService);
    }
    Navigator.of(context).pop();
  }

  bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box<ServicesModel>>(
      future: boxFuture, // Use o futuro armazenado
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return AlertDialog(
            title: const LocalizedText(kText: 'Error'),
            content: LocalizedText(
              kText: 'error_opening_database',
              oText: snapshot.error.toString(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const LocalizedText(kText: 'close'),
              ),
            ],
          );
        }

        return AlertDialog(
          title: const LocalizedText(kText: 'add_service'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // importante!
                children: [
                  TextFormField(
                    controller: nameController,
                    focusNode: nameFocusNode, // já estava aqui
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      labelText: AppLocalizations.of(context)!.translate('service_name'),
                      errorText:
                          attemptedSubmit && nameError != null
                              ? ''
                              : null, // Só destaca sem mensagem
                    ),
                    onChanged: (_) {
                      if (attemptedSubmit) {
                        validateFields(); // Valida em tempo real após primeira tentativa
                      }
                    },
                  ),
                  if (nameError == null || !attemptedSubmit) SizedBox(height: 21),
                  TextFormField(
                    controller: urlController,
                    focusNode: urlFocusNode, // adicione isto
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      labelText: AppLocalizations.of(context)!.translate('service_url'),
                      errorText:
                          attemptedSubmit && urlError != null
                              ? ''
                              : null, // Só destaca sem mensagem
                    ),
                    onChanged: (_) {
                      if (attemptedSubmit) {
                        validateFields(); // Valida em tempo real após primeira tentativa
                      }
                    },
                  ),
                  if (urlError == null || !attemptedSubmit) SizedBox(height: 21),
                  // Sinalizador de erro abaixo dos campos
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          (attemptedSubmit && nameError != null && urlError != null)
                              ? AppLocalizations.of(context)!.translate('service_name_empty')
                              : '',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.left, // Alinha à esquerda
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha a dialog
              },
              child: const LocalizedText(kText: 'cancel'),
            ),
            ElevatedButton(
              onPressed: () => validateAndSubmit(context),
              child: const LocalizedText(kText: 'ok'),
            ),
          ],
        );
      },
    );
  }
}

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({required this.builder}) : super();

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Material(color: Colors.transparent, child: child);
      },
      child: child,
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  String get barrierLabel => 'Dialog barrier';
}

// Add this class below HeroDialogRoute
class DialogPageRoute<T> extends PageRoute<T> {
  final Widget Function(BuildContext) builder;
  final Rect sourceRect;

  DialogPageRoute({required this.builder, required this.sourceRect});

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final screenSize = MediaQuery.of(context).size;

        // Start position (FAB)
        final startRect = sourceRect;

        // End position (centered dialog)
        final endRect = Rect.fromCenter(
          center: Offset(screenSize.width / 2, screenSize.height / 2),
          width: screenSize.width * 0.8,
          height: screenSize.height * 0.5,
        );

        // Animate position and size
        final currentRect = Rect.lerp(startRect, endRect, animation.value)!;

        return Stack(
          children: [
            // Barrier
            Opacity(
              opacity: animation.value * barrierColor.opacity,
              child: Container(color: barrierColor.withOpacity(1.0)),
            ),
            // Animated dialog
            Positioned.fromRect(
              rect: currentRect,
              child: Material(
                color: Theme.of(context).dialogBackgroundColor,
                elevation: 4.0 * animation.value + 2.0,
                borderRadius: BorderRadius.circular(
                  24 * (1 - animation.value) + 8 * animation.value,
                ),
                child: Opacity(
                  opacity: animation.value,
                  child: animation.value > 0.5 ? child : Container(),
                ),
              ),
            ),
          ],
        );
      },
      child: child,
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  String get barrierLabel => 'Dialog barrier';
}

// Extraindo apenas o conteúdo do diálogo para reutilização
class ServiceDialogContent extends StatelessWidget {
  final ServicesModel? initialService;

  const ServiceDialogContent({super.key, this.initialService});

  @override
  Widget build(BuildContext context) {
    // Use o widget ServiceDialogState como implementação
    return ServiceDialog(initialService: initialService);
  }
}
