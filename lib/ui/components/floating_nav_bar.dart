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
  }) : assert(size >= 1 && size <= 3, 'Size should be 1, 2 or 3');

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

    // Espaçamento otimizado para exatamente 3, 4 ou 5 itens
    final double itemSpacing;
    if (size == 1) {
      // Espaçamento específico para cada quantidade de itens
      switch (items.length) {
        case 3:
          itemSpacing = 6 * effectiveScale;
          break;
        case 4:
          itemSpacing = 4 * effectiveScale;
          break;
        case 5:
          itemSpacing = 3 * effectiveScale;
          break;
        default:
          itemSpacing = 4 * effectiveScale;
      }
    } else if (size == 3) {
      itemSpacing = 8 * effectiveScale; // Sem alteração para size 3
    } else {
      itemSpacing = 10 * effectiveScale; // Sem alteração para size 2
    }

    final double barHeight = 70 * scaleFactor; // Mantém a altura original
    final double shadowHeight = 90 * scaleFactor;
    final double bottomPosition = 25 * scaleFactor;

    // Padding interno dos botões também reduzido para size=1
    final double buttonPadding =
        size == 1
            ? math.max(1, 5.0 * effectiveScale) // Padding reduzido
            : math.max(2, 8.0 * effectiveScale); // Padding normal

    // Padding interno da barra otimizado para 3, 4 ou 5 itens
    final double internalPadding;
    if (size == 1) {
      // Padding específico para cada quantidade de itens
      switch (items.length) {
        case 3:
          internalPadding = 18 * scaleFactor;
          break;
        case 4:
          internalPadding = 36 * scaleFactor;
          break;
        case 5:
          internalPadding = 56 * scaleFactor;
          break;
        default:
          internalPadding = 8 * scaleFactor;
      }
    } else {
      internalPadding = 20 * scaleFactor; // Sem alteração para sizes 2 e 3
    }

    // Calcula a largura de cada item (ícone + padding do botão)
    final double singleItemWidth = iconSize + (buttonPadding * 2);

    // Calcula a largura total com base no número de itens e espaçamento entre eles
    final double itemsWidth = (singleItemWidth * items.length);
    final double spacingsWidth = itemSpacing * (items.length - 1);

    // Largura total: soma de todos os itens + espaçamentos entre eles + padding interno nas bordas
    final double barWidth = itemsWidth + spacingsWidth + (internalPadding * 2);

    // Remove all the minimum width calculations and percentages
    final double finalBarWidth = barWidth;

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
                    color: Colors.black.withValues(alpha: 0.13),
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
          left: (screenWidth - finalBarWidth) / 2,
          width: finalBarWidth,
          bottom: bottomPosition,
          child: Container(
            height: barHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(barHeight / 2),
              color: Theme.of(context).colorScheme.secondaryContainer,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
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
      // Otimizado para exatamente 3, 4 ou 5 itens
      switch (itemCount) {
        case 3:
          return 1.0;
        case 4:
          return 0.80; // Leve compressão para 4 itens
        case 5:
          return 0.65; // Compressão maior para 5 itens
        default:
          return 0.90; // Valor padrão para outros casos (não deveria ocorrer)
      }
    } else if (size == 2) {
      // Tamanho médio - valores específicos para 3, 4 ou 5 itens
      switch (itemCount) {
        case 3:
        case 4:
          return 1.0; // Sem compressão para 3-4 itens
        case 5:
          return 0.95; // Compressão mínima para 5 itens
        default:
          return 1.0;
      }
    } else {
      // Tamanho grande - valores específicos para 3, 4 ou 5 itens
      switch (itemCount) {
        case 3:
        case 4:
          return 1.0; // Sem compressão para 3-4 itens
        case 5:
          return 0.95; // Compressão mínima para 5 itens
        default:
          return 1.0;
      }
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
