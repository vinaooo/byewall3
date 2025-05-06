import 'package:byewall3/ui/components/localized_text.dart';
import 'package:flutter/material.dart';

class CustomSliverAppBar {
  final BuildContext context;

  CustomSliverAppBar(this.context);

  SliverAppBar buildSliverAppBar(String title) {
    final double expandedHeight = MediaQuery.of(context).size.height * 0.25;
    final double minExtent =
        kToolbarHeight + MediaQuery.of(context).padding.top;
    double calculateT(double currentHeight) {
      return ((currentHeight - minExtent) / (expandedHeight - minExtent)).clamp(
        0.0,
        1.0,
      );
    }

    return SliverAppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      expandedHeight: expandedHeight,
      pinned: true,
      floating: false,
      snap: false,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double t = calculateT(constraints.maxHeight);
          final double minTitlePadding = 8.0;
          final double maxTitlePadding = 50.0;
          final double maxFontSize = 48.0;

          final double horizontalPadding =
              maxTitlePadding - (maxTitlePadding - minTitlePadding) * t;
          final double defaultFontSize =
              Theme.of(context).textTheme.titleLarge?.fontSize ?? 16.0;
          final double fontSize =
              defaultFontSize + (maxFontSize - defaultFontSize) * t;

          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                left: horizontalPadding,
                bottom: 12,
                child: LocalizedText(
                  tKey: title,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
