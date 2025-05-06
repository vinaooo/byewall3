import 'package:byewall3/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class TileTitleText extends StatelessWidget {
  final String title;
  const TileTitleText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0, top: 4.0),
          child: Text(
            AppLocalizations.of(context)!.translate(title),
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
