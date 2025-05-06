import 'package:byewall3/ui/components/custom_sliverappbar.dart';
import 'package:flutter/material.dart';

class AboutSettingsView extends StatelessWidget {
  final ScrollController controller;

  const AboutSettingsView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final customSliverAppBar = CustomSliverAppBar(context);

    return CustomScrollView(
      key: const PageStorageKey('aboutSettings'),
      controller: controller,
      slivers: [
        customSliverAppBar.buildSliverAppBar('about'),
        SliverList(
          delegate: SliverChildBuilderDelegate((
            BuildContext context,
            int index,
          ) {
            return SizedBox(
              height: 100.0,
              child: Center(
                child: Text('$index', textScaler: const TextScaler.linear(5)),
              ),
            );
          }, childCount: 20),
        ),
      ],
    );
  }
}
