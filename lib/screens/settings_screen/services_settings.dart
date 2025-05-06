import 'package:byewall3/ui/components/settings_custom_sliverappbar.dart';
import 'package:flutter/material.dart';

class ServiceSettingsView extends StatelessWidget {
  final ScrollController controller;

  const ServiceSettingsView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final customSliverAppBar = CustomSliverAppBar(context);

    return CustomScrollView(
      key: const PageStorageKey('serviceSettings'),
      controller: controller,
      slivers: [customSliverAppBar.buildSliverAppBar('services')],
    );
  }
}
