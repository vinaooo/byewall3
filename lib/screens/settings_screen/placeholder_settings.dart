import 'package:flutter/material.dart';

class PlaceholderSettingsView extends StatelessWidget {
  const PlaceholderSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Placeholder', style: Theme.of(context).textTheme.headlineMedium));
  }
}
