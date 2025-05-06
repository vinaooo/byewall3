import 'package:byewall3/ui/components/localized_text.dart';
import 'package:flutter/material.dart';

class DialogTitle extends StatelessWidget {
  const DialogTitle({
    super.key,
    required this.context,
    required this.icon,
    required this.title,
  });

  final BuildContext context;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Icon(icon, size: 48),
        const SizedBox(height: 16),
        LocalizedText(tKey: title),
        const SizedBox(height: 16),
      ],
    );
  }
}
