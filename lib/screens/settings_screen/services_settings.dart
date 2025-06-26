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

  @override
  Widget build(BuildContext context) {
    final customSliverAppBar = CustomSliverAppBar(context);

    return ValueListenableBuilder(
      valueListenable: Hive.box<ServicesModel>('services').listenable(),
      builder: (context, Box<ServicesModel> box, _) {
        final services = box.values.toList();

        return Scaffold(
          body: SlidableAutoCloseBehavior(
            child: Stack(
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
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            child: Stack(
                              children: [
                                // Fundo vermelho que se estende do centro até a direita
                                Positioned(
                                  top: 0,
                                  bottom: 0,
                                  right: 0,
                                  width: 120, // Largura fixa para cobrir área do slide
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.error,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                                // Slidable card principal
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Slidable(
                                    key: Key(service.key.toString()),
                                    groupTag: 'services',
                                    endActionPane: ActionPane(
                                      extentRatio: 0.15,
                                      motion: const ScrollMotion(),
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.error,
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                ServicesHelper.removeService(service.key);
                                              },
                                              child: Center(
                                                child: Icon(
                                                  Icons.delete_forever_outlined,
                                                  size: 32,
                                                  color: Theme.of(context).colorScheme.onError,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    child: GestureDetector(
                                      onLongPress: () {
                                        openEditDialog(context, service);
                                      },
                                      child: Card(
                                        elevation: 4,
                                        margin: EdgeInsets.zero,
                                        color: Theme.of(context).colorScheme.surface,
                                        shadowColor: Theme.of(context).colorScheme.shadow,
                                        surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
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
                                                      style:
                                                          Theme.of(context).textTheme.titleMedium,
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
                                ),
                              ],
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
          ),
        );
      },
    );
  }
}
