import 'package:byewall3/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class LocalizedText extends StatelessWidget {
  const LocalizedText({super.key, required this.tKey, this.style});

  final String tKey;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(AppLocalizations.of(context)!.translate(tKey), style: style);
  }
}
