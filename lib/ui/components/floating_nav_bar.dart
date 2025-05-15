import 'package:flutter/material.dart';
import 'dart:math' as math;

class FloatingNavBarItem {
  final IconData icon;
  final IconData? activeIcon;
  final String? label;

  const FloatingNavBarItem({required this.icon, this.activeIcon, this.label});
}

class FloatingNavBar extends StatelessWidget {
  final double screenWidth;
  final int selectedIndex;
  final List<FloatingNavBarItem> items;
  final ValueChanged<int> onTap;
  final int size; // 1 - pequeno, 2 - médio, 3 - grande

  const FloatingNavBar({
    super.key,
    required this.screenWidth,
    required this.selectedIndex,
    required this.items,
    required this.onTap,
    this.size = 2,
  }) : assert(size >= 1 && size <= 3, 'O tamanho deve ser 1, 2 ou 3');

  @override
  Widget build(BuildContext context) {
    // Fatores de escala baseados no tamanho selecionado
    final double scaleFactor = size == 1 ? 0.8 : (size == 3 ? 1.2 : 1.0);

    // Calcula o fator de compressão baseado no número de itens
    // Quanto mais itens, menor o tamanho
    final double compressionFactor = _calculateCompressionFactor(items.length);
    final double effectiveScale = scaleFactor * compressionFactor;

    // Dimensões ajustadas ao tamanho e compressão
    final double iconSize = 30 * effectiveScale;

    // Espaçamento reduzido para size = 1
    final double itemSpacing =
        size == 1
            ? math.max(2, 6 * effectiveScale) // Espaçamento reduzido para size=1
            : math.max(4, 10 * effectiveScale); // Espaçamento normal para outros tamanhos

    final double barHeight = 70 * scaleFactor; // Mantém a altura original
    final double shadowHeight = 90 * scaleFactor;
    final double bottomPosition = 25 * scaleFactor;

    // Padding interno dos botões também reduzido para size=1
    final double buttonPadding =
        size == 1
            ? math.max(1, 5.0 * effectiveScale) // Padding reduzido
            : math.max(2, 8.0 * effectiveScale); // Padding normal

    // Padding interno da barra - aumentado para size=1
    final double internalPadding = size == 1 ? 12 * scaleFactor : 20 * scaleFactor;

    // Para size=1, calculamos a largura exata necessária para os itens
    final double itemBaseWidth = size == 1 ? 30 : 30; // Aumentado para size=1

    // Calcula o tamanho que cada item ocupa incluindo padding e espaçamento
    final double itemTotalWidth =
        size == 1
            ? (itemBaseWidth + (buttonPadding * 2) + 2) // Adicionado espaçamento extra
            : (iconSize + (buttonPadding * 2) + itemSpacing);

    // Calcula o espaço necessário para todos os itens
    // Para size=1, usamos uma fórmula mais precisa
    final double requiredWidth =
        size == 1
            ? (items.length * itemTotalWidth) +
                internalPadding // Calculado precisamente para size=1
            : (items.length * itemTotalWidth) + internalPadding;

    // Para size=1, aumentamos a largura mínima
    final double minBarWidth = size == 1 ? 200 : 220 * scaleFactor;

    // Determina a largura final da barra
    // Para size=1, usamos preferencialmente o requiredWidth para ficar mais ajustado
    final double barWidth;
    if (size == 1) {
      // Para size=1, preferimos a largura exata ou um mínimo
      barWidth = math.max(minBarWidth, requiredWidth);
    } else {
      // Para outros tamanhos, limitamos a uma porcentagem da tela
      final double widthFactor = 0.85;
      final double availableWidth = screenWidth * widthFactor;
      barWidth = math.min(availableWidth, math.max(minBarWidth, requiredWidth));
    }

    return Stack(
      children: [
        // Shadow behind floating bar
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: shadowHeight,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.13),
                    blurRadius: 40 * scaleFactor,
                    spreadRadius: 5 * scaleFactor,
                    offset: Offset(0, 5 * scaleFactor),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Floating bar
        Positioned(
          left: (screenWidth - barWidth) / 2,
          width: barWidth,
          bottom: bottomPosition,
          child: Container(
            height: barHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(barHeight / 2),
              color: Theme.of(context).colorScheme.secondaryContainer,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 2 * scaleFactor,
                  spreadRadius: 0,
                  offset: Offset(0, 3 * scaleFactor),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(barHeight / 2),
              child: Center(child: _buildNavItems(context, iconSize, itemSpacing, buttonPadding)),
            ),
          ),
        ),
      ],
    );
  }

  // Nova função para calcular o fator de compressão baseado no número de itens
  double _calculateCompressionFactor(int itemCount) {
    if (size == 1) {
      // Para tamanho pequeno, comprimir mais agressivamente
      if (itemCount <= 3) return 1.0;
      if (itemCount == 4) return 0.85;
      if (itemCount == 5) return 0.75;
      return math.max(0.6, 1.0 - (itemCount - 3) * 0.1);
    } else if (size == 2) {
      // Para tamanho médio
      if (itemCount <= 5) return 1.0;
      if (itemCount == 6) return 0.9;
      return math.max(0.7, 1.0 - (itemCount - 5) * 0.08);
    } else {
      // Para tamanho grande
      if (itemCount <= 4) return 1.0;
      if (itemCount == 5) return 0.95;
      return math.max(0.75, 1.0 - (itemCount - 4) * 0.07);
    }
  }

  Widget _buildNavItems(
    BuildContext context,
    double iconSize,
    double itemSpacing,
    double buttonPadding,
  ) {
    return Row(
      // Para size=1, usamos um espaçamento diferente para compactar mais
      mainAxisAlignment: size == 1 ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: List.generate(items.length, (index) {
        final item = items[index];
        final bool isSelected = selectedIndex == index;

        // Para size=1, aplicamos o padding horizontal diretamente
        return size == 1
            ? Padding(
              padding: EdgeInsets.symmetric(horizontal: itemSpacing / 2),
              child: _buildNavItem(
                context,
                item,
                isSelected,
                iconSize,
                buttonPadding,
                index,
              ), // Passando index
            )
            : _buildNavItem(
              context,
              item,
              isSelected,
              iconSize,
              buttonPadding,
              index,
            ); // Passando index
      }),
    );
  }

  // Extraído para um método separado para reutilização
  Widget _buildNavItem(
    BuildContext context,
    FloatingNavBarItem item,
    bool isSelected,
    double iconSize,
    double buttonPadding,
    int index, // Adicionado o parâmetro index
  ) {
    // Ajustar o feedback visual baseado no tamanho
    final double indicatorScale = size == 1 ? 0.85 : (size == 3 ? 1.2 : 1.0);

    // Controlar opacidade do background baseada no tamanho
    final int alphaValue = size == 1 ? 30 : (size == 3 ? 50 : 38);

    // Controlar o diâmetro do círculo de seleção
    final double selectionPadding = size == 1 ? 2.0 : (size == 3 ? 6.0 : 4.0);

    return Container(
      decoration: BoxDecoration(
        color:
            isSelected
                ? Theme.of(context).colorScheme.primary.withAlpha(alphaValue)
                : Colors.transparent,
        shape: BoxShape.circle,
      ),
      // Ajustando o padding do container para controlar o tamanho visual
      padding: EdgeInsets.all(selectionPadding * indicatorScale),
      child: IconButton(
        iconSize: iconSize,
        padding: EdgeInsets.all(buttonPadding),
        constraints: BoxConstraints(), // Remove restrições padrão
        visualDensity:
            size == 1 ? VisualDensity(horizontal: -4, vertical: -4) : VisualDensity.compact,
        icon: Icon(
          isSelected && item.activeIcon != null ? item.activeIcon : item.icon,
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSecondaryContainer,
          // Ajustar tamanho do ícone quando selecionado para enfatizar mais
          size: isSelected ? iconSize * (1 + (size * 0.05)) : iconSize,
        ),
        onPressed: () => onTap(index),
      ),
    );
  }
}
