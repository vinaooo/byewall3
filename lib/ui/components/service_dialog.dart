import 'package:byewall3/l10n/app_localizations.dart';
import 'package:byewall3/ui/components/localized_text.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:byewall3/break_services/services_model.dart';
import 'package:byewall3/break_services/services_helper.dart';

class ServiceDialog extends StatefulWidget {
  final ServicesModel? initialService;

  const ServiceDialog({super.key, this.initialService});

  @override
  State<ServiceDialog> createState() => _ServiceDialogState();
}

class _ServiceDialogState extends State<ServiceDialog> {
  late TextEditingController nameController;
  late TextEditingController urlController;
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode urlFocusNode = FocusNode(); // Adicione isto

  String? nameError;
  String? urlError;
  bool attemptedSubmit = false;

  late Future<Box<ServicesModel>> _boxFuture;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.initialService?.serviceName ?? '',
    );
    urlController = TextEditingController(
      text: widget.initialService?.serviceUrl ?? '',
    );
    _boxFuture = Hive.openBox<ServicesModel>('services');
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
            ? 'O nome do serviço não pode ficar em branco.'
            : null;
    final newUrlError =
        urlController.text.trim().isEmpty
            ? 'A URL do serviço não pode ficar em branco.'
            : null;

    // Retorna diretamente em vez de chamar setState
    if (newNameError != nameError || newUrlError != urlError) {
      nameError = newNameError;
      urlError = newUrlError;
    }

    return (newNameError == null && newUrlError == null);
  }

  void _validateAndSubmit(BuildContext context) {
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

    // Cria serviço e fecha a dialog
    final newService = ServicesModel(
      id: widget.initialService?.id ?? DateTime.now().millisecondsSinceEpoch,
      serviceName: nameController.text.trim(),
      serviceUrl: urlController.text.trim(),
      dateAdd: widget.initialService?.dateAdd ?? DateTime.now(),
    );
    if (widget.initialService != null) {
      ServicesHelper.updateService(newService);
    } else {
      ServicesHelper.addService(newService);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box<ServicesModel>>(
      future: _boxFuture, // Use o futuro armazenado
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return AlertDialog(
            title: const LocalizedText(kText: 'Erro'),
            content: LocalizedText(
              kText: 'Error opening database: ',
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  focusNode: nameFocusNode, // já estava aqui
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    labelText: AppLocalizations.of(
                      context,
                    )!.translate('service_name'),
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
                    labelText: AppLocalizations.of(
                      context,
                    )!.translate('service_url'),
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
                        (attemptedSubmit &&
                                nameError != null &&
                                urlError != null)
                            ? 'Preencha todos os campos!'
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
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha a dialog
              },
              child: const LocalizedText(kText: 'Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => _validateAndSubmit(context),
              child: const LocalizedText(kText: 'OK'),
            ),
          ],
        );
      },
    );
  }
}
