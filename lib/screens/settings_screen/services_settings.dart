import 'package:byewall3/l10n/app_localizations.dart';
import 'package:byewall3/ui/components/settings_custom_sliverappbar.dart';
import 'package:flutter/material.dart';

class ServiceSettingsView extends StatelessWidget {
  final ScrollController controller;

  const ServiceSettingsView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double expandedHeight = screenHeight * 0.25;
    final double minExtent =
        kToolbarHeight + MediaQuery.of(context).padding.top;

    final customSliverAppBar = CustomSliverAppBar(context);

    return CustomScrollView(
      key: const PageStorageKey('serviceSettings'),
      controller: controller,
      slivers: [
        customSliverAppBar.buildSliverAppBar(
          AppLocalizations.of(context)!.translate('services'),
          expandedHeight,
          minExtent,
        ),
      ],
    );
  }
}
