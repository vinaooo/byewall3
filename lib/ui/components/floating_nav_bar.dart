import 'package:flutter/material.dart';

class FloatingNavBar extends StatelessWidget {
  final double screenWidth;
  final double floatingBarWidth;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const FloatingNavBar({
    super.key,
    required this.screenWidth,
    required this.floatingBarWidth,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: (screenWidth - floatingBarWidth) / 2,
      width: floatingBarWidth,
      bottom: 25,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color:
                      selectedIndex == 0
                          ? Theme.of(context).colorScheme.primary.withAlpha(38)
                          : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    selectedIndex == 0 ? Icons.build : Icons.build_outlined,
                    color:
                        selectedIndex == 0
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context) //
                            .colorScheme.onSecondaryContainer,
                  ),
                  onPressed: () => onTap(0),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color:
                      selectedIndex == 1
                          ? Theme.of(context).colorScheme.primary.withAlpha(38)
                          : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.list_rounded,
                    color:
                        selectedIndex == 1
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context) //
                            .colorScheme.onSecondaryContainer,
                  ),
                  onPressed: () => onTap(1),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color:
                      selectedIndex == 2
                          ? Theme.of(context).colorScheme.primary.withAlpha(38)
                          : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    selectedIndex == 2 ? Icons.info : Icons.info_outlined,
                    color:
                        selectedIndex == 2
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context) //
                            .colorScheme.onSecondaryContainer,
                  ),
                  onPressed: () => onTap(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
