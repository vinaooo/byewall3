import 'package:byewall3/ui/components/localized_text.dart';
import 'package:flutter/material.dart';

/// Um widget que exibe o título de uma tile com estilo personalizado.
///
/// Use este widget para títulos de seções em listas de configurações.
class TileTitleText extends StatelessWidget {
  /// O texto do título a ser exibido.
  final String title;

  /// Cria um [TileTitleText].
  ///
  /// The text is already localized, so no need to pass a LocalizedString.
  ///
  /// Exemplo de uso:
  /// ```dart
  /// Text(TileTitleText(title: 'Configurações'))
  /// ```
  ///
  const TileTitleText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0, top: 4.0),
          child: LocalizedText(
            kText: title,
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
