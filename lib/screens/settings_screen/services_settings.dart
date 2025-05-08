import 'package:byewall3/ui/components/custom_sliverappbar.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:byewall3/break_services/services_model.dart';

class ServiceSettingsView extends StatelessWidget {
  final ScrollController controller;

  const ServiceSettingsView({super.key, required this.controller});

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
        final services =
            box.values.toList()
              ..sort((a, b) => a.serviceName.compareTo(b.serviceName));

        return CustomScrollView(
          key: const PageStorageKey('serviceSettings'),
          controller: controller,
          slivers: [
            customSliverAppBar.buildSliverAppBar('services'),
            SliverList(
              delegate: SliverChildBuilderDelegate((
                BuildContext context,
                int index,
              ) {
                final service = services[index];
                return ListTile(
                  title: Text(service.serviceName),
                  subtitle: Text(service.serviceUrl),
                  trailing: Text(
                    service.dateAdd.toLocal().toString().split(' ')[0],
                  ),
                );
              }, childCount: services.length),
            ),
          ],
        );
      },
    );
  }
}
