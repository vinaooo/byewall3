import 'package:byewall3/ui/components/custom_sliverappbar.dart';
import 'package:flutter/material.dart';
import 'package:byewall3/break_services/services_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:byewall3/break_services/services_helper.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:byewall3/ui/components/service_dialog.dart';

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
          body: Stack(
            children: [
              SlidableAutoCloseBehavior(
                child: CustomScrollView(
                  key: const PageStorageKey('serviceSettings'),
                  controller: widget.controller,
                  slivers: [
                    customSliverAppBar.buildSliverAppBar('services'),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                        if (index < services.length) {
                          final service = services[index];
                          return Slidable(
                            key: ValueKey(service.id),
                            endActionPane: ActionPane(
                              extentRatio: 0.15,
                              motion: const DrawerMotion(),
                              children: [
                                CustomSlidableAction(
                                  onPressed: (context) {
                                    ServicesHelper.removeService(service.key);
                                  },
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.error.withAlpha(200),
                                  padding: const EdgeInsets.all(0),
                                  child: Center(
                                    child: Icon(
                                      Icons.delete_outline_rounded,
                                      size: 36,
                                      color: Theme.of(context).colorScheme.onError.withAlpha(150),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onLongPress: () {
                                openEditDialog(context, service);
                              },
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      service.serviceName,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    subtitle: Text(
                                      service.serviceUrl,
                                      style: Theme.of(context)
                                          .textTheme //
                                          .labelSmall
                                          ?.copyWith(fontWeight: FontWeight.normal),
                                    ),
                                    trailing: Checkbox(
                                      value: service.isEnable,
                                      onChanged: (value) {
                                        setState(() {
                                          service.isEnable = value ?? false;
                                          service.save();
                                        });
                                      },
                                    ),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: 0.95,
                                    child: Divider(height: 1),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox(height: 90);
                        }
                      }, childCount: services.length),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
