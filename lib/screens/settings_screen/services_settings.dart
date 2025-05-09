import 'package:byewall3/ui/components/custom_sliverappbar.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:byewall3/break_services/services_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ServiceSettingsView extends StatefulWidget {
  final ScrollController controller;

  const ServiceSettingsView({super.key, required this.controller});

  @override
  State<ServiceSettingsView> createState() => _ServiceSettingsViewState();
}

class _ServiceSettingsViewState extends State<ServiceSettingsView> {
  @override
  Widget build(BuildContext context) {
    final customSliverAppBar = CustomSliverAppBar(context);

    return FutureBuilder<Box<ServicesModel>>(
      future: Hive.openBox<ServicesModel>('services'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final box = snapshot.data!;

        return ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<ServicesModel> box, _) {
            final services =
                box.values.toList()
                  ..sort((a, b) => a.serviceName.compareTo(b.serviceName));
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
                          delegate: SliverChildBuilderDelegate((
                            BuildContext context,
                            int index,
                          ) {
                            final service = services[index];
                            return Slidable(
                              key: ValueKey(service.key),
                              endActionPane: ActionPane(
                                extentRatio: 0.2,
                                motion: const DrawerMotion(),
                                children: [
                                  CustomSlidableAction(
                                    onPressed: (context) {
                                      box.delete(service.key);
                                    },
                                    backgroundColor:
                                        Theme.of(
                                          context,
                                        ).colorScheme.errorContainer,
                                    child: Icon(
                                      Icons.delete,
                                      size: 30,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onErrorContainer,
                                    ),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(service.serviceName),
                                subtitle: Text(service.serviceUrl),
                              ),
                            );
                          }, childCount: services.length),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 100,
                    child: FloatingActionButton(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      onPressed: () {
                        // Sua ação ao clicar
                      },
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
