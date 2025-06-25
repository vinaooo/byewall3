import 'package:byewall3/ui/components/custom_sliverappbar.dart';
import 'package:flutter/material.dart';
import 'package:byewall3/break_services/services_model.dart';
import 'package:byewall3/break_services/services_helper.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:byewall3/ui/components/service_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ServiceSettingsView extends StatefulWidget {
  final ScrollController controller;

  const ServiceSettingsView({super.key, required this.controller});

  @override
  State<ServiceSettingsView> createState() => ServiceSettingsViewState();
}

class ServiceSettingsViewState extends State<ServiceSettingsView> {
  void openEditDialog(BuildContext context, ServicesModel service) {
    showDialog(
      context: context,
      builder: (context) {
        return ServiceDialog(
          initialService: service, // Passa o serviço para edição
        );
      },
    );
  }

  void showDeleteConfirmation(BuildContext context, ServicesModel service) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: Text('Deseja realmente excluir o serviço "${service.serviceName}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo sem fazer nada
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                ServicesHelper.removeService(service.key);
                Navigator.of(context).pop(); // Fecha o diálogo após excluir
              },
              style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final customSliverAppBar = CustomSliverAppBar(context);

    return ValueListenableBuilder(
      valueListenable: Hive.box<ServicesModel>('services').listenable(),
      builder: (context, Box<ServicesModel> box, _) {
        final services = box.values.toList();

        return Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                key: const PageStorageKey('serviceSettings'),
                controller: widget.controller,
                slivers: [
                  customSliverAppBar.buildSliverAppBar('services'),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                      if (index < services.length) {
                        final service = services[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Slidable(
                            key: Key(service.key.toString()),
                            endActionPane: ActionPane(
                              extentRatio: 0.2,
                              motion: const ScrollMotion(),
                              children: [
                                CustomSlidableAction(
                                  onPressed: (context) {
                                    showDeleteConfirmation(context, service);
                                  },
                                  backgroundColor: Theme.of(context).colorScheme.error,
                                  child: Icon(
                                    Icons.delete_forever_outlined,
                                    color: Theme.of(context).colorScheme.onError,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onLongPress: () {
                                openEditDialog(context, service);
                              },
                              child: Card(
                                elevation: 2,
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              service.serviceName,
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              service.serviceUrl,
                                              style: Theme.of(context).textTheme.labelSmall
                                                  ?.copyWith(fontWeight: FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Checkbox(
                                        value: service.isEnable,
                                        onChanged: (value) {
                                          setState(() {
                                            service.isEnable = value ?? false;
                                            service.save();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox(height: 120);
                      }
                    }, childCount: services.length + 1),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
