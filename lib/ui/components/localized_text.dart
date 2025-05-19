import 'package:byewall3/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class LocalizedText extends StatelessWidget {
  const LocalizedText({super.key, required this.kText, this.style, this.oText});

  final String kText;
  final TextStyle? style;
  final String? oText;

  @override
  Widget build(BuildContext context) {
    String kText = this.kText.toLowerCase();
    if (oText != null) {
      String oText = this.oText!.toLowerCase();
      return Text(AppLocalizations.of(context)!.translate(kText) + oText, style: style);
    }
    return Text(AppLocalizations.of(context)!.translate(kText), style: style);
  }
}
