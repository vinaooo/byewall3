import 'package:byewall3/l10n/app_localizations.dart';
import 'package:byewall3/ui/components/localized_text.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:byewall3/break_services/services_model.dart';

class AddServiceDialog extends StatelessWidget {
  const AddServiceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController urlController = TextEditingController();

    return FutureBuilder<Box<ServicesModel>>(
      future: Hive.openBox<ServicesModel>('services'),
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

        final box = snapshot.data!;

        return AlertDialog(
          title: const LocalizedText(kText: 'add_service'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)! //
                  .translate('service_name'),
                ),
              ),
              TextField(
                controller: urlController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)! //
                  .translate('service_url'),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha a dialog
              },
              child: const LocalizedText(kText: 'Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final serviceName = nameController.text.trim();
                final serviceUrl = urlController.text.trim();

                if (serviceName.isNotEmpty && serviceUrl.isNotEmpty) {
                  final newService = ServicesModel(
                    id: DateTime.now().millisecondsSinceEpoch,
                    serviceName: serviceName,
                    serviceUrl: serviceUrl,
                    dateAdd: DateTime.now(),
                  );
                  box.add(newService); // Adiciona o novo serviço ao Hive
                  Navigator.of(context).pop(); // Fecha a dialog
                }
              },
              child: const LocalizedText(kText: 'OK'),
            ),
          ],
        );
      },
    );
  }
}
